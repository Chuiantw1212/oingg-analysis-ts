-- CreateTable
CREATE TABLE "debt_ratio_result" (
    "symbol" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "season" INTEGER NOT NULL,
    "data_type" TEXT NOT NULL,
    "subsidiary_company_id" TEXT NOT NULL DEFAULT '',
    "report_date" DATE,
    "debt_ratio_pct" DECIMAL(10,2),
    "total_liabilities_value" BIGINT,
    "total_assets_value" BIGINT,
    "warnings" TEXT[],
    "computed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "debt_ratio_result_pkey" PRIMARY KEY ("symbol","year","season","data_type","subsidiary_company_id")
);
