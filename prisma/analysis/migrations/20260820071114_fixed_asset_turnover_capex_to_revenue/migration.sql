-- AlterTable
ALTER TABLE "turnover_ratio_result" ADD COLUMN     "fixed_asset_turnover_quarterly" DECIMAL(14,4),
ADD COLUMN     "fixed_asset_turnover_quarterly_annualized" DECIMAL(14,4),
ADD COLUMN     "fixed_asset_turnover_ttm" DECIMAL(14,4),
ADD COLUMN     "property_plant_equipment_value" BIGINT;

-- CreateTable
CREATE TABLE "capex_to_revenue_result" (
    "symbol" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "season" INTEGER NOT NULL,
    "data_type" TEXT NOT NULL,
    "subsidiary_company_id" TEXT NOT NULL DEFAULT '',
    "report_date" DATE,
    "capex_to_revenue_quarterly" DECIMAL(10,2),
    "capex_to_revenue_ttm" DECIMAL(10,2),
    "capital_expenditures_value" BIGINT,
    "capital_expenditures_ttm_value" BIGINT,
    "operating_revenue_value" BIGINT,
    "operating_revenue_ttm_value" BIGINT,
    "warnings" TEXT[],
    "computed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "capex_to_revenue_result_pkey" PRIMARY KEY ("symbol","year","season","data_type","subsidiary_company_id")
);
