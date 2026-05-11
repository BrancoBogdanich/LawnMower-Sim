# Garden Level — O3DE Editor Setup

## Dimensiones del área
- Zona cortable: 20m × 15m (área real del jardín)
- Terreno total: 30m × 25m (incluye bordes)
- Altura terreno: plano con leve ondulación (±0.05m)

## Terrain Gem config
- Heightmap: 512×512, escala 0.05m/pixel
- Vegetation: Vegetation Gem con distribución aleatoria pasto
- Ground texture: grass_dry (default), transiciones a dirt_path

## Elementos del jardín (obstáculos estáticos)
| Elemento | Pos (x,y) | Dim |
|---|---|---|
| Árbol 1 | (5, 3) | tronco r=0.15m h=3m, copa esfera r=1.5m |
| Árbol 2 | (-4, 7) | tronco r=0.20m h=4m |
| Árbol 3 | (8, -5) | tronco r=0.12m h=2.5m |
| Muro norte | (0, 12) | 20m × 0.2m × 0.8m |
| Muro sur | (0, -12) | 20m × 0.2m × 0.8m |
| Muro este | (10, 0) | 0.2m × 24m × 0.8m |
| Muro oeste | (-10, 0) | 0.2m × 24m × 0.8m |
| Maceta 1 | (3, -4) | cilindro r=0.3m h=0.5m |
| Maceta 2 | (-6, 2) | cilindro r=0.3m h=0.5m |
| Banco jardín | (7, 6) | caja 1.5m × 0.5m × 0.5m |

## Iluminación
- Directional Light: azimuth=45°, elevation=60° (sol tarde)
- Skybox: HDRi exterior
- Global IBL habilitado

## PhysX World config
- Gravity: -9.81 m/s²
- Solver: PGS, 32 iterations
- Ground plane: PhysX Static collider + Grass material

## Posición de spawn del robot
- xyz: (-8, 0, 0.125) — borde oeste del jardín
- rpy: (0, 0, 0) — mirando al este (+X)

## GPS datum (debe coincidir con Nav2/EKF datum)
- lat: -34.6037 (Buenos Aires ejemplo — cambiar al sitio real)
- lon: -58.3816
- alt: 25.0m
- Configurar en: ROS2 GNSS Sensor → Geo Reference Component

## Verificación visual del nivel
1. Render: Atom Renderer, profile mode
2. Fixed Frame en Foxglove = `map`
3. Robot visible con TF markers activos
4. LiDAR point cloud visible en RViz2 / Foxglove
