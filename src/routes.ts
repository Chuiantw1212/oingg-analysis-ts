import { Router } from 'ultimate-express';
import rootRouter from './domains/system/root';
import roeRouter from './domains/profitabilityAndCapitalAllocation/roe/route';
import roaRouter from './domains/profitabilityAndCapitalAllocation/roa/route';
import bvpsRouter from './domains/profitabilityAndCapitalAllocation/bvps/route';
import epsRouter from './domains/profitabilityAndCapitalAllocation/eps/route';
import revenuePerShareRouter from './domains/profitabilityAndCapitalAllocation/revenuePerShare/route';
import cashFlowPerShareRouter from './domains/cashFlowAndEarningsQuality/cashFlowPerShare/route';
import debtRatioRouter from './domains/solvencyAndFinancialHealth/debtRatio/route';
import liquidityRatioRouter from './domains/solvencyAndFinancialHealth/liquidityRatio/route';
import turnoverRatioRouter from './domains/operatingEfficiencyAndTurnover/turnoverRatio/route';

const router = Router();

// --- System & Root Routes ---
router.use(rootRouter);

// --- API Routes ---
const apiRouter = Router();
apiRouter.use(roeRouter);
apiRouter.use(roaRouter);
apiRouter.use(bvpsRouter);
apiRouter.use(epsRouter);
apiRouter.use(revenuePerShareRouter);
apiRouter.use(cashFlowPerShareRouter);
apiRouter.use(debtRatioRouter);
apiRouter.use(liquidityRatioRouter);
apiRouter.use(turnoverRatioRouter);

router.use('/api/ratios', apiRouter);

export default router;
