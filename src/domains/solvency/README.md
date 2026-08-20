# 財務結構、償債安全與破產預警（solvency_and_financial_health）

- **scope**：Security
- **說明**：檢視槓桿水平、短期流動性安全墊以及極端情境下的抗風險破產預警能力。

## 指標清單

| code | 中文名稱 | 公式 | supported_periods | 狀態 |
|---|---|---|---|---|
| `Current_Ratio` | 流動比率 | `Current Assets / Current Liabilities` | MRQ, FY | ✅ 已實作 — [`liquidityRatio/`](liquidityRatio/)，`GET /api/solvency/liquidity-ratio` |
| `Quick_Ratio` | 速動比率 | `(Cash + Marketable Securities + Receivables) / Current Liabilities` | MRQ, FY | ✅ 已實作 — [`liquidityRatio/`](liquidityRatio/)，`GET /api/solvency/liquidity-ratio`。公式略有差異，見下方說明 |
| `Cash_Ratio` | 現金比率 | `(Cash + Cash Equivalents) / Current Liabilities` | MRQ, FY | ⬜ 未實作 |
| `DE_Ratio` | 負債權益比 | `Total Debt / Shareholders' Equity` | MRQ, FY | ⬜ 未實作 |
| `Debt_to_Assets` | 資產負債率 | `Total Liabilities / Total Assets` | MRQ, FY | ✅ 已實作 — [`debtRatio/`](debtRatio/)，`GET /api/solvency/debt-ratio` |
| `Net_Debt_to_EBITDA` | 淨負債對 EBITDA 比 | `(Total Debt - Cash) / EBITDA` | TTM, FY | ⬜ 未實作 |
| `Interest_Coverage` | 利息保障倍數 | `EBIT / Interest Expense` | TTM, FY | ⬜ 未實作 |
| `Altman_Z_Score` | 奧特曼 Z 分數 | `1.2*X1 + 1.4*X2 + 3.3*X3 + 0.6*X4 + 0.999*X5` | MRQ, FY | ⬜ 未實作，多變量模型，依賴前面幾個比率先做完 |

## 已實作但跟 taxonomy 公式略有差異的地方

`Quick_Ratio`（速動比率）taxonomy 的公式是 `(現金 + 有價證券 + 應收帳款) / 流動負債`，本服務用的是更常見的簡化版本 `(流動資產 - 存貨) / 流動負債`（兩者理論上該相等，前提是流動資產只由現金、有價證券、應收帳款、存貨組成；實務上流動資產可能還有預付款項等其他項目，兩個公式數字會有些微差異）。如果要跟 taxonomy 完全對齊，需要改抓 `cashAndEquivalents` + 有價證券欄位（目前 schema 沒有單獨的「有價證券」欄位）+ `accountsReceivable`。

## 實作慣例

- `Current_Ratio`/`Quick_Ratio` 共用同一支 API/同一張表——速動比率一定要先有流動資產/流動負債，拆開只會重複查詢。
- 這一類的指標多數是**純資產負債表時點快照**（`Debt_to_Assets`、`Current_Ratio`、`Quick_Ratio`、`Cash_Ratio`、`DE_Ratio`），不像 ROE/ROA 有單季/年化/TTM 的區別——資產負債表本身就是某一天的餘額，annualize 對這種比率沒有意義。只有 `Interest_Coverage`、`Net_Debt_to_EBITDA` 這種牽涉損益表流量（EBIT）的才會有 TTM 版本。
