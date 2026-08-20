-- CreateTable
CREATE TABLE "net_debt_to_ebitda_result" (
    "symbol" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "season" INTEGER NOT NULL,
    "data_type" TEXT NOT NULL,
    "subsidiary_company_id" TEXT NOT NULL DEFAULT '',
    "report_date" DATE,
    "net_debt_to_ebitda_quarterly_annualized" DECIMAL(14,4),
    "net_debt_to_ebitda_ttm" DECIMAL(14,4),
    "net_debt_value" BIGINT,
    "total_debt_value" BIGINT,
    "cash_and_equivalents_value" BIGINT,
    "ebitda_quarterly_value" BIGINT,
    "ebitda_ttm_value" BIGINT,
    "warnings" TEXT[],
    "computed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "net_debt_to_ebitda_result_pkey" PRIMARY KEY ("symbol","year","season","data_type","subsidiary_company_id")
);
