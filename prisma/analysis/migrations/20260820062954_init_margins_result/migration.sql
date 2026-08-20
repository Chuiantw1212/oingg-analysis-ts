-- CreateTable
CREATE TABLE "margins_result" (
    "symbol" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "season" INTEGER NOT NULL,
    "data_type" TEXT NOT NULL,
    "subsidiary_company_id" TEXT NOT NULL DEFAULT '',
    "report_date" DATE,
    "gross_margin_quarterly" DECIMAL(10,2),
    "gross_margin_ttm" DECIMAL(10,2),
    "operating_margin_quarterly" DECIMAL(10,2),
    "operating_margin_ttm" DECIMAL(10,2),
    "net_profit_margin_quarterly" DECIMAL(10,2),
    "net_profit_margin_ttm" DECIMAL(10,2),
    "operating_revenue_value" BIGINT,
    "operating_revenue_ttm_value" BIGINT,
    "gross_profit_value" BIGINT,
    "gross_profit_ttm_value" BIGINT,
    "operating_income_value" BIGINT,
    "operating_income_ttm_value" BIGINT,
    "net_income_field_used" TEXT,
    "net_income_value" BIGINT,
    "net_income_ttm_value" BIGINT,
    "warnings" TEXT[],
    "computed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "margins_result_pkey" PRIMARY KEY ("symbol","year","season","data_type","subsidiary_company_id")
);
