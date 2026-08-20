import { Router } from 'ultimate-express';
import rootRouter from './domains/system/root';
import roeRouter from './domains/roe/route';
import bvpsRouter from './domains/bvps/route';
import epsRouter from './domains/eps/route';
import revenuePerShareRouter from './domains/revenuePerShare/route';

const router = Router();

// --- System & Root Routes ---
router.use(rootRouter);

// --- API Routes ---
const apiRouter = Router();
apiRouter.use(roeRouter);
apiRouter.use(bvpsRouter);
apiRouter.use(epsRouter);
apiRouter.use(revenuePerShareRouter);

router.use('/api/ratios', apiRouter);

export default router;
