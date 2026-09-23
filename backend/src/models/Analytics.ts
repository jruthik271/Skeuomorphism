import mongoose, { Document, Schema } from 'mongoose';

export interface IActivity extends Document {
  userId?: mongoose.Types.ObjectId;
  action: string;
  category: 'interaction' | 'theme' | 'code_generation' | 'playground' | 'auth';
  metadata: Record<string, any>;
  timestamp: Date;
}

const ActivitySchema = new Schema<IActivity>(
  {
    userId: { type: Schema.Types.ObjectId, ref: 'User' },
    action: { type: String, required: true },
    category: {
      type: String,
      enum: ['interaction', 'theme', 'code_generation', 'playground', 'auth'],
      default: 'interaction',
    },
    metadata: { type: Schema.Types.Mixed, default: {} },
    timestamp: { type: Date, default: Date.now },
  },
  { timestamps: false }
);

export const Activity = mongoose.model<IActivity>('Activity', ActivitySchema);

export interface IAnalyticsStat extends Document {
  date: string;
  totalInteractions: number;
  activeUsers: number;
  popularMaterial: string;
  popularComponent: string;
  themeSwitches: Record<string, number>;
  codeExports: number;
}

const AnalyticsStatSchema = new Schema<IAnalyticsStat>(
  {
    date: { type: String, required: true, unique: true },
    totalInteractions: { type: Number, default: 0 },
    activeUsers: { type: Number, default: 0 },
    popularMaterial: { type: String, default: 'aluminum' },
    popularComponent: { type: String, default: 'button' },
    themeSwitches: { type: Schema.Types.Mixed, default: {} },
    codeExports: { type: Number, default: 0 },
  },
  { timestamps: true }
);

export const AnalyticsStat = mongoose.model<IAnalyticsStat>('AnalyticsStat', AnalyticsStatSchema);
