-- CreateTable
CREATE TABLE "liquidity_ratio_result" (
    "symbol" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "season" INTEGER NOT NULL,
    "data_type" TEXT NOT NULL,
    "subsidiary_company_id" TEXT NOT NULL DEFAULT '',
    "report_date" DATE,
    "current_ratio_pct" DECIMAL(10,2),
    "quick_ratio_pct" DECIMAL(10,2),
    "current_assets_value" BIGINT,
    "current_liabilities_value" BIGINT,
    "inventory_value" BIGINT,
    "warnings" TEXT[],
    "computed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "liquidity_ratio_result_pkey" PRIMARY KEY ("symbol","year","season","data_type","subsidiary_company_id")
);
