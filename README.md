# 🎛️ SkeuoLab — Interactive Skeuomorphic Design Laboratory & Workbench

[![Flutter](https://img.shields.io/badge/Flutter-3.29+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Node.js](https://img.shields.io/badge/Node.js-20+-339933?logo=node.js&logoColor=white)](https://nodejs.org)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.8-3178C6?logo=typescript&logoColor=white)](https://www.typescriptlang.org)
[![MongoDB](https://img.shields.io/badge/MongoDB-Mongoose%208-47A248?logo=mongodb&logoColor=white)](https://www.mongodb.com)
[![Platform](https://img.shields.io/badge/Platform-Web%20%7C%20Windows%20%7C%20iOS%20%7C%20Android-4CAF50)](#platform-support)
[![Build](https://img.shields.io/badge/Build-Web%20Release%20Ready-blue)](#production-deployment)
[![Tests](https://img.shields.io/badge/Tests-Passing%20100%25-brightgreen)](#automated-testing)
[![License](https://img.shields.io/badge/License-MIT-amber)](#license)

> **"This is a real physical machine that happens to exist inside a browser."**

**SkeuoLab** is a full-stack, production-ready skeuomorphic design laboratory and physical instrumentation workbench. It pairs an authentic tactile **Flutter Web frontend** with a resilient **Node.js + Express + TypeScript + MongoDB REST API backend**, featuring real-time mechanical sound synthesis, ballistic needle physics, CRT phosphor scanlines, 3D specular light raytracing, and code generation.

---

## 🏗️ Repository Architecture

The project is strictly organized into clean, independent frontend and backend workspaces:

```text
c:\Desktop\Skeuomorphism\
├── frontend\                         # Flutter Web Application
│   ├── lib\
│   │   ├── app\                      # App configuration, theme tokens & desktop workbench shell
│   │   ├── core\network\             # ApiClient with JWT auth & resilient offline fallback
│   │   ├── models\                   # Material, Component, Collection & Telemetry models
│   │   ├── providers\                # State management (Auth, Materials, Components, Collections, Analytics)
│   │   ├── screens\                  # 11 authentic instrument consoles & bay screens
│   │   │   ├── home_screen.dart      # Flagship laboratory console & master controls
│   │   │   ├── controls_screen.dart  # High-voltage physical controls bay
│   │   │   ├── laboratory/           # Incident light chamber & 3D specular calibrator
│   │   │   ├── playground/           # Live skeuomorphic synthesizer & multi-tab code exporter
│   │   │   ├── palettes_screen.dart  # 10 physical material palettes & swatch tokens
│   │   │   ├── objects_screen.dart   # Rangefinder camera, tape deck, field notebook
│   │   │   ├── collections/          # Operator parts drawers & custom assemblies
│   │   │   ├── analytics/            # P31 phosphor CRT terminal & ballistic analog meters
│   │   │   ├── auth/                 # Physical machine tumbler passkey console
│   │   │   ├── admin/                # Privileged factory calibration & system diagnostics
│   │   │   └── about_screen.dart     # Physical pillars & architectural specification
│   │   ├── styles\                   # Skeuomorphic colors, gradients, shadows & decorations
│   │   ├── utils\                    # Web Audio API sound synthesis & haptics
│   │   └── widgets\                  # Machined knobs, switches, meters, screws, and engraved plates
│   ├── web\                          # PWA manifest, SEO meta tags, Web Audio oscillator script
│   ├── test\                         # Widget and integration test suite
│   └── pubspec.yaml                  # Flutter dependencies (http, provider, shared_preferences)
│
├── backend\                          # Node.js + Express + TypeScript REST API
│   ├── src\
│   │   ├── config\                   # Resilient database connection (with in-memory fallback)
│   │   ├── controllers\              # Auth, Material, Component, Collection, Favorite, Analytics, Admin
│   │   ├── middleware\               # JWT verification, RBAC roles, Zod validation, Error handler
│   │   ├── models\                   # Mongoose schemas (User, Material, Component, Collection, Analytics)
│   │   ├── routes\                   # REST API routes mounted on /api
│   │   ├── seed\                     # Factory calibration script (14 materials, 15 components, users)
│   │   ├── __tests__\                # Jest API integration test suite
│   │   └── server.ts                 # Express application entrypoint
│   ├── package.json                  # Dependencies & scripts
│   └── tsconfig.json                 # TypeScript compiler configuration
│
├── .github\workflows\ci.yml          # Automated CI/CD pipeline for backend and frontend
├── API.md                            # Comprehensive REST API endpoint reference
└── README.md                         # Project documentation
```

---

## ⚡ Quick Start

### 1. Start the Backend API Server
```bash
cd backend
npm install
npm run seed     # Calibrate database with factory presets (Admin, User, Materials, Components)
npm run dev      # Starts server on http://localhost:5000
```

> **Note on Database Resiliency:** If a local MongoDB instance is not detected, the backend automatically engages its built-in in-memory fallback persistence mode so you can immediately interact with the full suite of APIs with zero setup!

To run backend tests:
```bash
npm test
```

### 2. Launch the Flutter Web Frontend
```bash
cd frontend
flutter pub get
flutter run -d chrome
```

To run frontend widget & integration tests:
```bash
flutter test
```

To build production release bundle:
```bash
flutter build web --release
```

---

## 🔑 Factory Calibration Access Keys

Use these pre-commissioned credentials in the **Operator Clearance** console:

| Clearance Level | Callsign / Email | Passkey | Key Capabilities |
| :--- | :--- | :--- | :--- |
| **Chief Instrument Engineer (ADMIN)** | `admin@skeuolab.com` | `AdminPass123!` | Factory recalibration, user manifest, system health telemetry |
| **Apprentice Operator (USER)** | `user@skeuolab.com` | `UserPass123!` | Parts drawers, quick-access tool belt, kinetic telemetry logging |

---

## 🌟 Key Application Features

### 1. 🔬 Optical Testing Bay (Incident Light Chamber)
- Dynamic 360° light azimuth slider (`315° Key Light`, `180° Top Down`, `45° Rim Light`).
- Live 3D specular raytraced sphere and lathe cylinder rendered with anisotropic reflections.
- Real-time material roughness and metallic luster adjustments.
- Instant 1-click CSS gradient and box-shadow synthesis.

### 2. 🎛️ Component Playground & Synthesizer
- Interactive testing stage for: Knurled Rotary Potentiometer, Industrial Toggle Switch, Illuminated Rocker, Momentary Push Button, Ballistic VU Meter, and Linear Fader.
- Substrate finish switcher: Machined Aluminum, Antique Brass, Vintage Bakelite, American Walnut.
- Multi-format code generator exporting **Flutter Dart code**, **Vanilla CSS**, and **JSON token blueprints**.

### 3. 🗄️ Machinist Parts Drawers (Collections)
- Create, inspect, and decommission custom electronic racks and assemblies.
- Filter parts by components and physical materials.
- Real-time synchronization with the backend API.

### 4. 📺 Central Telemetry & Phosphor CRT Display
- Real-time curved cathode ray tube with horizontal scanline grid emitting iconic 525nm green luminescence.
- Dual ballistic analog meters (Audio Signal dB & 120V AC Mainframe Line Voltage).
- Machine telemetry dials showing local pulses, active operators, CPU load, and server uptime.
- Live kinetic pulse trigger actuator.

### 5. 🔊 Web Audio API Acoustic Synthesizer
- Built-in sound generator using browser audio oscillators: crisp mechanical button clicks, heavy toggle clacks, and potentiometer ratchet ticks.
- Zero audio file downloads required—lightweight, instant, and reliable.
- Dedicated physical mute / unmute switch with illuminated status jewel.

---

## 📡 REST API Overview

All API endpoints are prefixed with `/api`. Complete documentation is available in [API.md](file:///c:/Desktop/Skeuomorphism/API.md).

- `GET /api/health` — System status, uptime, and database connectivity.
- `POST /api/auth/login` — Authenticate operator and receive JWT token.
- `POST /api/auth/register` — Commission a new operator account.
- `GET /api/materials` — Browse 14 physical skeuomorphic materials.
- `GET /api/components` — Browse 15 mechanical interactive components.
- `POST /api/components/:id/interact` — Record kinetic pulse interaction.
- `GET /api/collections` — Access operator parts drawers.
- `POST /api/analytics/track` — Record telemetry events.
- `POST /api/admin/reseed` — Reset database to factory calibration presets.

---

## 🧪 Automated Testing

Both workspaces feature comprehensive automated test suites:

- **Backend:** `npm test` runs 7 Jest integration tests covering server health, Zod validation, material repositories, component blueprints, and kinetic pulse logging.
- **Frontend:** `flutter test` verifies widget rendering, brass engraved plates, interaction counters, tab navigation, and responsive constraints.
- **Analyzer:** `flutter analyze` runs with 0 warnings.
- **CI/CD:** Automated `.github/workflows/ci.yml` executes on every pull request and push to `main`.

---

## 📜 License

Distributed under the MIT License. Built with passion for authentic physical craftsmanship, mechanical precision, and tactile digital design.
