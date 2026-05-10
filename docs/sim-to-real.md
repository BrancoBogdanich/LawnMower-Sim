# Sim-to-Real — Guía de validación

## Filosofía

La simulación en O3DE debe ser fiel al hardware real **al nivel de topics ROS2**.
El stack Nav2 (LawnMower-Nav2) no sabe ni le importa si los datos vienen de O3DE
o del hardware físico — los topics son idénticos.

## Fases de validación (estándar industria)

### Fase 1 — Cinemática base
- [ ] Robot se mueve en O3DE al recibir `/cmd_vel`
- [ ] `/odom` refleja el movimiento correctamente
- [ ] TF `odom→base_link` es consistente
- [ ] Velocidad lineal max: 1.0 m/s · angular max: 1.2 rad/s
- [ ] Separación ruedas: 0.6m · radio: 0.125m

### Fase 2 — Sensores sintéticos
- [ ] `/unilidar/cloud` publica a 5.55Hz, 18 rings, 360°
- [ ] `/mavros/mavros/raw/fix` publica NavSatFix con covariance RTK
- [ ] `/imu/data` publica a 200Hz con ruido gaussiano realista
- [ ] `/mavros/mavros/wheel_odometry/odom` publica odometría con cuantización CPR=28

### Fase 3 — Nav2 navegando
- [ ] dual-EKF inicializa correctamente con datos O3DE
- [ ] Nav2 navega de A a B en el jardín O3DE
- [ ] collision_monitor detecta obstáculos del LiDAR sintético
- [ ] coverage_mission_node completa franjas boustrophedon
- [ ] E2E test (adaptado de e2e_test.py) pasa 10/10

### Fase 4 — Domain randomization (robustez sim-to-real)
- [ ] GPS degradation sim activo (RTK/float/lost)
- [ ] Variación de fricción suelo (pasto seco vs húmedo)
- [ ] Variación de masa del robot (±10%)
- [ ] Robot navega correctamente en todos los escenarios

## Métricas de fidelidad (ISO 9283 adaptado)

| Métrica | Objetivo | Cómo medir |
|---|---|---|
| Error posición nav. | < 0.5m RMSE | comparar /odom vs ground truth O3DE |
| Cobertura área | > 95% del polígono | e2e_test criterio area_coverage |
| Detección obstáculos | 100% a < 1.5m | fake_obstacle_injector |
| Latencia cmd_vel→mov. | < 100ms | timestamp O3DE vs /odom |

## Diferencias conocidas sim vs real

| | O3DE sim | Hardware real |
|---|---|---|
| Fricción suelo | Uniforme (configurable) | Variable (pasto, tierra, barro) |
| GPS ruido | Gaussiano controlado | Multipath, satélites, clima |
| LiDAR retornos | Ideales (sin FW bugs) | Bug #25 timestamp 50% |
| Encoders | Cuantización CPR=28 | También vibración mecánica |
| IMU | Gaussiano puro | Drift térmico, vibración motor |

## Flujo de desarrollo recomendado

```
1. Implementar feature en O3DE sim
2. Validar con e2e_test.py (criterios Pass/Fail)
3. Si pasa → merge a LawnMower-Nav2 main
4. Deploy a Jetson real
5. Medir gap sim-to-real
6. Ajustar parámetros de ruido en O3DE para reducir gap
```
