import { Router } from 'ultimate-express';
import { getTurnoverRatio } from './controller';

const router = Router();

/**
 * @swagger
 * /api/turnover/turnover-ratio:
 *   get:
 *     summary: 計算單一公司單季存貨周轉率、應收帳款周轉率、總資產周轉率、固定資產周轉率
 *     description: >
 *       直接讀取 oingg-mops-ts 已寫入資料庫的損益表與資產負債表資料進行計算，本服務本身不向 MOPS 抓取資料，
 *       若資料庫中查無該季資料請先透過 oingg-mops-ts 的 ingest API 抓取。
 *
 *       計算口徑（跟 ROE 同一種單季/年化/TTM 三數值結構，四個周轉率各自都有）：
 *       - inventoryTurnoverQuarterly（存貨周轉率） = 本季營業成本（operatingCost） / 本季期末存貨（inventory）。
 *       - receivablesTurnoverQuarterly（應收帳款周轉率） = 本季營收（operatingRevenue） / 本季期末應收帳款（accountsReceivable）。
 *       - assetTurnoverQuarterly（總資產周轉率） = 本季營收 / 本季期末總資產（totalAssets）。
 *       - fixedAssetTurnoverQuarterly（固定資產周轉率） = 本季營收 / 本季期末不動產、廠房及設備（propertyPlantEquipment）。
 *       - 分母都用**期末餘額**，不是期初期末平均——跟 ROE 用期末權益一樣的刻意簡化。
 *       - *QuarterlyAnnualized：對應單季數值簡單 x4，非以近四季實際加總計算。
 *       - *Ttm：近四季（含本季）營業成本／營收加總 / 本季期末餘額，近四季資料須完整存在才會計算，否則為 null——
 *         一季只要營業成本或營收任一為 null，該季就整個視為不齊，四個周轉率共用同一組完整性判斷。
 *     tags:
 *       - Turnover
 *     parameters:
 *       - in: query
 *         name: companyId
 *         required: true
 *         schema:
 *           type: string
 *         description: 公司代號
 *         example: "2330"
 *       - in: query
 *         name: year
 *         required: true
 *         schema:
 *           type: string
 *         description: 民國年
 *         example: "115"
 *       - in: query
 *         name: season
 *         required: true
 *         schema:
 *           type: string
 *           enum: ["1", "2", "3", "4"]
 *         description: 季度
 *         example: "2"
 *       - in: query
 *         name: dataType
 *         schema:
 *           type: string
 *           enum: ["1", "2"]
 *           default: "2"
 *         description: 1 = 個體, 2 = 合併，預設 2
 *       - in: query
 *         name: subsidiaryCompanyId
 *         schema:
 *           type: string
 *           default: ""
 *         description: 子公司代號，查詢母公司本身時留空
 *     responses:
 *       200:
 *         description: >
 *           計算結果。若資料庫查無資料或關鍵欄位為 null，對應欄位會是 null，
 *           原因會列在 warnings 中，不會回傳錯誤狀態碼（因為「查無資料」是正常情境，非伺服器錯誤）。
 *       400:
 *         description: 請求的參數格式錯誤。
 */
router.get('/turnover-ratio', getTurnoverRatio);

export default router;
