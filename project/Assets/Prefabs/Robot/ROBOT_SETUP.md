# Robot Prefab — O3DE Editor Setup

## Importar URDF

1. O3DE Editor → File → Import URDF
2. Seleccionar: `LawnMower-Sim/urdf/lawnmower_o3de.urdf.xacro`
3. Destino: `Assets/Prefabs/Robot/LawnMower.prefab`

## Componentes por entidad

### LawnMower (root entity)
| Componente | Config |
|---|---|
| `Rigid Body` | mass=33kg, linear damping=0.1 |
| `PhysX Collider` | Box 0.80×0.60×0.25m, offset z=0.125 |
| `ROS2 Frame Component` | frame_id=`base_link` |
| `ROS2 Robot Control` | topic=`cmd_vel`, type=Twist |

### left_wheel / right_wheel
| Componente | Config |
|---|---|
| `PhysX Hinge Joint` | axis Y, damping=0.01, max_force=50N |
| `PhysX Collider` | Cylinder r=0.125m h=0.08m |
| `Rigid Body` | mass=1.5kg |
| `Wheel Controller` | radius=0.125, separation=0.60 |

### left_caster / right_caster
| Componente | Config |
|---|---|
| `PhysX Collider` | Sphere r=0.05m |
| `PhysX Material` | friction=0.0 (caster sin fricción) |
| `Rigid Body` | mass=0.3kg |

### DiffDrive Controller (hijo de root)
| Componente | Config |
|---|---|
| `ROS2 Differential Drive` | left=`left_wheel_joint`, right=`right_wheel_joint` |
| | wheel_radius=0.125, track=0.60 |
| | topic_cmd=`cmd_vel`, topic_odom=`odom` |
| | odom_frame=`odom`, base_frame=`base_link` |
| | publish_tf=true |

### WheelOdom (encoder simulado)
| Componente | Config |
|---|---|
| `ROS2 Vehicle Model` | CPR=28 (simula NJK-5002C) |
| | topic=`/mavros/mavros/wheel_odometry/odom` |

### unilidar_lidar
| Componente | Config |
|---|---|
| `RGL LiDAR Component` | model=Custom (18 rings, 360°, 30m) |
| | topic=`/unilidar/cloud`, frame=`unilidar_lidar` |
| | frequency=5.55Hz |
| | ring_angles: -15° a +15° en 18 pasos |

### imu_link
| Componente | Config |
|---|---|
| `ROS2 IMU Sensor` | topic=`/imu/data`, rate=200Hz |
| | lin_acc_noise=0.01, ang_vel_noise=0.005 |
| | gravity=true |

### gps_link
| Componente | Config |
|---|---|
| `ROS2 GNSS Sensor` | topic=`/mavros/mavros/raw/fix` |
| | frame=`gps_link`, rate=5Hz |
| | covariance_type=3 (RTK fixed) |
| | noise_x=0.01m, noise_y=0.01m |

## Materiales de piso (Garden world)

Para simular pasto real, usar `PhysX Material`:
- Grass (dry): static=0.7, dynamic=0.5
- Grass (wet): static=0.4, dynamic=0.3
- Dirt path: static=0.5, dynamic=0.4

## Verificación topics

Después de lanzar, verificar en terminal:
```bash
ros2 topic list | grep -E "cmd_vel|odom|unilidar|imu|raw/fix"
```

Debe publicar:
- `/cmd_vel` — suscrito (Nav2 manda)
- `/odom` — publicado a 50Hz
- `/unilidar/cloud` — publicado a 5.55Hz
- `/imu/data` — publicado a 200Hz
- `/mavros/mavros/raw/fix` — publicado a 5Hz
- `/mavros/mavros/wheel_odometry/odom` — publicado a 50Hz
