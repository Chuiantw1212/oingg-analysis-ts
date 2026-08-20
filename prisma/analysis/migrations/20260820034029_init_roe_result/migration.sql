-- CreateTable
CREATE TABLE "roe_result" (
    "symbol" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "season" INTEGER NOT NULL,
    "data_type" TEXT NOT NULL,
    "subsidiary_company_id" TEXT NOT NULL DEFAULT '',
    "report_date" DATE,
    "roe_quarterly_pct" DECIMAL(10,2),
    "roe_quarterly_annualized_pct" DECIMAL(10,2),
    "roe_ttm_pct" DECIMAL(10,2),
    "net_income_field_used" TEXT,
    "net_income_value" BIGINT,
    "equity_field_used" TEXT,
    "equity_value" BIGINT,
    "ttm_quarters_used" TEXT[],
    "ttm_quarters_missing" TEXT[],
    "warnings" TEXT[],
    "computed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "roe_result_pkey" PRIMARY KEY ("symbol","year","season","data_type","subsidiary_company_id")
);
