# 營運週轉與資產效率（operating_efficiency_and_turnover）

- **scope**：Security
- **說明**：衡量營運資本在供應鏈及業務循環中轉換為現金的速度與效能。

## 指標清單

| code | 中文名稱 | 公式 | supported_periods | 狀態 |
|---|---|---|---|---|
| `CCC` | 現金轉換週期 | `DIO + DSO - DPO` | TTM, FY | ⬜ 未實作，依賴 `DIO`/`DSO`/`DPO` 先做完 |
| `DIO` | 存貨週轉天數 | `(Average Inventory / COGS) * 365` | TTM, FY | ⬜ 未實作——本服務已有「次」為單位的存貨周轉率（見下方），`DIO` 是同概念的「天數」版本，`365 / 周轉次數` 即可換算，尚未直接提供 |
| `DSO` | 應收帳款週轉天數 | `(Average Accounts Receivable / Credit Sales) * 365` | TTM, FY | ⬜ 未實作，同上，跟已實作的應收帳款周轉率是同概念的天數版本 |
| `DPO` | 應付帳款週轉天數 | `(Average Accounts Payable / COGS) * 365` | TTM, FY | ⬜ 未實作 |
| `Asset_Turnover` | 總資產週轉率 | `Revenue / Average Total Assets` | TTM, FY | ✅ 已實作 — [`turnoverRatio/`](turnoverRatio/)，`GET /api/ratios/turnover-ratio`（單季/年化/TTM）。taxonomy 用平均總資產，本服務用期末總資產，見下方說明 |
| `Fixed_Asset_Turnover` | 固定資產週轉率 | `Revenue / Net Fixed Assets` | TTM, FY | ⬜ 未實作 |
| `CapEx_to_Revenue` | 資本支出佔營收比 | `Capital Expenditures / Revenue` | TTM, FY | ⬜ 未實作 |

## 已實作但跟 taxonomy 公式略有差異的地方

`turnoverRatio/` 目前一次算三個周轉率（存貨、應收帳款、總資產），都用「次」為單位、分母用**期末餘額**（不是 taxonomy 寫的期初期末平均），這是跟 ROE 用期末權益一樣的刻意簡化（v1 優先求簡單可驗證）。如果之後要跟 taxonomy 完全對齊：

- 分母要改用平均值，需要多查一期（上一季或去年同季）的資產負債表。
- 存貨、應收帳款周轉率如果要轉成 taxonomy 的 `DIO`/`DSO`（天數），直接拿現有的「次」數字做 `365 / 周轉次數` 換算即可，不需要重新查資料。

## 實作慣例

存貨周轉率、應收帳款周轉率、總資產周轉率共用同一支 API/同一張表——三個都要查同一張損益表+資產負債表，也共用同一組 TTM 完整性判斷（一季只要營業成本或營收任一為 `null`，該季就整個視為不齊），拆開只會重複查詢。之後 `Fixed_Asset_Turnover`、`CapEx_to_Revenue` 如果要做，可以考慮併入同一張表，或視資料相依性另開。
