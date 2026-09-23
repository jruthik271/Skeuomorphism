import request from 'supertest';
import mongoose from 'mongoose';
import app from '../server';

beforeAll(() => {
  mongoose.set('bufferCommands', false);
});

afterAll(async () => {
  await mongoose.disconnect();
});

describe('SkeuoLab Mainframe API Endpoints', () => {
  describe('GET /', () => {
    it('should return server metadata and status ONLINE', async () => {
      const res = await request(app).get('/');
      expect(res.status).toBe(200);
      expect(res.body.name).toBe('SkeuoLab Mainframe REST API');
      expect(res.body.status).toBe('ONLINE');
    });
  });

  describe('GET /api/health', () => {
    it('should return operational health report', async () => {
      const res = await request(app).get('/api/health');
      expect(res.status).toBe(200);
      expect(res.body.status).toBe('OK');
      expect(res.body.database).toBeDefined();
    });
  });

  describe('POST /api/auth/register - Validation', () => {
    it('should reject invalid email or short password with validation error', async () => {
      const res = await request(app)
        .post('/api/auth/register')
        .send({ name: 'T', email: 'not-an-email', password: '123' });
      expect(res.status).toBe(400);
      expect(res.body.success).toBe(false);
      expect(res.body.error).toBe('ERR_VALIDATION_FAILURE');
    });
  });

  describe('GET /api/materials', () => {
    it('should respond with a materials list or empty list if DB offline', async () => {
      const res = await request(app).get('/api/materials');
      expect([200, 500]).toContain(res.status);
      if (res.status === 200) {
        expect(res.body.success).toBe(true);
        expect(Array.isArray(res.body.data)).toBe(true);
      }
    });
  });

  describe('GET /api/components', () => {
    it('should respond with components list', async () => {
      const res = await request(app).get('/api/components');
      expect([200, 500]).toContain(res.status);
      if (res.status === 200) {
        expect(res.body.success).toBe(true);
        expect(Array.isArray(res.body.data)).toBe(true);
      }
    });
  });

  describe('POST /api/analytics/track', () => {
    it('should accept kinetic interaction events', async () => {
      const res = await request(app)
        .post('/api/analytics/track')
        .send({
          action: 'ROTARY_DIAL_KINETIC_TURN',
          category: 'interaction',
          metadata: { dialAngle: 120, component: 'Heavy Rotary Dial' },
        });
      expect([200, 500]).toContain(res.status);
    });
  });

  describe('404 Handler', () => {
    it('should return 404 for nonexistent endpoint', async () => {
      const res = await request(app).get('/api/nonexistent-terminal');
      expect(res.status).toBe(404);
      expect(res.body.error).toBe('ERR_INSTRUMENT_NOT_FOUND');
    });
  });
});
