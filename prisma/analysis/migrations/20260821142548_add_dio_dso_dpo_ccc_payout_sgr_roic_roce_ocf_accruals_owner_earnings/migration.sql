-- AlterTable
ALTER TABLE "cash_flow_per_share" RENAME CONSTRAINT "cash_flow_per_share_result_pkey" TO "cash_flow_per_share_pkey";

-- AlterTable
ALTER TABLE "guru_graham_number" RENAME CONSTRAINT "graham_number_result_pkey" TO "guru_graham_number_pkey";

-- AlterTable
ALTER TABLE "guru_ncav" RENAME CONSTRAINT "ncav_result_pkey" TO "guru_ncav_pkey";

-- AlterTable
ALTER TABLE "profitability_bvps" RENAME CONSTRAINT "bvps_result_pkey" TO "profitability_bvps_pkey";

-- AlterTable
ALTER TABLE "profitability_eps" RENAME CONSTRAINT "eps_result_pkey" TO "profitability_eps_pkey";

-- AlterTable
ALTER TABLE "profitability_margins" RENAME CONSTRAINT "margins_result_pkey" TO "profitability_margins_pkey";

-- AlterTable
ALTER TABLE "profitability_revenue_per_share" RENAME CONSTRAINT "revenue_per_share_result_pkey" TO "profitability_revenue_per_share_pkey";

-- AlterTable
ALTER TABLE "profitability_roa" RENAME CONSTRAINT "roa_result_pkey" TO "profitability_roa_pkey";

-- AlterTable
ALTER TABLE "profitability_roe" RENAME CONSTRAINT "roe_result_pkey" TO "profitability_roe_pkey";

-- AlterTable
ALTER TABLE "solvency_de_ratio" RENAME CONSTRAINT "de_ratio_result_pkey" TO "solvency_de_ratio_pkey";

-- AlterTable
ALTER TABLE "solvency_debt_ratio" RENAME CONSTRAINT "debt_ratio_result_pkey" TO "solvency_debt_ratio_pkey";

-- AlterTable
ALTER TABLE "solvency_interest_coverage" RENAME CONSTRAINT "interest_coverage_result_pkey" TO "solvency_interest_coverage_pkey";

-- AlterTable
ALTER TABLE "solvency_liquidity_ratio" RENAME CONSTRAINT "liquidity_ratio_result_pkey" TO "solvency_liquidity_ratio_pkey";

-- AlterTable
ALTER TABLE "solvency_net_debt_to_ebitda" RENAME CONSTRAINT "net_debt_to_ebitda_result_pkey" TO "solvency_net_debt_to_ebitda_pkey";

-- AlterTable
ALTER TABLE "turnover_capex_to_revenue" RENAME CONSTRAINT "capex_to_revenue_result_pkey" TO "turnover_capex_to_revenue_pkey";

-- AlterTable
ALTER TABLE "turnover_ratio" RENAME CONSTRAINT "turnover_ratio_result_pkey" TO "turnover_ratio_pkey";

-- AlterTable
ALTER TABLE "turnover_ratio" ADD COLUMN     "accounts_payable_value" BIGINT,
ADD COLUMN     "cash_conversion_cycle_quarterly_annualized" DECIMAL(14,4),
ADD COLUMN     "cash_conversion_cycle_ttm" DECIMAL(14,4),
ADD COLUMN     "inventory_days_quarterly_annualized" DECIMAL(14,4),
ADD COLUMN     "inventory_days_ttm" DECIMAL(14,4),
ADD COLUMN     "payables_days_quarterly_annualized" DECIMAL(14,4),
ADD COLUMN     "payables_days_ttm" DECIMAL(14,4),
ADD COLUMN     "payables_turnover_quarterly" DECIMAL(14,4),
ADD COLUMN     "payables_turnover_quarterly_annualized" DECIMAL(14,4),
ADD COLUMN     "payables_turnover_ttm" DECIMAL(14,4),
ADD COLUMN     "receivables_days_quarterly_annualized" DECIMAL(14,4),
ADD COLUMN     "receivables_days_ttm" DECIMAL(14,4);

-- AlterTable
ALTER TABLE "valuation_market_ratios" RENAME CONSTRAINT "market_ratios_result_pkey" TO "valuation_market_ratios_pkey";

-- CreateTable
CREATE TABLE "profitability_dividend_payout_ratio" (
    "symbol" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "season" INTEGER NOT NULL,
    "data_type" TEXT NOT NULL,
    "subsidiary_company_id" TEXT NOT NULL DEFAULT '',
    "report_date" DATE,
    "payout_ratio_ttm" DECIMAL(10,2),
    "dividends_paid_value" BIGINT,
    "dividends_paid_ttm_value" BIGINT,
    "net_income_field_used" TEXT,
    "net_income_value" BIGINT,
    "net_income_ttm_value" BIGINT,
    "warnings" TEXT[],
    "computed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "profitability_dividend_payout_ratio_pkey" PRIMARY KEY ("symbol","year","season","data_type","subsidiary_company_id")
);

-- CreateTable
CREATE TABLE "profitability_sgr" (
    "symbol" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "season" INTEGER NOT NULL,
    "data_type" TEXT NOT NULL,
    "subsidiary_company_id" TEXT NOT NULL DEFAULT '',
    "report_date" DATE,
    "sgr_ttm" DECIMAL(10,2),
    "roe_ttm_value" DECIMAL(10,2),
    "payout_ratio_ttm_value" DECIMAL(10,2),
    "warnings" TEXT[],
    "computed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "profitability_sgr_pkey" PRIMARY KEY ("symbol","year","season","data_type","subsidiary_company_id")
);

-- CreateTable
CREATE TABLE "cash_flow_ocf_to_net_income" (
    "symbol" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "season" INTEGER NOT NULL,
    "data_type" TEXT NOT NULL,
    "subsidiary_company_id" TEXT NOT NULL DEFAULT '',
    "report_date" DATE,
    "ocf_to_net_income_quarterly" DECIMAL(14,4),
    "ocf_to_net_income_ttm" DECIMAL(14,4),
    "operating_cash_flow_value" BIGINT,
    "operating_cash_flow_ttm_value" BIGINT,
    "net_income_field_used" TEXT,
    "net_income_value" BIGINT,
    "net_income_ttm_value" BIGINT,
    "warnings" TEXT[],
    "computed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "cash_flow_ocf_to_net_income_pkey" PRIMARY KEY ("symbol","year","season","data_type","subsidiary_company_id")
);

-- CreateTable
CREATE TABLE "cash_flow_accruals_ratio" (
    "symbol" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "season" INTEGER NOT NULL,
    "data_type" TEXT NOT NULL,
    "subsidiary_company_id" TEXT NOT NULL DEFAULT '',
    "report_date" DATE,
    "accruals_ratio_quarterly" DECIMAL(10,2),
    "accruals_ratio_quarterly_annualized" DECIMAL(10,2),
    "accruals_ratio_ttm" DECIMAL(10,2),
    "net_income_field_used" TEXT,
    "net_income_value" BIGINT,
    "net_income_ttm_value" BIGINT,
    "operating_cash_flow_value" BIGINT,
    "operating_cash_flow_ttm_value" BIGINT,
    "investing_cash_flow_value" BIGINT,
    "investing_cash_flow_ttm_value" BIGINT,
    "total_assets_value" BIGINT,
    "warnings" TEXT[],
    "computed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "cash_flow_accruals_ratio_pkey" PRIMARY KEY ("symbol","year","season","data_type","subsidiary_company_id")
);

-- CreateTable
CREATE TABLE "profitability_roce" (
    "symbol" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "season" INTEGER NOT NULL,
    "data_type" TEXT NOT NULL,
    "subsidiary_company_id" TEXT NOT NULL DEFAULT '',
    "report_date" DATE,
    "roce_quarterly_pct" DECIMAL(10,2),
    "roce_quarterly_annualized_pct" DECIMAL(10,2),
    "roce_ttm_pct" DECIMAL(10,2),
    "ebit_value" BIGINT,
    "ebit_ttm_value" BIGINT,
    "capital_employed_value" BIGINT,
    "warnings" TEXT[],
    "computed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "profitability_roce_pkey" PRIMARY KEY ("symbol","year","season","data_type","subsidiary_company_id")
);

-- CreateTable
CREATE TABLE "profitability_roic" (
    "symbol" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "season" INTEGER NOT NULL,
    "data_type" TEXT NOT NULL,
    "subsidiary_company_id" TEXT NOT NULL DEFAULT '',
    "report_date" DATE,
    "roic_quarterly_pct" DECIMAL(10,2),
    "roic_quarterly_annualized_pct" DECIMAL(10,2),
    "roic_ttm_pct" DECIMAL(10,2),
    "nopat_value" BIGINT,
    "nopat_ttm_value" BIGINT,
    "invested_capital_value" BIGINT,
    "equity_field_used" TEXT,
    "equity_value" BIGINT,
    "warnings" TEXT[],
    "computed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "profitability_roic_pkey" PRIMARY KEY ("symbol","year","season","data_type","subsidiary_company_id")
);

-- CreateTable
CREATE TABLE "guru_owner_earnings" (
    "symbol" TEXT NOT NULL,
    "year" INTEGER NOT NULL,
    "season" INTEGER NOT NULL,
    "data_type" TEXT NOT NULL,
    "subsidiary_company_id" TEXT NOT NULL DEFAULT '',
    "report_date" DATE,
    "owner_earnings_per_share_quarterly" DECIMAL(14,4),
    "owner_earnings_per_share_quarterly_annualized" DECIMAL(14,4),
    "owner_earnings_per_share_ttm" DECIMAL(14,4),
    "net_income_field_used" TEXT,
    "net_income_value" BIGINT,
    "net_income_ttm_value" BIGINT,
    "depreciation_and_amortization_value" BIGINT,
    "depreciation_and_amortization_ttm_value" BIGINT,
    "capital_expenditures_value" BIGINT,
    "capital_expenditures_ttm_value" BIGINT,
    "paid_in_shares" BIGINT,
    "capital_stock_effective_year" INTEGER,
    "capital_stock_effective_month" INTEGER,
    "warnings" TEXT[],
    "computed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "guru_owner_earnings_pkey" PRIMARY KEY ("symbol","year","season","data_type","subsidiary_company_id")
);
