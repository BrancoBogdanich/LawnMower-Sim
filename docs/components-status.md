# Estado de emulación — Componentes hardware en O3DE

## Sensores del robot

| Componente real | Emulación O3DE | Topic | Estado |
|---|---|---|---|
| Unitree L2 LiDAR (18 rings, 5.55Hz) | RGL LiDAR Component | `/unilidar/cloud` | ⏳ configurar en Editor |
| Here4 GPS RTK | ROS2 GNSS Sensor | `/mavros/mavros/raw/fix` | ⏳ configurar en Editor |
| IMU Cube Orange+ (200Hz) | ROS2 IMU Sensor | `/imu/data` | ⏳ configurar en Editor |
| MT6701 encoders (CPR=4096) | ROS2 Vehicle Model | `/mavros/mavros/wheel_odometry/odom` | ⏳ configurar en Editor |
| ArduPilot EKF3 → MAVROS odom | ROS2 DiffDrive Component | `/odom` → bridge | ⚠️ ver nota abajo |

## Actuadores

| Componente real | Emulación O3DE | Topic | Estado |
|---|---|---|---|
| Cytron MDD20A + MY1016Z3 | PhysX DiffDrive | `/cmd_vel` | ⏳ configurar en Editor |
| Fricción ruedas motrices | PhysX Material grass | — | ⏳ configurar en Editor |
| Casters (fricción cero) | PhysX Material frictionless | — | ⏳ configurar en Editor |

## Mundo / entorno

| Elemento | Emulación O3DE | Estado |
|---|---|---|
| Jardín 20×15m | Terrain Gem + Vegetation | ⏳ construir en Editor |
| 3 árboles | Static Mesh + PhysX collider | ⏳ construir en Editor |
| Muros perímetro | Static Mesh + PhysX collider | ⏳ construir en Editor |
| Macetas / obstáculos | Static Mesh + PhysX collider | ⏳ construir en Editor |
| Pasto (fricción variable) | PhysX Material grass/wet | ⏳ configurar en Editor |
| GPS datum correcto | GeoReference Component | ⏳ configurar en Editor |

## Software — nodos adicionales necesarios

| Nodo | Propósito | Estado |
|---|---|---|
| `odom_bridge_node.py` | `/odom` → `/mavros/mavros/odom` (QoS BEST_EFFORT) | ❌ falta crear |
| `gps_degradation_sim.py` | Simular pérdida GPS bajo árboles | ✅ existe en lawnmower_simulation |
| `fake_obstacle_injector.py` | Testing collision_monitor | ✅ existe en lawnmower_simulation |

## ⚠️ Nota — odom bridge (crítico)

En hardware real:
```
ArduPilot EKF3 → MAVROS → /mavros/mavros/odom (BEST_EFFORT)
                        → odom_relay.py → /mavros_odom (RELIABLE) → robot_localization
```

En O3DE:
```
DiffDrive Component → /odom (RELIABLE)
```

Se necesita `odom_bridge_node.py` que republique `/odom` como `/mavros/mavros/odom`
con QoS BEST_EFFORT para que `odom_relay.py` lo procese igual que en hardware real.
Alternativa: configurar O3DE para publicar directamente a `/mavros/mavros/odom`.

## Infraestructura Docker

| Componente | Estado |
|---|---|
| `Dockerfile.o3de` — O3DE 25.05.1 binario + ROS2 Jazzy | ✅ listo |
| `entrypoint-o3de.sh` — lanza GameLauncher + Foxglove | ✅ listo |
| `docker-compose.yml` — servicio lm-sim-o3de | ✅ listo |
| O3DE Editor (para construir mundo/prefabs) | ⏳ instalar en Ubuntu host |
| Proyecto compilado (GameLauncher) | ⏳ compilar tras construir en Editor |

## Checklist para primera simulación funcional

- [ ] Instalar O3DE 25.05.1 en Ubuntu host (`wget o3debinaries.org/...`)
- [ ] Registrar o3de-extras ROS2 Gem + RGL Gem
- [ ] Importar URDF en O3DE Editor → crear LawnMower.prefab
- [ ] Configurar componentes del robot (DiffDrive, IMU, GNSS, LiDAR, WheelOdom)
- [ ] Construir nivel Garden (terreno, árboles, muros, spawn point)
- [ ] Configurar GeoReference Component (lat/lon datum = SITL home)
- [ ] Crear `odom_bridge_node.py` en `lawnmower_hw_bridge`
- [ ] Compilar GameLauncher (`cmake --build`)
- [ ] `docker compose up` → verificar topics con `ros2 topic list`
- [ ] Correr e2e_test.py contra O3DE

## Resolución de issues conocidos Gazebo → O3DE

| Issue Gazebo | Equivalente O3DE |
|---|---|
| `use_sim_time: true` | O3DE publica `/clock` → mismo flag |
| `GAZEBO_MODE=true` en entrypoint | `O3DE_MODE=true` (agregar al entrypoint.sh Nav2) |
| ros_gz_bridge topics | O3DE ROS2 Gem publica directo — sin bridge |
| garden.sdf | Nivel Garden construido en O3DE Editor |
