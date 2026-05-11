#!/bin/bash
set -e

source /opt/ros/jazzy/setup.bash

if [ "${O3DE_RENDER_MODE}" = "headless" ]; then
    RENDER_ARGS="-NullRenderer -rhi=null"
else
    RENDER_ARGS=""
fi

echo "[O3DE] Iniciando simulación LawnMower..."
echo "[O3DE] Render mode: ${O3DE_RENDER_MODE:-headless}"
echo "[O3DE] RMW: ${RMW_IMPLEMENTATION}"

# Foxglove bridge
ros2 run foxglove_bridge foxglove_bridge \
    --ros-args \
    -p port:=8765 \
    -p address:=0.0.0.0 \
    -p send_buffer_limit:=10000000 \
    -p 'best_effort_qos_topic_whitelist:=[".*"]' &

# O3DE GameLauncher — nivel Garden
/lawnmower_sim/build/linux/bin/profile/LawnMowerSim.GameLauncher \
    ${RENDER_ARGS} \
    -bg_ConnectToAssetProcessor 0 \
    +LoadLevel Garden

wait
