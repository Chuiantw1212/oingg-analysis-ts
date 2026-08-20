import { Router } from 'ultimate-express';
import rootRouter from './domains/system/root';
import roeRouter from './domains/fundamentals/roe/route';
import bvpsRouter from './domains/fundamentals/bvps/route';
import epsRouter from './domains/fundamentals/eps/route';
import revenuePerShareRouter from './domains/fundamentals/revenuePerShare/route';
import cashFlowPerShareRouter from './domains/fundamentals/cashFlowPerShare/route';

const router = Router();

// --- System & Root Routes ---
router.use(rootRouter);

// --- API Routes ---
const apiRouter = Router();
apiRouter.use(roeRouter);
apiRouter.use(bvpsRouter);
apiRouter.use(epsRouter);
apiRouter.use(revenuePerShareRouter);
apiRouter.use(cashFlowPerShareRouter);

router.use('/api/ratios', apiRouter);

export default router;
