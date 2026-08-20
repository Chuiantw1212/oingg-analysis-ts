-- CreateTable
CREATE TABLE "eps_result" (
    "symbol" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "season" INTEGER NOT NULL,
    "data_type" TEXT NOT NULL,
    "subsidiary_company_id" TEXT NOT NULL DEFAULT '',
    "report_date" DATE,
    "eps_quarterly" DECIMAL(14,4),
    "eps_quarterly_annualized" DECIMAL(14,4),
    "eps_ttm" DECIMAL(14,4),
    "net_income_field_used" TEXT,
    "net_income_value" BIGINT,
    "net_income_ttm_value" BIGINT,
    "paid_in_shares" BIGINT,
    "capital_stock_effective_year" INTEGER,
    "capital_stock_effective_month" INTEGER,
    "warnings" TEXT[],
    "computed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "eps_result_pkey" PRIMARY KEY ("symbol","year","season","data_type","subsidiary_company_id")
);
