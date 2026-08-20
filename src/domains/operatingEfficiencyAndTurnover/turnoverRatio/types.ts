import type { Season } from '../../../shared/rocQuarter';

export interface TurnoverRatioQuery {
  companyId: string;
  year: string; // 民國年，例如 "115"
  season: Season;
  dataType: '1' | '2'; // 1 = 個體, 2 = 合併
  subsidiaryCompanyId: string;
}

export interface TurnoverRatioResult {
  companyId: string;
  year: string;
  season: Season;
  dataType: '1' | '2';
  subsidiaryCompanyId: string;
  reportDate: string | null;

  // 存貨周轉率（次）= 本季營業成本 / 本季期末存貨
  inventoryTurnoverQuarterly: number | null;
  inventoryTurnoverQuarterlyAnnualized: number | null;
  // TTM = 近四季（含本季）營業成本加總 / 本季期末存貨
  inventoryTurnoverTtm: number | null;

  // 應收帳款周轉率（次）= 本季營收 / 本季期末應收帳款
  receivablesTurnoverQuarterly: number | null;
  receivablesTurnoverQuarterlyAnnualized: number | null;
  receivablesTurnoverTtm: number | null;

  // 總資產周轉率（次）= 本季營收 / 本季期末總資產
  assetTurnoverQuarterly: number | null;
  assetTurnoverQuarterlyAnnualized: number | null;
  assetTurnoverTtm: number | null;

  operatingCost: {
    value: string | null; // BigInt as string；本季營業成本
  };
  operatingCostTtm: {
    value: string | null; // BigInt as string；近四季加總，資料不齊則為 null
  };
  operatingRevenue: {
    value: string | null; // BigInt as string；本季營收
  };
  operatingRevenueTtm: {
    value: string | null; // BigInt as string；近四季加總，資料不齊則為 null
  };

  inventory: {
    value: string | null; // BigInt as string；本季期末存貨（分母，用期末值，不是平均值）
  };
  accountsReceivable: {
    value: string | null; // BigInt as string；本季期末應收帳款
  };
  totalAssets: {
    value: string | null; // BigInt as string；本季期末總資產
  };

  ttm: {
    quartersUsed: string[];
    quartersMissing: string[];
  };

  warnings: string[];
}
