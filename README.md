# LawnMower-Sim

Entorno de simulación 3D para el robot cortacésped autónomo **LawnMower-Nav2**.

Basado en **O3DE 25.05** con el **ROS2 Gem** (Jazzy). Simula el jardín, el robot diferencial y todos los sensores del hardware real — publicando exactamente los mismos topics ROS2 que el stack de navegación espera.

> Este repo es solo infraestructura de simulación. El código del robot (Nav2, mission_server, coverage, dashboard) vive en [LawnMower-Nav2](https://github.com/BrancoBogdanich/LawnMower-Nav2).

## Arquitectura

```
LawnMower-Sim (este repo)          LawnMower-Nav2
┌─────────────────────────┐        ┌──────────────────────────┐
│  O3DE — Mundo jardín 3D │        │  Nav2 + EKF + mission    │
│                         │        │  server + coverage +     │
│  Robot diferencial      │        │  dashboard               │
│  LiDAR 18-ring 5.55Hz   │──────▶│                          │
│  GPS/RTK NavSatFix      │ topics │  Mismo stack que corre   │
│  IMU 250Hz              │  ROS2  │  en el Jetson real       │
│  Encoders CPR=28        │        │                          │
│  Jardín + obstáculos    │◀──────│  /cmd_vel                │
└─────────────────────────┘        └──────────────────────────┘
```

## Hardware simulado

| Componente real | Simulado en O3DE |
|---|---|
| MY1016Z3 differential drive (0.6m separación, ruedas 0.125m) | `SkidSteeringControlComponent` |
| Unitree 4D LiDAR L2 (18 rings, 360°, 5.55Hz) | `ROS2 Lidar Sensor` preset custom |
| Here4 GPS/RTK (NavSatFix + covariance RTK/float/lost) | `ROS2 GNSS Sensor` + degradation node |
| IMU ArduPilot EKF3 (ruido gaussiano real) | `ImuSensorConfiguration` |
| Encoders Hall NJK-5002C CPR=28 | `WheelOdometrySensor` + cuantización |
| Jardín con árboles, pasto, terreno irregular | Terrain Gem + Vegetation Gem |
| Brazo bordeadora (Fase 4+) | `Ros2RoboticManipulationTemplate` + MoveIt2 |

## Topics ROS2 — compatibilidad exacta con LawnMower-Nav2

| Topic O3DE publica | Tipo | Equivalente hardware real |
|---|---|---|
| `/unilidar/cloud` | `PointCloud2` | Unitree L2 SDK |
| `/mavros/mavros/raw/fix` | `NavSatFix` | Here4 via MAVROS |
| `/imu/data` | `Imu` | imu_relay.py |
| `/mavros/mavros/wheel_odometry/odom` | `Odometry` | MAVROS wheel_odom plugin |
| `/odom` | `Odometry` | odom_relay.py |
| `/tf` | TF tree | odom→base_link |

| Topic O3DE suscribe | Tipo |
|---|---|
| `/cmd_vel` | `Twist` |

## Levantar la simulación

```bash
# Solo O3DE (headless, sin display)
docker compose --profile o3de up -d

# Con display (desarrollo en Linux con X11)
docker compose --profile o3de-gui up -d

# Stack completo: Nav2 + O3DE
cd ../LawnMower-Nav2
docker compose --profile o3de up -d
```

### Visualización
- **Foxglove Studio:** `ws://localhost:8769`
- **Dashboard:** `http://localhost:3002` (en LawnMower-Nav2)

## Basado en

- [O3DE ROSConDemo](https://github.com/o3de/ROSConDemo) — robot outdoor + Nav2
- [RobotecAI ROSCon2023Demo](https://github.com/RobotecAI/ROSCon2023Demo) — RGL LiDAR GPU
- [RobotecAI rai-agriculture-demo](https://github.com/RobotecAI/rai-agriculture-demo) — robot en jardín/huerto
- [O3DE ROS2 Gem docs](https://docs.o3de.org/docs/user-guide/gems/reference/robotics/ros2/)

## Estructura del repo

```
LawnMower-Sim/
├── docker/
│   ├── Dockerfile.o3de         ← imagen O3DE 25.05 + ROS2 Jazzy
│   └── docker-compose.yml      ← perfil o3de
├── project/                    ← proyecto O3DE (CMakeLists, Gems, etc.)
│   ├── CMakeLists.txt
│   ├── project.json
│   ├── Assets/
│   │   ├── Levels/             ← mundos (garden.prefab)
│   │   └── Robot/              ← modelo del robot (meshes, materials)
│   └── Gem/                    ← código custom (sensores, degradación GPS)
├── config/
│   └── ros2_topics.yaml        ← mapeo topics O3DE → ROS2
└── docs/
    ├── setup.md                ← guía de instalación O3DE
    ├── sensors.md              ← config de cada sensor
    └── sim-to-real.md          ← guía validación sim vs hardware real
```

## Estado

| Componente | Estado |
|---|---|
| Estructura repo | ✅ |
| Dockerfile O3DE 25.05 + ROS2 Jazzy | 🔲 en progreso |
| Robot modelo diferencial | 🔲 pendiente |
| LiDAR 18-ring config | 🔲 pendiente |
| GPS + degradation sim | 🔲 pendiente |
| IMU config | 🔲 pendiente |
| Jardín — Terrain + Vegetation | 🔲 pendiente |
| Nav2 integrado y navegando | 🔲 pendiente |
| Brazo (Fase 4+) | ⏳ futuro |
