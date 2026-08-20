-- CreateTable
CREATE TABLE "ncav_result" (
    "symbol" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "season" INTEGER NOT NULL,
    "data_type" TEXT NOT NULL,
    "subsidiary_company_id" TEXT NOT NULL DEFAULT '',
    "report_date" DATE,
    "ncav" DECIMAL(14,4),
    "margin_of_safety_price" DECIMAL(14,4),
    "current_assets_value" BIGINT,
    "total_liabilities_value" BIGINT,
    "preferred_stock_value" BIGINT,
    "paid_in_shares" BIGINT,
    "capital_stock_effective_year" INTEGER,
    "capital_stock_effective_month" INTEGER,
    "warnings" TEXT[],
    "computed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ncav_result_pkey" PRIMARY KEY ("symbol","year","season","data_type","subsidiary_company_id")
);
