import { Request, Response, NextFunction } from 'express';

export const errorHandler = (err: any, req: Request, res: Response, next: NextFunction): void => {
  console.error(`[Machine Error] ${req.method} ${req.url}:`, err);

  const statusCode = err.statusCode || (res.statusCode !== 200 ? res.statusCode : 500);

  res.status(statusCode).json({
    success: false,
    error: err.code || 'ERR_INTERNAL_TELEMETRY_FAILURE',
    message: err.message || 'An unexpected instrumentation fault occurred.',
    path: req.originalUrl,
    timestamp: new Date().toISOString(),
  });
};
