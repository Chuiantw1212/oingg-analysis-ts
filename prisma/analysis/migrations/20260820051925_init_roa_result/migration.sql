-- CreateTable
CREATE TABLE "roa_result" (
    "symbol" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "season" INTEGER NOT NULL,
    "data_type" TEXT NOT NULL,
    "subsidiary_company_id" TEXT NOT NULL DEFAULT '',
    "report_date" DATE,
    "roa_quarterly_pct" DECIMAL(10,2),
    "roa_quarterly_annualized_pct" DECIMAL(10,2),
    "roa_ttm_pct" DECIMAL(10,2),
    "net_income_field_used" TEXT,
    "net_income_value" BIGINT,
    "total_assets_value" BIGINT,
    "warnings" TEXT[],
    "computed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "roa_result_pkey" PRIMARY KEY ("symbol","year","season","data_type","subsidiary_company_id")
);
