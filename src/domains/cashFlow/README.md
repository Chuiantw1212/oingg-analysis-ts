# 現金流品質與法證會計防雷（cash_flow_and_earnings_quality）

- **scope**：Security
- **說明**：衡量會計帳面獲利與真實現金流的匹配度，排查應計項目與潛在盈餘操縱。

## 指標清單

| code | 中文名稱 | 公式 | supported_periods | 狀態 |
|---|---|---|---|---|
| `FCF` | 自由現金流 | `Operating Cash Flow - Capital Expenditures` | TTM, FY, MRQ | ✅ 已實作（每股版本） — [`cashFlowPerShare/`](cashFlowPerShare/)，`GET /api/ratios/cash-flow-per-share`（單季/年化/TTM）。本服務算的是「每股 FCF」，不是 taxonomy 寫的公司總額，見下方說明 |
| `FCF_Yield` | 自由現金流殖利率 | `Free Cash Flow Per Share / Stock Price` | TTM, FY | ⬜ 未實作，需要股價，屬於 [`../valuation/`](../valuation/README.md) 那條資料源缺口 |
| `OCF_to_Net_Income` | 營運現金流對淨利比 | `Operating Cash Flow / Net Income` | TTM, FY | ⬜ 未實作 |
| `Accruals_Ratio` | 應計項目比率 | `(Net Income - OCF - ICF) / Average Total Assets` | TTM, FY | ⬜ 未實作 |
| `Beneish_M_Score` | 貝尼許 M 分數 | 8 變量加權會計異常指數 | FY, TTM | ⬜ 未實作，多變量模型 |

## 已實作但跟 taxonomy 定義範疇不同的地方

taxonomy 的 `FCF` 是公司層級的總額（Operating Cash Flow - CapEx，單位是總金額），本服務目前做的是 [`cashFlowPerShare/`](cashFlowPerShare/) 這個**每股**版本（OCF 每股、FCF 每股），因為當初是接續 EPS/BVPS/每股營收那條「每股基礎指標」的脈絡做的，放進了 `profitability` 的姊妹脈絡但實際歸類在這裡（因為 FCF 本身在 taxonomy 是歸在 cash_flow_and_earnings_quality）。公司總額版本的 OCF/FCF（不除以股數）目前沒有獨立公開，但 API 回應裡的 `operatingCashFlow.value`、`capitalExpenditures.value` 就是總額（千元），要重建總額版本不需要新查詢，直接讀這兩個欄位即可。

## 實作慣例

- `capitalExpenditures` 在資料庫裡本身是負數（現金流出），FCF = OCF **+** capex，不是減——這是計算這類指標時最容易踩的坑，見 [`cashFlowPerShare/service.ts`](cashFlowPerShare/service.ts) 註解。
- OCF、FCF 共用同一支 API/同一張表，也共用同一組 TTM 完整性判斷（一季只要 OCF 或資本支出任一為 `null`，該季就整個視為不齊）。
