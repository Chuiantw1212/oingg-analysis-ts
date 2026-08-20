# 投資量化分析架構（investment_metrics_taxonomy v3.0）

`src/domains` 底下的資料夾對應這份分類，每一類各自的 `README.md` 記錄該分類的範疇、描述，以及分類下每個指標的公式、支援口徑、說明——包含**已實作**跟**尚未實作**的。尚未實作的分類目前只有 `README.md`，沒有 `types.ts`/`service.ts` 之類的程式碼。

## 分類索引

| 資料夾 | 中文名稱 | scope | 狀態 |
|---|---|---|---|
| [`profitabilityAndCapitalAllocation/`](profitabilityAndCapitalAllocation/README.md) | 獲利能力與資本配置效率 | Security | 部分實作（ROE、ROA、EPS、BVPS、每股營收） |
| [`operatingEfficiencyAndTurnover/`](operatingEfficiencyAndTurnover/README.md) | 營運週轉與資產效率 | Security | 部分實作（存貨/應收帳款/總資產周轉率） |
| [`solvencyAndFinancialHealth/`](solvencyAndFinancialHealth/README.md) | 財務結構、償債安全與破產預警 | Security | 部分實作（負債比率、流動比率、速動比率） |
| [`cashFlowAndEarningsQuality/`](cashFlowAndEarningsQuality/README.md) | 現金流品質與法證會計防雷 | Security | 部分實作（每股 OCF/FCF） |
| [`valuationAndPricing/`](valuationAndPricing/README.md) | 估值與市場定價指標 | Security | 未實作——卡在沒有股價資料源 |
| [`guruAndCompositeValuationModels/`](guruAndCompositeValuationModels/README.md) | 大師策略與複合量化估值模型 | Security | 未實作——多數依賴 valuationAndPricing 先有股價 |
| [`technicalAnalysisAndMomentum/`](technicalAnalysisAndMomentum/README.md) | 技術分析與價格量能指標 | Security | 未實作——需要日線價量資料源，目前完全沒有 |
| [`portfolioRiskAndFactors/`](portfolioRiskAndFactors/README.md) | 投資組合風險、超額報酬與量化因子 | Portfolio | 未實作——需要「投資組合」這個資料模型，目前只有單一公司查詢 |
| [`macroFixedIncomeAndSentiment/`](macroFixedIncomeAndSentiment/README.md) | 總體經濟、固定收益與市場情緒 | Market_Macro | 未實作——需要總體經濟/債券/選擇權資料源，跟公司財報完全無關 |

## 跨分類的時間轉換算子（temporal_transformation_operators）

這三個不是分類，是**可以套用在多個分類指標上的計算算子**，taxonomy 裡獨立列出：

| 算子 | 中文名稱 | 支援窗口 | 公式 |
|---|---|---|---|
| `CAGR` | 年複合成長率算子 | 3Y / 5Y / 10Y | `(Value_end / Value_start) ^ (1/n) - 1` |
| `PoP_Growth` | 週期變動率算子 | YoY / QoQ / MoM | `(Value_current - Value_prior) / Value_prior * 100%` |
| `Rolling_Average` | 滾動平滑算子 | 1Y/3Y/10Y Rolling | `Mean(Value, Window_N)` |

本服務目前的指標都是「單季 / 單季年化（簡單 x4） / TTM」，還沒有套用 CAGR、真正的 Rolling Average 這類跨年度算子——這些算子哪天要用，會是在既有分類的指標上疊加，不會自己形成新的分類資料夾。

## 跟既有指標的對應說明（現況 vs 理想 taxonomy）

taxonomy 是理想化的分類文件，現有 9 個已實作指標裡，有 2 個（BVPS、每股營收）不是 taxonomy 明列的獨立 code，是因為跟 EPS 同屬「每股基礎財務數字」家族，被放進 `profitabilityAndCapitalAllocation`——各分類 README 裡有標注哪些是「taxonomy 明列」、哪些是「本服務自行歸類」。
