-- AlterTable
ALTER TABLE "liquidity_ratio_result" ADD COLUMN     "cash_and_equivalents_value" BIGINT,
ADD COLUMN     "cash_ratio_pct" DECIMAL(10,2);

-- CreateTable
CREATE TABLE "de_ratio_result" (
    "symbol" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "season" INTEGER NOT NULL,
    "data_type" TEXT NOT NULL,
    "subsidiary_company_id" TEXT NOT NULL DEFAULT '',
    "report_date" DATE,
    "de_ratio_pct" DECIMAL(10,2),
    "total_debt_value" BIGINT,
    "equity_field_used" TEXT,
    "equity_value" BIGINT,
    "warnings" TEXT[],
    "computed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "de_ratio_result_pkey" PRIMARY KEY ("symbol","year","season","data_type","subsidiary_company_id")
);

-- CreateTable
CREATE TABLE "interest_coverage_result" (
    "symbol" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "season" INTEGER NOT NULL,
    "data_type" TEXT NOT NULL,
    "subsidiary_company_id" TEXT NOT NULL DEFAULT '',
    "report_date" DATE,
    "interest_coverage_quarterly" DECIMAL(14,4),
    "interest_coverage_ttm" DECIMAL(14,4),
    "ebit_value" BIGINT,
    "ebit_ttm_value" BIGINT,
    "interest_expense_value" BIGINT,
    "interest_expense_ttm_value" BIGINT,
    "warnings" TEXT[],
    "computed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "interest_coverage_result_pkey" PRIMARY KEY ("symbol","year","season","data_type","subsidiary_company_id")
);
