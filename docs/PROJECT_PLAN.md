## Roguelike Dungeon – Project Plan

This plan is organized into chapters with small, trackable tasks. We will check these boxes as we progress.

### Chapter 0 – Foundations & Environment

- [x] Initialize Git repository (already done)
- [ ] Confirm Flutter & Dart versions, and supported Android/iOS targets
- [ ] Decide target orientation (portrait vs landscape) and base resolution
- [ ] Answer all key design questions in `OPEN_QUESTIONS.md`
- [ ] Set up continuous integration (at least `flutter analyze` + tests)

### Chapter 1 – Project Scaffolding & Architecture

- [ ] Create Flutter project with Flame integrated
- [ ] Set up base `FlameGame` subclass and game root widget
- [ ] Define project folder structure (`core`, `game`, `ui`, `data`, etc.)
- [ ] Introduce data‑driven configuration approach (e.g. JSON for rooms/enemies)
- [ ] Implement basic dependency injection / service locator (for saves, config, etc.)

### Chapter 2 – Main Menu & Navigation Shell

- [ ] Implement main menu screen with **New Game**, **Continue**, **Settings**
- [ ] Layout menu to occupy ~30–40% of the screen
- [ ] Use placeholder background image asset (to be replaced by your art)
- [ ] Wire up navigation into hub scene (for New Game)
- [ ] Stub out save/load flow for **Continue** (no real data yet)
- [ ] Stub out **Settings** screen (audio, controls, graphics toggles)

### Chapter 3 – Hub World (Map Before the Dungeon)

- [ ] Implement top‑down player controller in hub (movement only)
- [ ] Create hub tilemap and collision layer
- [ ] Add interactable objects: shop, hunter log, character gallery, best‑floor display, dungeon door
- [ ] Implement interaction prompts and minimal dialogue UI
- [ ] Implement simple hub camera behavior

### Chapter 4 – Dungeon Room System & Map Overlay

- [ ] Define room data model (type: top/bottom/left/right, difficulty tier, floor range, tags)
- [ ] Implement room presets and loader (from code or config files)
- [ ] Implement room graph generator per floor (sequence of rooms + exit connectivity)
- [ ] Implement transition animation + zoom when entering dungeon from hub
- [ ] Implement in‑game map icon in top‑right with overlay map view (walls in white)
- [ ] Ensure map overlay is input‑transparent to game controls

### Chapter 5 – Player Core Combat & Controls

- [ ] Implement player stats model (HP, damage, speed, etc.)
- [ ] Implement input scheme for mobile (virtual joystick / buttons based on your answers)
- [ ] Implement basic melee attack and/or ranged attack
- [ ] Implement hit detection & damage application
- [ ] Implement basic health UI and damage feedback

### Chapter 6 – Enemies & Pathfinding

- [ ] Design enemy archetype config structure (pools per floor range, melee/ranged flags, behaviors)
- [ ] Implement enemy spawning logic for a room (first 5 seconds of entry)
- [ ] Implement simple pathfinding / steering towards player (per archetype)
- [ ] Implement ranged enemy projectile behavior
- [ ] Implement death, drops hook, and cleanup for enemies
- [ ] Ensure enemy pools are extendable via config only (no code changes needed)

### Chapter 7 – Floors, Difficulty & Waves

- [ ] Implement floor progression model (1–25 with increasing difficulty)
- [ ] Define number of rooms per floor and scaling rules
- [ ] Implement rules for wave‑based rooms on higher floors
- [ ] Implement “room to go up” and ensure no backtracking once floor is advanced
- [ ] Implement per‑floor enemy pool and room selection

### Chapter 8 – Lucky Rooms, Chests & Keys

- [ ] Implement lucky room type and encounter rules (including 4‑room block)
- [ ] Implement chest entity and interaction
- [ ] Implement key item with max stack of 3 (purchased in hub shop)
- [ ] Implement reward table for chests (boosts, weapons, etc.; initial simple version)
- [ ] Ensure future chest rewards can be extended via config

### Chapter 9 – Bosses & Milestones

- [ ] Implement boss room generation every 5 floors (5, 10, 15, 20, 25)
- [ ] Implement at least one boss archetype with basic mechanics
- [ ] Implement boss intro sequence and arena lock‑in behavior
- [ ] Implement unique rewards/progression for defeating bosses
- [ ] Ensure boss list and mechanics can be extended later

### Chapter 10 – Hunter Log & Perk System

- [ ] Implement hunter log UI window (occupying most of the screen)
- [ ] Implement perk trees / categories model
- [ ] Implement spending currency to upgrade perks (meta‑progress and/or run‑bound)
- [ ] Integrate perks with player stats, loot, and floor progression
- [ ] Add data‑driven config for perks to allow future extension

### Chapter 11 – Items, Weapons & Consumables

- [ ] Implement inventory model and UI for run items
- [ ] Implement consumables (health, buffs, etc.) with cooldown/usage rules
- [ ] Implement weapon system (base stats + modifiers) and swapping
- [ ] Implement loot drop tables per floor / room type
- [ ] Ensure adding new items/weapons is config‑only where possible

### Chapter 12 – Save System & Persistence

- [ ] Define save data schema (runs, meta‑progress, settings)
- [ ] Implement local storage backend
- [ ] Implement **New Game**, **Continue**, and hub persistence behavior
- [ ] Implement auto‑save on key events (room clear, floor change, hub return)
- [ ] Add migration/versioning strategy for future schema changes

### Chapter 13 – Polish, Effects & Performance

- [ ] Add audio: music per area and core SFX
- [ ] Add basic VFX (hits, dashes, projectiles, environment)
- [ ] Implement settings toggles (sound, graphics, damage numbers, camera shake, etc.)
- [ ] Profile and optimize for target devices (GC pressure, allocations per frame)
- [ ] Fix remaining UX issues and small bugs

### Chapter 14 – Release Prep & Extras

- [ ] Prepare app icons, splash screens, and store metadata
- [ ] Finalize build flavors and signing for Android/iOS
- [ ] Add basic analytics/logging hooks (if desired)
- [ ] Write minimal in‑game help or tutorial
- [ ] Tag v1.0.0 and prepare release builds

