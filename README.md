# oingg-ratios-ts

從 [oingg-mops-ts](../oingg-mops-ts) 已寫入資料庫的季度財報資料（損益表、資產負債表、現金流量表）計算財務比率，目前只做 ROE。本服務**只讀**，不擁有任何表的 schema、不做 migration，也不向 MOPS 抓取資料——資料必須先透過 oingg-mops-ts 的 ingest API 寫入才能被查到。

## 技術棧

- TypeScript + `tsx`（開發期直接跑 `.ts`，不用先編譯）
- `ultimate-express`（Express 相容 API）
- Prisma + PostgreSQL（**與 oingg-mops-ts 共用同一個 Neon 資料庫**，本服務只讀）
- Zod（request 驗證）
- Swagger（`swagger-jsdoc` 從路由檔的 JSDoc 註解自動產生文件）

## 快速開始

```bash
pnpm install          # postinstall 會自動跑 prisma generate
pnpm dev              # tsx watch src/index.ts，預設監聽 :8081
```

`.env` 需要 `DATABASE_URL`（帶 `-pooler`，給 runtime 用）、`DIRECT_URL`（不帶 `-pooler`，只用來 `prisma db pull` 內省，本服務不會拿它做 migration）——兩者跟 oingg-mops-ts 的 `.env` 是同一組連線字串。

啟動後可到 `http://localhost:8081/api-docs` 看 Swagger UI 手動測試。

## 架構

跟 oingg-mops-ts 同一套 `src/shared`、`src/adapters`、`src/domains` 慣例，但因為本服務不做 ingest，`domains/roe/` 只有 `types.ts` / `service.ts`（DB 查詢 + 計算）/ `controller.ts` / `route.ts`，沒有 `parser.ts` / `ingest.ts`。

`src/shared/rocQuarter.ts` 是從 oingg-mops-ts 同名檔案複製、只保留 `getPastNQuarters` 的精簡版（本服務不判斷「最新應公告季度」，也不需要 `getQuarterEndDate`）。

## `prisma/schema.prisma` 是唯讀鏡像

三個 model（`QuarterlyIncomeStatement`、`QuarterlyBalanceSheet`、`QuarterlyCashFlowStatement`）是用 `node node_modules/prisma/build/index.js db pull` 對既有資料庫內省後，手動整理成跟 oingg-mops-ts 原本 schema 一致的 camelCase + `@map` 命名風格。**永遠不要對這些表跑 `prisma migrate`**——表格定義變更一律由 oingg-mops-ts 負責。如果 oingg-mops-ts 那邊改了 schema，重新跑一次 `db pull` 內省、對照調整即可（見 schema 檔開頭註解）。

`pnpm-workspace.yaml`（`blockExoticSubdeps: false` + `allowBuilds`）是從 oingg-mops-ts 複製過來的——`ultimate-express` 依賴 `uWebSockets.js`（git 來源的 exotic subdependency），沒有這個設定 `pnpm install` 會失敗，且這個設定**不能**用簡單的 `.npmrc` 達成。

`prisma/schema.prisma` 除了三張季度財報表，還有 oingg-mops-ts 新增的 `CapitalStockHistory`（`capital_stock_history`）——公司每次股本變動（現金增資、盈餘/公積轉增資、合併、減資…）生效當月一筆，是「流通股數/面額」最準確的資料源，查某一季對應的股數要取 `effectiveYear`/`effectiveMonth`（**西元年**，注意跟其他表的民國年 `year` 不是同一套曆法）小於等於目標季度的最新一筆。EPS/每股淨值等需要流通股數的指標都應該查這張表，不要用「股本 ÷ 10」去估——這條路線（原本設計了一張人工維護的面額例外表）已經作廢，因為這張表能直接給出真實歷史數字。

## `prisma/analysis/schema.prisma` 是本服務自己擁有的第二個資料庫

跟上面「唯讀鏡像」的 `prisma/schema.prisma` 不同，`prisma/analysis/schema.prisma` 連到獨立的 Neon 專案 **oingg-analysis**（`.env` 的 `ANALYSIS_DATABASE_URL` / `ANALYSIS_DIRECT_URL`），本服務自己擁有這裡的 schema/migration，存的是**算完的投資指標結果**（不是原始財報資料）。每個指標各自一張表，因為算法/週期不一樣（ROE 有單季/年化/TTM，之後 Beta 之類可能是半年/一年），不共用一套通用結構。目前只有：

- **`RoeResult`**（`roe_result`）：`GET /api/ratios/roe` 每次算完會 upsert 一筆進去（依 `symbol` + `year` + `season` + `dataType` + `subsidiaryCompanyId`），欄位對應 `src/domains/roe/types.ts` 的 `RoeResult`。寫入失敗只會記 log，不會讓 API 回傳失敗——存檔是附加行為，不是這支 API 的主要契約。

這個 schema 有自己的 generator output（`generated/analysis-client`，已加入 `.gitignore`，`postinstall` 會一併產生），跟主 schema 的 `@prisma/client` 不會互相覆蓋。改動這裡的 model 用：

```bash
pnpm prisma:analysis:migrate   # 產生並套用 migration（不要對 prisma/schema.prisma 那份跑這個）
pnpm prisma:analysis:studio    # Prisma Studio 開這個 DB
```

## API 一覽

| Method + Path | 說明 |
|---|---|
| `GET /api/ratios/roe` | 計算單一公司單一季度的 ROE（單季、單季年化、TTM 三種數值） |

Query 參數：`companyId`、`year`（民國年）、`season`（`'1'`~`'4'`）為必填；`dataType`（`'1'`=個別, `'2'`=合併，預設 `'2'`）、`subsidiaryCompanyId`（預設空字串）選填。

## ROE 計算口徑（未來 session 接手前務必看）

現在**只做 ROE**，其他比率（ROA、流動比率、以現金流量表為基礎的比率等）尚未實作，範圍由使用者於 2026-08-19 明確拍板「先只做 ROE 就好」，暫不擴充。

- **欄位選擇**：淨利、權益都優先採用「歸屬於母公司」口徑（`netIncomeAttributableToParent` / `equityAttributableToParent`），分子分母範圍一致；缺漏時（例如遇到 oingg-mops-ts `parser.ts` 的「模糊比對防呆」把欄位解析成 `null` 的公司）退回用整體數字（`netIncome` / `totalEquity`）。回應的 `netIncome.fieldUsed` / `equity.fieldUsed` 會標明實際用了哪個欄位。
- **`roeQuarterlyPct`**：單季（未年化）ROE = 本季淨利 / 本季期末權益 x 100。用的是**期末權益**，不是期初期末平均——這是刻意的簡化選擇（v1 優先求簡單、可驗證），如果之後要改成平均權益，需要額外查詢上一季（或去年 Q4）的資產負債表。
- **`roeQuarterlyAnnualizedPct`**：`roeQuarterlyPct` 簡單 x4，不是用近四季實際加總算出來的年化數字，僅供快速估算參考。
- **`roeTtmPct`**：近四季（含本季）淨利加總 / 本季期末權益 x 100。近四季任何一季缺資料，或該季淨利欄位是 `null`，就整個 TTM 回傳 `null`（缺的季度列在 `ttm.quartersMissing`），不會用部分資料湊數字。
- **查無資料不是錯誤**：資料庫查無該季資料，或關鍵欄位是 `null`，端點仍回傳 `200`，相關 ROE 欄位是 `null`，原因寫在 `warnings` 裡——因為「這季公司還沒申報」或「這欄位還沒抓」是正常情境，不是伺服器錯誤。
- 已用台積電（2330）114Q2 合併報表實測驗證：單季淨利 3,982.7 億元、期末權益 45,810.7 億元，算出單季 ROE 8.69%（數字量級與台積電 2025 Q2 實際公告淨利相符）。

## 已知缺口 / Backlog

- **只有 ROE**：ROA、流動比率/速動比率、以現金流量表為基礎的比率（如 OCF/淨利）都還沒做，且尚未決定要不要做、怎麼做。
- **ROE 用期末權益而非期初期末平均權益**：見上方「ROE 計算口徑」，是刻意的 v1 簡化，非 bug。
- **沒有自動化測試**：跟 oingg-mops-ts 一樣，目前靠實測真實資料驗證，沒有 unit test。
- **沒有身份驗證**：跟 oingg-mops-ts 的 ingest API 一樣，目前完全開放。
- **ESM import 不帶 `.js` 副檔名**：跟 oingg-mops-ts 相同慣例與理由（`tsconfig.json` 用 `moduleResolution: "Bundler"` + `tsx` 執行，非原生 Node ESM）。
