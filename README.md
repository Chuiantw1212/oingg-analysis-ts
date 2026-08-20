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

跟 oingg-mops-ts 同一套 `src/shared`、`src/adapters`、`src/domains` 慣例，但因為本服務不做 ingest，每個指標的 domain 只有 `types.ts` / `service.ts`（DB 查詢 + 計算）/ `controller.ts` / `route.ts`，沒有 `parser.ts` / `ingest.ts`。

`src/domains` 底下依指標性質分兩層：

- **`domains/fundamentals/`**：直接從財報三表（+ 股本歷史）算出來的基礎指標——`roe`、`bvps`、`eps`、`revenuePerShare`、`cashFlowPerShare`。每個都是「單一計算方式，頂多拆單季/年化/TTM 三個口徑」，不摻額外假設。
- **`domains/guru/`**：組合多個基礎指標、通常還要加市場價格或成長率假設的「大師公式」，例如 PEGY（Peter Lynch）、Graham Number、Piotroski F-Score、Magic Formula（Greenblatt）——這類指標帶有主觀假設或特定投資人流派的判斷，跟 `fundamentals` 那種「直接算出來的數字」性質不同，所以分開放。目前這層還沒有任何指標，資料夾要等第一個大師指標實作時才會建立。

這個分層只影響 `src/domains` 底下的資料夾結構，**API 路徑不變**——`/api/ratios/eps`、`/api/ratios/bvps` 等既有 endpoint 照舊，之後 guru 指標也會掛在同一個扁平的 `/api/ratios/*` 底下（例如 `/api/ratios/pegy`），不會因為程式碼分層多一層路徑。

`src/shared/rocQuarter.ts` 是從 oingg-mops-ts 同名檔案複製、只保留 `getPastNQuarters` 的精簡版（本服務不判斷「最新應公告季度」，也不需要 `getQuarterEndDate`）。

## `prisma/schema.prisma` 是唯讀鏡像

三個 model（`QuarterlyIncomeStatement`、`QuarterlyBalanceSheet`、`QuarterlyCashFlowStatement`）是用 `node node_modules/prisma/build/index.js db pull` 對既有資料庫內省後，手動整理成跟 oingg-mops-ts 原本 schema 一致的 camelCase + `@map` 命名風格。**永遠不要對這些表跑 `prisma migrate`**——表格定義變更一律由 oingg-mops-ts 負責。如果 oingg-mops-ts 那邊改了 schema，重新跑一次 `db pull` 內省、對照調整即可（見 schema 檔開頭註解）。

`pnpm-workspace.yaml`（`blockExoticSubdeps: false` + `allowBuilds`）是從 oingg-mops-ts 複製過來的——`ultimate-express` 依賴 `uWebSockets.js`（git 來源的 exotic subdependency），沒有這個設定 `pnpm install` 會失敗，且這個設定**不能**用簡單的 `.npmrc` 達成。

`prisma/schema.prisma` 除了三張季度財報表，還有 oingg-mops-ts 新增的 `CapitalStockHistory`（`capital_stock_history`）——公司每次股本變動（現金增資、盈餘/公積轉增資、合併、減資…）生效當月一筆，是「流通股數/面額」最準確的資料源，查某一季對應的股數要取 `effectiveYear`/`effectiveMonth`（**西元年**，注意跟其他表的民國年 `year` 不是同一套曆法）小於等於目標季度的最新一筆。EPS/每股淨值等需要流通股數的指標都應該查這張表，不要用「股本 ÷ 10」去估——這條路線（原本設計了一張人工維護的面額例外表）已經作廢，因為這張表能直接給出真實歷史數字。

## `prisma/analysis/schema.prisma` 是本服務自己擁有的第二個資料庫

跟上面「唯讀鏡像」的 `prisma/schema.prisma` 不同，`prisma/analysis/schema.prisma` 連到獨立的 Neon 專案 **oingg-analysis**（`.env` 的 `ANALYSIS_DATABASE_URL` / `ANALYSIS_DIRECT_URL`），本服務自己擁有這裡的 schema/migration，存的是**算完的投資指標結果**（不是原始財報資料）。每個指標各自一張表，因為算法/週期不一樣（ROE 有單季/年化/TTM，之後 Beta 之類可能是半年/一年），不共用一套通用結構。目前只有：

- **`RoeResult`**（`roe_result`）：`GET /api/ratios/roe` 每次算完會 upsert 一筆進去（依 `symbol` + `year` + `season` + `dataType` + `subsidiaryCompanyId`），欄位對應 `src/domains/fundamentals/roe/types.ts` 的 `RoeResult`。寫入失敗只會記 log，不會讓 API 回傳失敗——存檔是附加行為，不是這支 API 的主要契約。
- **`BvpsResult`**（`bvps_result`）：`GET /api/ratios/bvps` 的持久化結果，欄位對應 `src/domains/fundamentals/bvps/types.ts` 的 `BvpsResult`。同樣是 upsert、寫入失敗不影響回傳。
- **`EpsResult`**（`eps_result`）：`GET /api/ratios/eps` 的持久化結果，欄位對應 `src/domains/fundamentals/eps/types.ts` 的 `EpsResult`。單季、單季年化、TTM 三個 EPS 數值都是這張表的欄位（`epsQuarterly` / `epsQuarterlyAnnualized` / `epsTtm`），不是各自開表——跟 `RoeResult` 同一種結構。同樣是 upsert、寫入失敗不影響回傳。
- **`RevenuePerShareResult`**（`revenue_per_share_result`）：`GET /api/ratios/revenue-per-share` 的持久化結果，欄位對應 `src/domains/fundamentals/revenuePerShare/types.ts` 的 `RevenuePerShareResult`。跟 `EpsResult` 同一種單季/年化/TTM 三欄位結構。
- **`CashFlowPerShareResult`**（`cash_flow_per_share_result`）：`GET /api/ratios/cash-flow-per-share` 的持久化結果，欄位對應 `src/domains/fundamentals/cashFlowPerShare/types.ts` 的 `CashFlowPerShareResult`。OCF 跟 FCF 兩個指標共用同一張表，各自都有單季/年化/TTM 三欄位。

這個 schema 有自己的 generator output（`generated/analysis-client`，已加入 `.gitignore`，`postinstall` 會一併產生），跟主 schema 的 `@prisma/client` 不會互相覆蓋。改動這裡的 model 用：

```bash
pnpm prisma:analysis:migrate   # 產生並套用 migration（不要對 prisma/schema.prisma 那份跑這個）
pnpm prisma:analysis:studio    # Prisma Studio 開這個 DB
```

## API 一覽

| Method + Path | 說明 |
|---|---|
| `GET /api/ratios/roe` | 計算單一公司單一季度的 ROE（單季、單季年化、TTM 三種數值） |
| `GET /api/ratios/bvps` | 計算單一公司單一季度的 BVPS（每股淨值） |
| `GET /api/ratios/eps` | 計算單一公司單一季度的 EPS（單季、單季年化、TTM 三種數值） |
| `GET /api/ratios/revenue-per-share` | 計算單一公司單一季度的每股營收（單季、單季年化、TTM 三種數值） |
| `GET /api/ratios/cash-flow-per-share` | 計算單一公司單一季度的每股營業現金流（OCF）與每股自由現金流（FCF） |

Query 參數（五支 API 共用同一組）：`companyId`、`year`（民國年）、`season`（`'1'`~`'4'`）為必填；`dataType`（`'1'`=個別, `'2'`=合併，預設 `'2'`）、`subsidiaryCompanyId`（預設空字串）選填。

## ROE 計算口徑（未來 session 接手前務必看）

- **欄位選擇**：淨利、權益都優先採用「歸屬於母公司」口徑（`netIncomeAttributableToParent` / `equityAttributableToParent`），分子分母範圍一致；缺漏時（例如遇到 oingg-mops-ts `parser.ts` 的「模糊比對防呆」把欄位解析成 `null` 的公司）退回用整體數字（`netIncome` / `totalEquity`）。回應的 `netIncome.fieldUsed` / `equity.fieldUsed` 會標明實際用了哪個欄位。
- **`roeQuarterlyPct`**：單季（未年化）ROE = 本季淨利 / 本季期末權益 x 100。用的是**期末權益**，不是期初期末平均——這是刻意的簡化選擇（v1 優先求簡單、可驗證），如果之後要改成平均權益，需要額外查詢上一季（或去年 Q4）的資產負債表。
- **`roeQuarterlyAnnualizedPct`**：`roeQuarterlyPct` 簡單 x4，不是用近四季實際加總算出來的年化數字，僅供快速估算參考。
- **`roeTtmPct`**：近四季（含本季）淨利加總 / 本季期末權益 x 100。近四季任何一季缺資料，或該季淨利欄位是 `null`，就整個 TTM 回傳 `null`（缺的季度不會另外存欄位，只會列在 `warnings` 的文字訊息裡），不會用部分資料湊數字。
- **查無資料不是錯誤**：資料庫查無該季資料，或關鍵欄位是 `null`，端點仍回傳 `200`，相關 ROE 欄位是 `null`，原因寫在 `warnings` 裡——因為「這季公司還沒申報」或「這欄位還沒抓」是正常情境，不是伺服器錯誤。
- 已用台積電（2330）114Q2 合併報表實測驗證：單季淨利 3,982.7 億元、期末權益 45,810.7 億元，算出單季 ROE 8.69%（數字量級與台積電 2025 Q2 實際公告淨利相符）。

## BVPS 計算口徑

- **權益欄位選擇**：跟 ROE 一樣優先採用「歸屬於母公司」口徑（`equityAttributableToParent`），缺漏時退回 `totalEquity`。
- **流通股數**：查 `capital_stock_history`（見 `src/shared/capitalStock.ts` 的 `getPaidInSharesAsOf`）——股本是歷史異動紀錄，不是固定值，要找生效日（西元年月）小於等於本季資產負債表**報告日**（期末日，不是公告/申報日）的最新一筆，不能直接抓整張表最新一筆。回應的 `paidInShares.effectiveYear` / `effectiveMonth` 會標明實際套用的是哪一筆。
- **單位陷阱（踩過一次）**：三張季度財報表的金額欄位單位是「千元」，但 `capital_stock_history.paidInShares` 是實際股數（不是千股）。算 `bvps = equityValue / paidInShares` 前，equityValue 要先 x1000 換算成元，否則答案會差 1000 倍——第一版就是漏了這步，算出 0.18 而不是正確的 176.65（台積電 114Q2）。這個單位差異之後算 EPS TTM、每股營收、每股現金流等指標時也都會遇到，務必注意。
- **`subsidiaryCompanyId`**：`capital_stock_history` 只有母公司（上市櫃公司本身）的股本紀錄，沒有子公司維度。指定 `subsidiaryCompanyId` 查詢時，流通股數仍是母公司的股本結構，會在 `warnings` 中註明，數值是否適用需自行判斷。
- 已用台積電（2330）114Q2 合併報表實測驗證：期末權益 45,810.7 億元 ÷ 流通股數 25,932,615,521 股 = BVPS 176.65 元（量級與台積電當時實際淨值相符）。
- **驗證時務必對齊同一季度**：曾發生拿 114Q2（2025 Q2）算出的 176.65 元去跟「2026 Q2」的外部估算比對，誤以為算錯——實際上兩者是不同季度，不能直接比。改抓 115Q2（2026 Q2）驗證得到 248.05 元，跟外部估算的 241 元量級相符（~3% 誤差，可能是股數口徑細節差異）。

## EPS 計算口徑

跟 ROE 一樣是單季/單季年化/TTM 三個數值放同一支 API、同一張表（`epsQuarterly` / `epsQuarterlyAnnualized` / `epsTtm`），不要拆成多支 API 或多張表——一開始曾先做成獨立的 `eps-ttm` API/`eps_ttm_result` 表，後來發現這樣不對稱（ROE 三個口徑同一張表，EPS 卻只做 TTM 開一張表），已經改掉。

- **淨利欄位選擇**：跟 ROE 一樣優先採用「歸屬於母公司」口徑（`netIncomeAttributableToParent`），缺漏時退回 `netIncome`。
- **跟季報 `eps`/`epsDiluted` 不同**：那兩個欄位是公司自己申報的數字，這裡是本服務自己用「淨利 / 股本歷史對應的流通股數」算出來的，口徑上可以互相對照，但不是同一個計算方式。
- **`epsQuarterly`**：本季淨利 / 本季報告日對應的流通股數。
- **`epsQuarterlyAnnualized`**：`epsQuarterly` 簡單 x4，跟 ROE 的年化邏輯一致，非以近四季實際加總計算。
- **`epsTtm`**：近四季（含本季）淨利加總 / 本季報告日對應的流通股數。近四季資料須全部存在且淨利欄位皆非 null，否則整個回傳 `null`（不會用部分資料湊數字），缺的季度只列在 `warnings` 文字裡。
- **流通股數／單位換算**：跟 BVPS 完全一樣的做法——查 `capital_stock_history` 抓報告日當時生效的股數，金額欄位（千元）要先 x1000 換算成元再除。
- 已用台積電（2330）115Q2（2026 Q2）合併報表實測驗證：本季淨利 706,561,938 千元 → epsQuarterly 27.25 元、epsQuarterlyAnnualized 109 元；近四季（114Q3~115Q2）淨利加總 3,449,225,724 千元 → epsTtm 133.01 元。TTM 高於單季年化是因為本季淨利比前三季平均低，兩個數字本來就會分歧，不是計算錯誤。

## 每股營收計算口徑

跟 EPS 同一種單季/單季年化/TTM 三欄位結構，計算方式也完全一樣，只是分子換成 `operatingRevenue`（營收沒有「歸屬於母公司」的口徑選擇問題，單一欄位）。

- **`revenuePerShareQuarterly`**：本季營收 / 本季報告日對應的流通股數。
- **`revenuePerShareQuarterlyAnnualized`**：`revenuePerShareQuarterly` 簡單 x4。
- **`revenuePerShareTtm`**：近四季（含本季）營收加總 / 本季報告日對應的流通股數，近四季資料須完整存在才會計算，否則為 `null`。
- 流通股數／單位換算做法跟 BVPS、EPS 完全一樣（查 `capital_stock_history`、金額 x1000 換算成元）。
- 已用台積電（2330）115Q2（2026 Q2）合併報表實測驗證：本季營收 1,270,380,250 千元 → 每股營收 48.99 元、年化 195.96 元；近四季營收加總 7,203,456,280 千元 → TTM 每股營收 277.78 元。

## 每股現金流（OCF/FCF）計算口徑

跟 EPS/每股營收同一種單季/年化/TTM 三欄位結構，但 OCF 跟 FCF 兩個指標放同一支 API、同一張表——因為算 FCF 一定要先有 OCF 跟資本支出，拆成兩支 API 會重複查兩次現金流量表跟股本，沒必要。

- **`ocfPerShareQuarterly`**：本季 `netCashFromOperatingActivities` / 本季報告日對應的流通股數。
- **`fcfPerShareQuarterly`**：`(本季 netCashFromOperatingActivities + 本季 capitalExpenditures) / 流通股數`——**注意是加不是減**，因為資料庫裡的 `capitalExpenditures` 本身已經是負數（現金流出），例如台積電 115Q2 是 `-846,764,746` 千元。
- **`*QuarterlyAnnualized`**：對應單季數值簡單 x4。
- **`*Ttm`**：近四季（含本季）加總 / 流通股數。一季只要 `netCashFromOperatingActivities` 或 `capitalExpenditures` 任一為 `null`，該季就整個視為不齊，OCF 跟 FCF 共用同一組「資料齊不齊」判斷，不分開追蹤兩套缺季清單。
- 流通股數／單位換算做法跟 BVPS、EPS、每股營收完全一樣。
- 已用台積電（2330）115Q2（2026 Q2）合併報表實測驗證：本季 OCF 1,482,341,242 千元、資本支出 -846,764,746 千元 → OCF 每股 57.16 元、FCF 每股 24.51 元；近四季 OCF 加總 6,005,759,970 千元、資本支出加總 -3,385,442,599 千元 → TTM OCF 每股 231.59 元、TTM FCF 每股 101.04 元。

## 已知缺口 / Backlog

- **只有 ROE、BVPS、EPS、每股營收、每股現金流**：PER、PBR、ROA、槓桿/流動性/周轉率等尚未實作。PER/PBR/市值/EV 系列都卡在還沒有股價資料源。
- **ROE 用期末權益而非期初期末平均權益**：見上方「ROE 計算口徑」，是刻意的 v1 簡化，非 bug。
- **沒有自動化測試**：跟 oingg-mops-ts 一樣，目前靠實測真實資料驗證，沒有 unit test。
- **沒有身份驗證**：跟 oingg-mops-ts 的 ingest API 一樣，目前完全開放。
- **ESM import 不帶 `.js` 副檔名**：跟 oingg-mops-ts 相同慣例與理由（`tsconfig.json` 用 `moduleResolution: "Bundler"` + `tsx` 執行，非原生 Node ESM）。
