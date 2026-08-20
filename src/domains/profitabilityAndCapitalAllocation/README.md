# 獲利能力與資本配置效率（profitability_and_capital_allocation）

- **scope**：Security
- **說明**：衡量本業獲利轉化能力、資本配置報酬率以及股東回報政策。

## 指標清單

| code | 中文名稱 | 公式 | supported_periods | 狀態 |
|---|---|---|---|---|
| `EPS` | 每股盈餘 | `(Net Income - Preferred Dividends) / Weighted Average Common Shares` | MRQ, TTM, FY, Diluted | ✅ 已實作 — [`eps/`](eps/)，`GET /api/ratios/eps`（單季/年化/TTM） |
| `Gross_Margin` | 毛利率 | `(Revenue - COGS) / Revenue` | MRQ, TTM, FY | ⬜ 未實作 |
| `Operating_Margin` | 營業利益率 | `Operating Income / Revenue` | MRQ, TTM, FY | ⬜ 未實作 |
| `Net_Profit_Margin` | 稅後淨利率 | `Net Income / Revenue` | MRQ, TTM, FY | ⬜ 未實作 |
| `ROE` | 股東權益報酬率 | `Net Income / Shareholders' Equity` | MRQ_Annualized, TTM, FY | ✅ 已實作 — [`roe/`](roe/)，`GET /api/ratios/roe`（單季/年化/TTM） |
| `ROA` | 總資產報酬率 | `Net Income / Total Assets` | MRQ_Annualized, TTM, FY | ✅ 已實作 — [`roa/`](roa/)，`GET /api/ratios/roa`（單季/年化/TTM） |
| `ROIC` | 投入資本回報率 | `NOPAT / Invested Capital` | TTM, FY | ⬜ 未實作 |
| `ROCE` | 使用資本報酬率 | `EBIT / (Total Assets - Current Liabilities)` | TTM, FY | ⬜ 未實作 |
| `CFROI` | 現金流投資回報率 | `Gross Cash Flow / Gross Invested Capital` | TTM, FY | ⬜ 未實作 |
| `Dividend_Payout_Ratio` | 配息率 | `Total Dividends / Net Income` | TTM, FY | ⬜ 未實作 |
| `SGR` | 可持續成長率 | `ROE * (1 - Dividend Payout Ratio)` | TTM, FY | ⬜ 未實作，依賴 `Dividend_Payout_Ratio` 先做完 |

## 本服務自行歸類的指標（不在 taxonomy 明列的 code 裡）

跟 EPS 同屬「每股基礎財務數字」家族，taxonomy 沒有獨立列出，但性質、計算模式（單季/年化/TTM、查 `capital_stock_history` 抓流通股數）都跟 EPS 一致，所以放在這一類：

| 指標 | 公式 | 狀態 |
|---|---|---|
| BVPS（每股淨值） | `Shareholders' Equity / Paid-in Shares` | ✅ 已實作 — [`bvps/`](bvps/)，`GET /api/ratios/bvps` |
| 每股營收 | `Revenue / Paid-in Shares` | ✅ 已實作 — [`revenuePerShare/`](revenuePerShare/)，`GET /api/ratios/revenue-per-share`（單季/年化/TTM） |

## 實作慣例（給之後要做剩餘指標的人）

- 淨利欄位優先採用「歸屬於母公司」口徑（`netIncomeAttributableToParent`），缺漏時退回整體數字（`netIncome`）——見 [`roe/service.ts`](roe/service.ts) 的 `pickNetIncome`，`Gross_Margin`/`Operating_Margin`/`Net_Profit_Margin` 這幾個沒有母子公司口徑選擇問題（分子是損益表單一欄位），但淨利率的分子如果要用淨利，一樣要套用這個選擇邏輯。
- 需要流通股數的指標一律查 `capital_stock_history`（見 [`../../shared/capitalStock.ts`](../../shared/capitalStock.ts) 的 `getPaidInSharesAsOf`），不要用「股本 ÷ 10」估算；財報金額單位是千元，股數是實際股數，換算時記得 x1000（BVPS 曾經漏過這步，見 [`bvps/service.ts`](bvps/service.ts) 註解）。
- 單季/年化/TTM 三個口徑放同一張表、同一支 API，不要拆開（EPS 曾經先拆過 `eps-ttm` 獨立一支，後來合併回來）。
