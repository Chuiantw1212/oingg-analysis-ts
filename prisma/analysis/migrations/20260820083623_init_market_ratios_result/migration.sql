-- CreateTable
CREATE TABLE "market_ratios_result" (
    "symbol" TEXT NOT NULL,
    "trade_date" DATE NOT NULL,
    "pe_ratio" DECIMAL(10,2),
    "pb_ratio" DECIMAL(10,2),
    "dividend_yield_pct" DECIMAL(10,2),
    "warnings" TEXT[],
    "computed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "market_ratios_result_pkey" PRIMARY KEY ("symbol","trade_date")
);
