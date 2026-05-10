# Setup — O3DE 25.05 + ROS2 Jazzy

## Requisitos

| Componente | Mínimo | Recomendado |
|---|---|---|
| GPU | GTX 1060 (Vulkan 1.2) | GTX 1660+ (CUDA para RGL) |
| VRAM | 4 GB | 6 GB |
| RAM | 16 GB | 32 GB |
| Disco | 60 GB libres | 100 GB (SSD) |
| OS | Ubuntu 24.04 / Windows 11 + WSL2 + Docker | — |

## Instalación O3DE 25.05

### Opción A — Pre-compiled installer (recomendado)
```bash
# Ubuntu 24.04
wget https://o3de.org/releases/25.05/o3de-25.05-linux.deb
sudo apt install ./o3de-25.05-linux.deb
```

### Opción B — Desde código fuente
```bash
git clone --depth 1 --branch 25.05.0 https://github.com/o3de/o3de.git /opt/o3de
git clone --depth 1 --branch 25.05.0 https://github.com/o3de/o3de-extras.git /opt/o3de-extras
/opt/o3de/scripts/o3de.sh register --this-engine
```

## Gems requeridos

```bash
# ROS2 Gem (topics nativos sin bridge)
/opt/o3de/scripts/o3de.sh register --gem-path /opt/o3de-extras/Gems/ROS2

# RGL Gem — LiDAR GPU CUDA (requiere GTX 1660 con CUDA)
git clone https://github.com/RobotecAI/o3de-rgl-gem.git /opt/o3de-rgl-gem
/opt/o3de/scripts/o3de.sh register --gem-path /opt/o3de-rgl-gem
```

## Compilar el proyecto

```bash
cd /lawnmower_sim
cmake -B build/linux -S . -G "Ninja Multi-Config" \
    -DLY_DISABLE_TEST_MODULES=ON \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build build/linux --config profile --target LawnMowerSim.GameLauncher -j$(nproc)
```

## Correr en Docker

```bash
# Headless (sin render — CI/testing)
docker compose up -d

# Con GPU para LiDAR CUDA
O3DE_RENDER_MODE=gpu docker compose up -d
```

## Referencias

- [O3DE Download](https://o3de.org/download/)
- [O3DE ROS2 Gem](https://docs.o3de.org/docs/user-guide/gems/reference/robotics/ros2/)
- [ROSConDemo (base)](https://github.com/o3de/ROSConDemo)
- [RGL Gem (LiDAR GPU)](https://github.com/RobotecAI/o3de-rgl-gem)
