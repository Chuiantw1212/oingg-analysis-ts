# 獲利能力與資本配置效率（profitability_and_capital_allocation）

- **scope**：Security
- **說明**：衡量本業獲利轉化能力、資本配置報酬率以及股東回報政策。

## 指標清單

| code | 中文名稱 | 公式 | supported_periods | 狀態 |
|---|---|---|---|---|
| `EPS` | 每股盈餘 | `(Net Income - Preferred Dividends) / Weighted Average Common Shares` | MRQ, TTM, FY, Diluted | ✅ 已實作 — [`eps/`](eps/)，`GET /profitability/eps`（單季/年化/TTM） |
| `Gross_Margin` | 毛利率 | `(Revenue - COGS) / Revenue` | MRQ, TTM, FY | ✅ 已實作 — [`margins/`](margins/)，`GET /profitability/margins`（單季/TTM，沒有年化版本，見下方說明） |
| `Operating_Margin` | 營業利益率 | `Operating Income / Revenue` | MRQ, TTM, FY | ✅ 已實作 — [`margins/`](margins/)，`GET /profitability/margins`（單季/TTM） |
| `Net_Profit_Margin` | 稅後淨利率 | `Net Income / Revenue` | MRQ, TTM, FY | ✅ 已實作 — [`margins/`](margins/)，`GET /profitability/margins`（單季/TTM） |
| `ROE` | 股東權益報酬率 | `Net Income / Shareholders' Equity` | MRQ_Annualized, TTM, FY | ✅ 已實作 — [`roe/`](roe/)，`GET /profitability/roe`（單季/年化/TTM） |
| `ROA` | 總資產報酬率 | `Net Income / Total Assets` | MRQ_Annualized, TTM, FY | ✅ 已實作 — [`roa/`](roa/)，`GET /profitability/roa`（單季/年化/TTM） |
| `ROIC` | 投入資本回報率 | `NOPAT / Invested Capital` | TTM, FY | ⬜ 未實作 |
| `ROCE` | 使用資本報酬率 | `EBIT / (Total Assets - Current Liabilities)` | TTM, FY | ⬜ 未實作 |
| `CFROI` | 現金流投資回報率 | `Gross Cash Flow / Gross Invested Capital` | TTM, FY | ⬜ 未實作 |
| `Dividend_Payout_Ratio` | 配息率 | `Total Dividends / Net Income` | TTM, FY | ⬜ 未實作 |
| `SGR` | 可持續成長率 | `ROE * (1 - Dividend Payout Ratio)` | TTM, FY | ⬜ 未實作，依賴 `Dividend_Payout_Ratio` 先做完 |

## 本服務自行歸類的指標（不在 taxonomy 明列的 code 裡）

跟 EPS 同屬「每股基礎財務數字」家族，taxonomy 沒有獨立列出，但性質、計算模式（單季/年化/TTM、查 `capital_stock_history` 抓流通股數）都跟 EPS 一致，所以放在這一類：

| 指標 | 公式 | 狀態 |
|---|---|---|
| BVPS（每股淨值） | `Shareholders' Equity / Paid-in Shares` | ✅ 已實作 — [`bvps/`](bvps/)，`GET /profitability/bvps` |
| 每股營收 | `Revenue / Paid-in Shares` | ✅ 已實作 — [`revenuePerShare/`](revenuePerShare/)，`GET /profitability/revenue-per-share`（單季/年化/TTM） |

## 實作慣例（給之後要做剩餘指標的人）

- 淨利欄位優先採用「歸屬於母公司」口徑（`netIncomeAttributableToParent`），缺漏時退回整體數字（`netIncome`）——見 [`roe/service.ts`](roe/service.ts) 的 `pickNetIncome`。`Gross_Margin`/`Operating_Margin` 的分子（毛利、營業利益）是損益表單一欄位，沒有母子公司口徑選擇問題；`Net_Profit_Margin` 的分子是淨利，套用同一套 `pickNetIncome` 選擇邏輯，見 [`margins/service.ts`](margins/service.ts)。
- 需要流通股數的指標一律查 `capital_stock_history`（見 [`../../shared/capitalStock.ts`](../../shared/capitalStock.ts) 的 `getPaidInSharesAsOf`），不要用「股本 ÷ 10」估算；財報金額單位是千元，股數是實際股數，換算時記得 x1000（BVPS 曾經漏過這步，見 [`bvps/service.ts`](bvps/service.ts) 註解）。
- 單季/年化/TTM 三個口徑放同一張表、同一支 API，不要拆開（EPS 曾經先拆過 `eps-ttm` 獨立一支，後來合併回來）。
- **不是每個指標都需要「年化」欄位**：`Gross_Margin`/`Operating_Margin`/`Net_Profit_Margin` 是「同期流量 / 同期流量」的比率（例如本季毛利 / 本季營收），比率本身已經跟期間長度無關，不需要像 ROE（流量對存量）那樣簡單 x4 年化——[`margins/`](margins/) 只有 `*Quarterly` 跟 `*Ttm` 兩種口徑，沒有 `*QuarterlyAnnualized`，之後遇到其他「流量/流量」型比率也適用同樣判斷。
