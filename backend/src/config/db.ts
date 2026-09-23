import mongoose from 'mongoose';

let isConnected = false;
let isInMemoryFallback = false;

export const connectDB = async (): Promise<void> => {
  const uri = process.env.MONGODB_URI || 'mongodb://localhost:27017/skeuolab';

  try {
    mongoose.set('strictQuery', false);
    const conn = await mongoose.connect(uri, {
      serverSelectionTimeoutMS: 2000,
    });
    isConnected = true;
    isInMemoryFallback = false;
    console.log(`[Database] MongoDB Connected: ${conn.connection.host}`);
  } catch (error: any) {
    console.warn(`[Database] MongoDB connection failed (${error.message}).`);
    console.warn(`[Database] Activating resilient in-memory fallback persistence for local development.`);
    mongoose.set('bufferCommands', false);
    isConnected = false;
    isInMemoryFallback = true;
  }
};

export const getDBStatus = () => ({
  isConnected,
  isInMemoryFallback,
  ready: isConnected || isInMemoryFallback,
});
