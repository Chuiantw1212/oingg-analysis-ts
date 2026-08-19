-- CreateTable
CREATE TABLE "common_stock_par_value_exception" (
    "symbol" TEXT NOT NULL,
    "company_name" TEXT NOT NULL,
    "par_value" DECIMAL(10,2) NOT NULL,
    "common_shares" BIGINT NOT NULL,
    "paid_in_capital" BIGINT NOT NULL,
    "as_of_date" DATE NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "common_stock_par_value_exception_pkey" PRIMARY KEY ("symbol")
);
