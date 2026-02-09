# Placeholder visuals for testing

The game is fully playable **without sprites or art**. Every character and object uses a **basic shape** (square or rectangle) so you can test all mechanics before adding visuals.

When you add sprites later, replace the `render()` implementation in each component (or switch to sprite-based components) and remove/update this doc.

---

## Dungeon

| What            | Shape   | Color        | Notes                          |
|-----------------|---------|-------------|---------------------------------|
| **Player**      | Square  | Green       | Center of room, moves with joystick |
| **Melee enemy** | Square  | Dark red    | Chases and hits in range        |
| **Ranged enemy**| Square  | Light red   | Keeps distance, shoots orange projectiles |
| **Enemy projectile** | Square | Orange  | Hurts player only (no friendly fire) |
| **Room floor**  | Rect tiles | Dark blue-grey | Per tile |
| **Walls**       | Rect tiles | Grey (from WallComponent) | Collision |
| **Chest** (lucky room) | Square | Brown (closed) / dark brown (opened) | Interact with key for 3-card reward |

Bomb-on-death: no visible indicator yet; damage is applied in a radius when the enemy dies.

---

## Hub

| What            | Shape / source      | Notes                          |
|-----------------|---------------------|---------------------------------|
| **Player**      | Green square        | Same as dungeon                |
| **Hub map**     | Tilemap from JSON  | Floor vs wall tiles (rects)    |
| **Interactables** | Invisible zones   | “Press to interact” when near  |

---

## UI

- **Virtual joystick**: circles (base + stick) — keep or replace with your asset.
- **Dungeon overlay**: Attack/Dash = rectangular buttons; HP bar = progress bar; map = white rects for walls, highlight for current room.
- **Main menu**: Flutter widgets (panels, buttons) — replace with pixel-art panels when ready.

---

## Replacing with sprites

1. Load sprite sheets / images in your asset loader.
2. In each component (`PlayerComponent`, `EnemyComponent`, `EnemyProjectileComponent`, etc.):
   - Replace the `render(Canvas canvas)` body with a `SpriteComponent` (or draw a `Sprite` in `render`), or remove the custom `render` and add a sprite child component.
3. Use the same size and anchor so hitboxes and movement stay correct.
4. Animation: swap sprites by animation state (idle, walk, attack, etc.) using your 8-direction and animation key data from config.

No code changes are required for game logic when switching from shapes to sprites; only the drawing in each component (or the component type) changes.
