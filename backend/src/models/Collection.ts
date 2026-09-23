import mongoose, { Document, Schema } from 'mongoose';

export interface ICollection extends Document {
  userId: mongoose.Types.ObjectId;
  name: string;
  description?: string;
  components: string[];
  materials: string[];
  isPublic: boolean;
  createdAt: Date;
  updatedAt: Date;
}

const CollectionSchema = new Schema<ICollection>(
  {
    userId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    name: { type: String, required: true, trim: true, maxlength: 100 },
    description: { type: String, default: '' },
    components: [{ type: String }],
    materials: [{ type: String }],
    isPublic: { type: Boolean, default: false },
  },
  { timestamps: true }
);

export const Collection = mongoose.model<ICollection>('Collection', CollectionSchema);
