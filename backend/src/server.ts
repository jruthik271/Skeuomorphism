import dotenv from 'dotenv';
dotenv.config();

import express, { Request, Response } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import mongoose from 'mongoose';
mongoose.set('bufferCommands', false);
import { connectDB, getDBStatus } from './config/db';
import { errorHandler } from './middleware/errorHandler';

// Route imports
import authRoutes from './routes/authRoutes';
import materialRoutes from './routes/materialRoutes';
import componentRoutes from './routes/componentRoutes';
import collectionRoutes from './routes/collectionRoutes';
import favoriteRoutes from './routes/favoriteRoutes';
import analyticsRoutes from './routes/analyticsRoutes';
import adminRoutes from './routes/adminRoutes';

// Seed runner
import { seedDatabase } from './seed/seed';
import { User } from './models/User';

const app = express();
const PORT = process.env.PORT || 5000;

// Security & Parsing Middlewares
app.use(helmet({ crossOriginResourcePolicy: false }));
app.use(cors({ origin: '*', credentials: true }));
app.use(morgan('dev'));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Root Information & Health Check
app.get('/', (req: Request, res: Response) => {
  res.status(200).json({
    name: 'SkeuoLab Mainframe REST API',
    tagline: 'Interactive Skeuomorphic Design Laboratory Backend',
    version: '1.0.0',
    status: 'ONLINE',
    documentation: '/api/docs',
    health: '/api/health',
  });
});

app.get('/api/health', (req: Request, res: Response) => {
  const dbStatus = getDBStatus();
  res.status(200).json({
    status: 'OK',
    uptime: process.uptime(),
    timestamp: new Date().toISOString(),
    database: {
      connected: dbStatus.isConnected,
      inMemoryFallback: dbStatus.isInMemoryFallback,
      status: dbStatus.ready ? 'READY' : 'DEGRADED',
    },
    system: {
      node: process.version,
      memory: process.memoryUsage(),
    },
  });
});

// Mount API Endpoints
app.use('/api/auth', authRoutes);
app.use('/api/materials', materialRoutes);
app.use('/api/components', componentRoutes);
app.use('/api/collections', collectionRoutes);
app.use('/api/favorites', favoriteRoutes);
app.use('/api/analytics', analyticsRoutes);
app.use('/api/admin', adminRoutes);

// 404 Route Catcher
app.use((req: Request, res: Response) => {
  res.status(404).json({
    success: false,
    error: 'ERR_INSTRUMENT_NOT_FOUND',
    message: `The terminal point [${req.method} ${req.originalUrl}] does not exist on this machine.`,
  });
});

// Central Error Handler
app.use(errorHandler);

// Server Startup Sequence
export const startServer = async () => {
  await connectDB();

  // Auto-seed if database is freshly commissioned
  try {
    const userCount = await User.countDocuments();
    if (userCount === 0) {
      console.log('[Server] First boot detected. Calibrating factory presets...');
      await seedDatabase();
    }
  } catch (err: any) {
    console.warn('[Server] Auto-seed check notice:', err.message);
  }

  const server = app.listen(PORT, () => {
    console.log(`=======================================================`);
    console.log(` ⚙️ SKEUOLAB MAINFRAME ACTIVE`);
    console.log(` 📡 Machine Port: http://localhost:${PORT}`);
    console.log(` 🩺 Health Check: http://localhost:${PORT}/api/health`);
    console.log(` 🧪 Laboratory API Ready for Kinetic Instrumentation`);
    console.log(`=======================================================`);
  });

  return server;
};

if (process.env.NODE_ENV !== 'test') {
  startServer();
}

export default app;
