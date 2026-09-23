# SkeuoLab REST API Documentation

The **SkeuoLab Mainframe REST API** powers the Interactive Skeuomorphic Design Laboratory. It manages physical material specimens, mechanical interactive components, operator parts drawers, kinetic telemetry pulses, and administrator recalibration routines.

- **Base URL**: `http://localhost:5000/api`
- **Default Port**: `5000`
- **Specification**: RESTful JSON over HTTP
- **Authentication**: JWT Bearer Token (`Authorization: Bearer <token>`)

---

## Default Calibration Credentials

| Role | Callsign / Email | Passkey | Privileges |
| :--- | :--- | :--- | :--- |
| **ADMIN** | `admin@skeuolab.com` | `AdminPass123!` | Full factory recalibration, user clearance, system telemetry |
| **USER** | `user@skeuolab.com` | `UserPass123!` | Parts drawers, favorites, custom component synthesis |

---

## 1. System & Health

### `GET /api/health`
Returns system operational health, uptime, and database status.
```json
{
  "status": "OK",
  "uptime": 142.3,
  "timestamp": "2026-09-23T12:00:00.000Z",
  "database": {
    "connected": true,
    "inMemoryFallback": false,
    "status": "READY"
  }
}
```

---

## 2. Operator Authentication (`/api/auth`)

### `POST /api/auth/register`
Commissions a new operator account.
- **Body**: `{ "name": "string", "email": "string", "password": "string (min 6)" }`

### `POST /api/auth/login`
Unlocks operator console and returns JWT bearer token.
- **Body**: `{ "email": "string", "password": "string" }`
- **Response**:
```json
{
  "success": true,
  "message": "Authentication successful. Control console unlocked.",
  "data": {
    "user": { "id": "...", "name": "...", "email": "...", "role": "USER" },
    "token": "eyJhbGciOiJIUzI1NiIs..."
  }
}
```

### `GET /api/auth/me` *(Auth Required)*
Returns active operator profile and statistics.

### `POST /api/auth/logout` *(Auth Required)*
Terminates session and records departure in activity logs.

---

## 3. Physical Materials Library (`/api/materials`)

### `GET /api/materials`
Lists all calibrated physical materials (brass, aluminum, bakelite, walnut, copper, glass, etc.).
- **Query Params**: `category` (metals, organics, displays, papers, glass), `search` (string)

### `GET /api/materials/:id`
Retrieves a single material specimen by ID with optical properties and code snippets.

### `POST /api/materials` *(Auth Required)*
Registers a new material specimen.

### `PUT /api/materials/:id` *(Auth Required)*
Updates or recalibrates a material specimen.

### `DELETE /api/materials/:id` *(Auth Required)*
Decommissions a custom material formula.

---

## 4. Mechanical Components (`/api/components`)

### `GET /api/components`
Retrieves physical components catalogue (rotary dials, toggle switches, VU meters, sliders, Nixie tubes, etc.).
- **Query Params**: `category` (controls, displays, containers, artifacts), `search` (string)

### `GET /api/components/:id`
Inspects blueprint of a single component.

### `POST /api/components` *(Auth Required)*
Registers a new component blueprint.

### `POST /api/components/:id/interact`
Logs kinetic interaction pulses (knob turns, switch flips, button pushes) and increments engagement telemetry.

---

## 5. Parts Drawers / Collections (`/api/collections`)

### `GET /api/collections` *(Auth Required)*
Retrieves operator parts drawers and assemblies.

### `POST /api/collections` *(Auth Required)*
Creates a new parts drawer.
- **Body**: `{ "name": "string", "description": "string", "components": [], "materials": [] }`

### `DELETE /api/collections/:id` *(Auth Required)*
Decommissions a parts drawer.

### `POST /api/collections/:id/items` *(Auth Required)*
Appends a component or material to a designated drawer.

---

## 6. Kinetic Telemetry & Analytics (`/api/analytics`)

### `POST /api/analytics/track`
Logs real-time kinetic events from operators (oscillator clicks, theme changes, code exports).

### `GET /api/analytics/me` *(Auth Required)*
Returns authenticated operator's interaction statistics.

### `GET /api/analytics/admin` *(Admin Required)*
Returns central mainframe metrics, weekly activity trends, and system loads.

---

## 7. Administrator Controls (`/api/admin`)

### `GET /api/admin/stats` *(Admin Required)*
Mainframe telemetry summary (total users, materials, components, uptime, memory).

### `GET /api/admin/users` *(Admin Required)*
Paginated operator manifest.

### `PUT /api/admin/users/:userId/role` *(Admin Required)*
Promotes or demotes operator clearance (`USER` <-> `ADMIN`).

### `POST /api/admin/reseed` *(Admin Required)*
Recalibrates the database to factory baseline presets (14 materials, 15 components, default operator accounts).
