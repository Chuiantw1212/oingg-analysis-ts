import { Router } from 'ultimate-express';
import rootRouter from './domains/system/root';
import roeRouter from './domains/profitability/roe/route';
import roaRouter from './domains/profitability/roa/route';
import bvpsRouter from './domains/profitability/bvps/route';
import epsRouter from './domains/profitability/eps/route';
import revenuePerShareRouter from './domains/profitability/revenuePerShare/route';
import cashFlowPerShareRouter from './domains/cashFlow/cashFlowPerShare/route';
import debtRatioRouter from './domains/solvency/debtRatio/route';
import liquidityRatioRouter from './domains/solvency/liquidityRatio/route';
import turnoverRatioRouter from './domains/turnover/turnoverRatio/route';

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
