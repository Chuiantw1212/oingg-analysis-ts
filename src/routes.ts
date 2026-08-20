import { Router } from 'ultimate-express';
import rootRouter from './domains/system/root';
import roeRouter from './domains/roe/route';
import bvpsRouter from './domains/bvps/route';

const router = Router();

// --- System & Root Routes ---
router.use(rootRouter);

// --- API Routes ---
const apiRouter = Router();
apiRouter.use(roeRouter);
apiRouter.use(bvpsRouter);

router.use('/api/ratios', apiRouter);

export default router;
