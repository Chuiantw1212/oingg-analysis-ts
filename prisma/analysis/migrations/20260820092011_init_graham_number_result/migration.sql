-- CreateTable
CREATE TABLE "graham_number_result" (
    "symbol" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "season" INTEGER NOT NULL,
    "data_type" TEXT NOT NULL,
    "subsidiary_company_id" TEXT NOT NULL DEFAULT '',
    "report_date" DATE,
    "graham_number" DECIMAL(14,4),
    "eps_ttm_value" DECIMAL(14,4),
    "bvps_value" DECIMAL(14,4),
    "warnings" TEXT[],
    "computed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "graham_number_result_pkey" PRIMARY KEY ("symbol","year","season","data_type","subsidiary_company_id")
);
