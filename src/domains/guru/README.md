# 大師策略與複合量化估值模型（guru_and_composite_valuation_models）

- **scope**：Security
- **說明**：整合經典大師選股準則、動態成長折現與多因子基本面評分模型。
- **狀態**：⬜ 全部未實作。

## 為什麼整類都還沒做

這類指標是組合多個基礎指標、通常還要加市場價格或成長率假設的「大師公式」，帶有特定投資人流派的主觀判斷，跟其他分類「直接從財報算出來的數字」性質不同。多數（`Greenblatt_Magic_Formula`、`Lynch_PEG_Fair_Value`）需要先有 [`../valuation/`](../valuation/README.md) 的股價/市值資料源才能做；`Graham_NCAV`、`Piotroski_F_Score`、`Mohanram_G_Score` 理論上不需要股價（`Graham_NCAV` 例外，公式裡有股數但沒有股價），但都是多變量組合模型，建議等更多基礎指標（尤其是 [`../solvency/`](../solvency/README.md)、[`../turnover/`](../turnover/README.md) 剩下的指標）補齊後再回頭做，減少重複查詢跟邏輯拆分的成本。

## 指標清單

| code | 中文名稱 | 公式 | supported_periods | 說明 |
|---|---|---|---|---|
| `Graham_NCAV` | 葛拉漢淨流動資產價值 | `(Current Assets - Total Liabilities - Preferred Stock) / Shares` | MRQ, FY | 計算每股流動資產扣除總負債後淨額，檢視極端安全邊際 |
| `Greenblatt_Magic_Formula` | 葛林布雷神奇公式 | `Rank(Earnings Yield = EBIT/EV) + Rank(ROC = EBIT/(Net Working Capital + Net Fixed Assets))` | TTM, FY | 結合高盈餘殖利率與高資本報酬率之雙因子綜合排名模型 |
| `Lynch_PEG_Fair_Value` | 彼得林區本益成長模型 | `PEG = PER / Expected Growth Rate; Fair Value = Expected Growth Rate * EPS` | Forward, TTM | 以預期成長率校正傳統本益比，設定成長股之動態合理估值 |
| `Buffett_Owner_Earnings` | 巴菲特股東盈餘 | `Net Income + D&A - Maintenance CapEx` | TTM, FY | 衡量企業在維持現有競爭力下，股東真正能自由提領的實質現金 |
| `Piotroski_F_Score` | 皮爾托斯基分數 | 9 項基本面二元會計訊號加總（0~9） | TTM, FY | 綜合獲利能力、財務槓桿/流動性及營運效率改善之 9 分制質量評分 |
| `Mohanram_G_Score` | 莫罕拉姆 G 分數 | 8 項基本面成長/研發效率訊號加總（0~8） | TTM, FY | 針對高估值與高成長標的設計的基本面評分，彌補 F-Score 偏重價值股的限制 |
| `Potential_Payback_Period` | 潛在回本期模型 | `ln(1 + (Stock Price * ln(1 + g)) / EPS_0) / ln(1 + g)` | Forward_3Y, Forward_5Y | 考量獲利複合成長率下，動態推算收回購股成本所需的真實年數 |
