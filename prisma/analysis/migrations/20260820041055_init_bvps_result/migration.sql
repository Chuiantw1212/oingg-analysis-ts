-- CreateTable
CREATE TABLE "bvps_result" (
    "symbol" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "season" INTEGER NOT NULL,
    "data_type" TEXT NOT NULL,
    "subsidiary_company_id" TEXT NOT NULL DEFAULT '',
    "report_date" DATE,
    "bvps" DECIMAL(14,4),
    "equity_field_used" TEXT,
    "equity_value" BIGINT,
    "paid_in_shares" BIGINT,
    "capital_stock_effective_year" INTEGER,
    "capital_stock_effective_month" INTEGER,
    "warnings" TEXT[],
    "computed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "bvps_result_pkey" PRIMARY KEY ("symbol","year","season","data_type","subsidiary_company_id")
);
