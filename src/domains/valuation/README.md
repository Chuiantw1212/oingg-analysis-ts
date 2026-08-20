# 估值與市場定價指標（valuation_and_pricing）

- **scope**：Security
- **說明**：衡量個股或證券市價相對各項基礎財務維度的市場定價乘數與折溢價幅度。
- **狀態**：⬜ 全部未實作。

## 為什麼整類都還沒做

這一類每個指標都需要**股價**（或市值），而本服務目前完全沒有股價資料源——oingg-mops-ts 提供的只有季度財報（損益表、資產負債表、現金流量表）跟股本歷史，都是基本面資料，不含任何市場交易價格。要做這一類，第一件事是決定股價資料要從哪抓（另外接 API、還是請 oingg-mops-ts 增加 ingest），這是比單一指標實作更大的決定，尚未拍板。

不過分母端很多已經現成：`Book Value Per Share`（[`../profitability/bvps/`](../profitability/bvps/)）、`EPS`（[`../profitability/eps/`](../profitability/eps/)）、`Free Cash Flow Per Share`（[`../cashFlow/cashFlowPerShare/`](../cashFlow/cashFlowPerShare/)）都已經有了，股價一旦有資料源，這幾個指標可以很快接上。

## 指標清單

| code | 中文名稱 | 公式 | supported_periods | 說明 |
|---|---|---|---|---|
| `PER` | 本益比 | `Stock Price / EPS` | TTM, FY, Forward, MRQ | 衡量市場對每單位盈餘支付的溢價倍數 |
| `CAPE` | 席勒本益比 / 週期調整本益比 | `Real Price / 10-Year Average Real EPS` | 10Y_Rolling | 平滑十年通膨調整後獲利，評估景氣週期下的長期評價水準 |
| `PBR` | 股價淨值比 | `Stock Price / Book Value Per Share` | MRQ, FY | 衡量市價相對於每股帳面淨值的倍數 |
| `PSR` | 股價營收比 | `Market Cap / Annual Revenue` | TTM, FY | 衡量市值相對於營收的倍數，適用於未穩定獲利之高成長期標的 |
| `P_FCF` | 股價自由現金流比 | `Market Cap / Free Cash Flow` | TTM, FY | 衡量市場相對於實質現金產出能力的估值倍數 |
| `EV_EBITDA` | 企業價值倍數 | `Enterprise Value / EBITDA` | TTM, FY | 納入債務與現金調整之整體收購成本相對於核心營業現金獲利之倍數 |
| `Dividend_Yield` | 股息殖利率 | `Annual Dividend Per Share / Stock Price` | TTM, Forward, FY | 以現金股利發放為基準之年化市價回報率 |
| `NAV_Discount_Premium` | 淨值折溢價率 | `(Market Price - NAV) / NAV` | Daily, MRQ | 封閉式基金、ETF 或 REITs 市價相對底層資產淨值的偏離度 |
