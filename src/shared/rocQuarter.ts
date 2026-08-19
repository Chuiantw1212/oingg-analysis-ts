// 從 oingg-mops-ts 的 src/shared/rocQuarter.ts 複製精簡而來（只保留本服務需要的部分）。
// 本服務不負責抓取/回補資料，因此不需要 getLatestAvailableQuarter / getQuarterEndDate。
export type Season = '1' | '2' | '3' | '4';

const SEASONS_DESC: Season[] = ['4', '3', '2', '1'];

// 由 latest 往前數 n 季（含 latest 本身），依時間先後（舊 -> 新）回傳。
export const getPastNQuarters = (latest: { rocYear: number; season: Season }, n: number): { year: string; season: Season }[] => {
  const quarters: { rocYear: number; season: Season }[] = [];
  let { rocYear, season } = latest;
  for (let i = 0; i < n; i++) {
    quarters.push({ rocYear, season });
    const idx = SEASONS_DESC.indexOf(season);
    if (idx === SEASONS_DESC.length - 1) {
      rocYear -= 1;
      season = '4';
    } else {
      season = SEASONS_DESC[idx + 1]!;
    }
  }
  return quarters.reverse().map((q) => ({ year: String(q.rocYear), season: q.season }));
};
