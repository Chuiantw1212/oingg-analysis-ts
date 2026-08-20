-- CreateTable
CREATE TABLE "cash_flow_per_share_result" (
    "symbol" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "season" INTEGER NOT NULL,
    "data_type" TEXT NOT NULL,
    "subsidiary_company_id" TEXT NOT NULL DEFAULT '',
    "report_date" DATE,
    "ocf_per_share_quarterly" DECIMAL(14,4),
    "ocf_per_share_quarterly_annualized" DECIMAL(14,4),
    "ocf_per_share_ttm" DECIMAL(14,4),
    "fcf_per_share_quarterly" DECIMAL(14,4),
    "fcf_per_share_quarterly_annualized" DECIMAL(14,4),
    "fcf_per_share_ttm" DECIMAL(14,4),
    "operating_cash_flow_value" BIGINT,
    "operating_cash_flow_ttm_value" BIGINT,
    "capital_expenditures_value" BIGINT,
    "capital_expenditures_ttm_value" BIGINT,
    "paid_in_shares" BIGINT,
    "capital_stock_effective_year" INTEGER,
    "capital_stock_effective_month" INTEGER,
    "warnings" TEXT[],
    "computed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "cash_flow_per_share_result_pkey" PRIMARY KEY ("symbol","year","season","data_type","subsidiary_company_id")
);
