# Roguelike Dungeon – Project Plan

This plan is the single source of truth. It encodes all design decisions from your answers and breaks the project into chapters with checkboxes. Work through it piece by piece.

---

## Design decisions (locked in from your answers)

Use this section as the reference for *what* to build. Do not contradict these in code or design.

### Core game feel

- **Combat**: Real-time (not turn-based).
- **Orientation**: Landscape only. Game runs in **fullscreen**.
- **Performance**: Priority is **60 FPS**; prefer lowering visual fidelity over dropping frames.
- **Input (mobile)**: **Virtual joystick + buttons** (no tap-to-move, no swipe-only).
- **Camera (dungeon)**: **Camera follows the player** within room bounds (not fixed per room).

### Visual style & assets

- **Art style**: **Pixel art** everywhere (game + UI).
- **Tile size**: **32×32** pixels for all tiles.
- **Sprite directions**: **8 directions** (N, NE, E, SE, S, SW, W, NW); smooth feel via 8 sprite sets, no rotation-in-engine for characters.
- **Animations (player & enemies)**: All of them for v1 — **idle, walk, attack, cast, hit, death, dash** (per-character where it makes sense).
- **FX**: You will create bespoke FX (projectiles, hits, spells) per enemy/weapon where needed.
- **UI**: Pixel art, **sharp corners** (no rounded).

### Game structure & progression

- **Run length**: Target ~1 hour+ for a successful run to floor 25.
- **Meta-progression**: Roguelike — run items/perks are lost on death. **Coins earned on the run are kept** (meta). They buy: new things in hub, overall stats, new playable characters, weapon unlocks, etc. Perks in Hunter Log are **meta only** (persist across runs), paid with **rubys** (earned by killing bosses).
- **Save slots**: **Auto-save with 4 slots** (user can have up to 4 save files; semantics: e.g. slot 1 = most recent auto-save, or 4 independent runs — clarify in UX later; for now implement 4 save slots with auto-save).
- **When we save**: If the process isn’t expensive, **save every time we clear a room**; otherwise **save at the beginning of every floor**.
- **Death**: **Go back to hub**, lose **all run items**, **keep collected coins** (meta). Option once per run: **watch rewarded ad to revive at the start of the floor where they died** (or go to hub).

### Hub design

- **Layout**: **Single walkable hub map** (multi-area by walking) — one screen’s worth of space with all interactables reachable by moving the character.
- **Currencies**:
  - **Gold (coins)**: Meta. Earned in dungeon, kept on death. Used for: shop items, unlocking playable characters, etc.
  - **Gems**: Meta. Used to **revive once** (per run). Obtainable via **real money (IAP)** or **watching ads**. No other use specified for v1.
  - **Rubys**: Meta. Earned **only by killing bosses**. Spent in **Hunter Log** for perk upgrades (raw stats, weapon unlocks, overall weapon upgrades).
- **Hunter log**: In-world interactable in hub; opens a **menu** (not just tooltip). Spend **rubys** to upgrade. **3 perk trees**: (1) raw stats, (2) weapons to unlock, (3) overall weapon upgrades. Window takes **most of the screen**.
- **Playable characters**: **Unlocked by paying with coins** in hub (additional characters added over time / as you progress).
- **Best-floor display**: Shows **best floor reached** (overall or per-save); next to it a **small icon of the character** that was used when reaching that floor.

### Dungeon & rooms

- **Room size**: **Variable** — rooms are **not** bound to a fixed width/height; each room preset can define its own dimensions (in tiles or pixels).
- **Floor layout**: **Maze-like**, ideally **forming a square** (e.g. grid of rooms that fills a square shape). **Number of rooms per floor increases with floor level**.
- **Room presets**: Combat room templates; **number of enemies per room** depends on **floor level and room type** (data-driven in JSON/YAML).
- **Lucky rooms**:
  - **Max 2 lucky rooms per floor**.
  - If there was **no lucky room on the previous floor**, **current floor must have at least one** lucky room.
  - Lucky rooms are **blocked for the next 4 rooms** after encountering one (rule to implement so player can’t chain too many).
- **Waves**: **Wave-based spawning** on higher floors; **number/intensity of waves increases with floor level** (config-driven).
- **Boss cadence**: **Every 5 floors** (5, 10, 15, 20, 25). If we extend past 25 later, keep “every 5 floors” rule.
- **Backtracking**:
  - **Within a floor**: Player can **re-enter already cleared rooms** (doors stay open; no respawn unless special rule).
  - **Between floors**: **Once you take the “go up” room to the next floor, you cannot go back down** to previous floors.

### Enemies & combat

- **Archetypes**: At least **8 melee** and **8 ranged** enemy types (v1 can start with fewer; pools are data-driven so adding more needs only config + art).
- **AI**: **Simple chase and pathfinding** based on player position and **obstacle detection** (no kiting/flanking/LOS for v1).
- **Collision / friendly fire**:
  - Enemy **hitboxes must not overlap** (or use collision so they don’t stack).
  - **No friendly fire** between enemies (enemy projectiles don’t hit other enemies).
  - **Exception**: Enemies that **drop bombs on death** — that damage **affects everyone** (player + enemies).
- **Damage model**: Implement **all** of: **flat damage, crits, status effects (poison, burn, slow), armor, resistances**.
- **Bosses**: **Multi-phase fights** from the start; at least **one distinct boss per 5-floor milestone** (5 distinct bosses for floors 5, 10, 15, 20, 25).

### Items, loot & consumables

- **Inventory**: **Grid-based**. Split into **two parts**: one area for **perks/items gained during the run**, the other for **consumables**.
- **Consumables (v1)**: Support **all** categories — **health, mana/energy, temporary buffs, escape items, keys** (lucky room keys: buy in hub, max stack 3).
- **Weapon types**: **Swords, axes, bows, guns** (all in config; extendable).
- **Loot philosophy**: **Small drops of coins** during the room; **each end-of-room** gives a **better loot** (consumable, weapon upgrade, or similar).
- **Lucky room chests**: **Usually strong rewards** — e.g. +1 HP, strong gun perks, base stat improvements **for the run** (run-bound bonuses).
- **Reward choice screen**: When **opening a chest** (lucky room) or **defeating a boss**, do **not** give random loot. Instead show a **screen with 3 cards**; the player **chooses 1 of 3** items from a list (e.g. 3 options drawn from the appropriate reward pool). Same UX for both chest and boss.

### Technical & architecture

- **Save data**: **Local first**; later **online leaderboard** with **server-side or double-check** to prevent cheating.
- **Platforms**: **Android & iOS only** (no desktop/web for v1). Target **most popular** min SDK/API so it runs on most devices (e.g. Android API 21+, iOS 12+ — adjust as needed).
- **Audio**: **Background music** (hub + dungeon), **gun sounds**, **sound when getting hit**. No dynamic music requirement for v1.
- **Monetization**: **Free game**. On death: **once per run**, player chooses — **rewarded ad** to return at **start of the floor where they died**, or **go to hub**. Other ads **optional only**, always a **trade for a reward** (never forced).
- **Configuration**: **All content and tuning in JSON/YAML** (enemies, rooms, floors, loot tables, perks, weapons) — no hardcoding of design data in code.

### UX & accessibility

- **Colorblind / accessibility**: Not required for v1.
- **Haptics**: **Small vibrations** on: **getting hit**, **finishing a room (doors open)**, **boss attacks**.
- **Tutorial**: **No in-game tutorial**. Provide a **manual** for hints and tips.

### Future-proofing

- **Content extension**: Adding new **rooms** or **enemies** = add **config + art**; game picks from **pools like “legos”** — no code change required for new entries.
- **User-generated content**: **Desired later** — e.g. level editor (Super Mario Maker style), publish level if you can finish it. **Not for launch**; keep architecture in mind so we can add it to the plan later.

---

## Chapter 0 – Foundations & environment

- [x] Initialize Git repository (already done)
- [ ] Confirm Flutter & Dart versions; set supported Android/iOS min versions (e.g. Android API 21+, iOS 12+)
- [x] Lock landscape + fullscreen in app (Android & iOS)
- [x] Design questions answered in `OPEN_QUESTIONS.md`; decisions reflected above
- [x] Set up CI or script: at least `flutter analyze` + `flutter test` (tool/setup.sh)

---

## Chapter 1 – Project scaffolding & architecture

- [x] Ensure Flutter project has Flame integrated (`pubspec.yaml`)
- [x] Create base `FlameGame` subclass as game root; attach via `GameWidget` in Flutter
- [x] Define folder structure: `lib/app/`, `lib/game/`, `lib/game/entities/`, `lib/game/rooms/`, `lib/game/systems/`, `lib/data/`, `lib/services/`, `lib/ui/`
- [x] Introduce data-driven config: load at least one sample from **JSON or YAML** (e.g. enemy or room definition); establish paths like `assets/data/`
- [x] Add a simple service locator or DI (e.g. for save service, config loader) so scenes can access shared services

---

## Chapter 2 – Main menu & navigation shell

- [x] Implement **main menu** screen with buttons: **New Game**, **Continue**, **Settings**
- [x] Layout: menu panel occupies **~30–40% of the screen** (landscape); **fullscreen** game; use **placeholder background image** (you will replace with your art)
- [x] **New Game** → navigate to **hub** scene (default player, hub state)
- [ ] **Continue** → load from one of **4 save slots** (e.g. most recent or slot picker); stub save data if needed
- [x] **Settings** screen: stubs for **audio** (music/SFX toggles), **controls** (future: joystick size/position), **graphics** (e.g. quality, damage numbers)
- [x] Ensure app starts in **landscape** and stays **fullscreen** on Android & iOS

---

## Chapter 3 – Hub world

- [x] Implement **top-down player** in hub: movement only (no combat in hub); use **virtual joystick** for movement (same control scheme as dungeon for consistency)
- [x] Create **hub tilemap** (32×32) with **collision layer**; load from asset or from JSON map data
- [x] Add **interactable objects** with collision or trigger zones:
  - **Shop** (buy items, keys; spend gold)
  - **Hunter log** (opens Hunter Log menu; spend rubys)
  - **Character gallery** (view/unlock playable characters; unlock with **coins**)
  - **Best-floor display** (show best floor reached + **character icon** that achieved it)
  - **Dungeon door** (enter dungeon; trigger transition animation + zoom)
- [x] Interaction: show **prompt** when player is near (e.g. “Press to interact”); open appropriate UI or transition
- [x] Hub camera: simple follow or fixed so the whole hub is playable; no dungeon logic here

---

## Chapter 4 – Dungeon room system & map overlay

- [x] **Room data model**: each room has **type** (exit doors: top/bottom/left/right), **dimensions** (variable width/height), **difficulty tier**, **floor range**, **tags** (e.g. combat, lucky, boss, stair_up); all from **JSON/YAML**
- [x] **Room presets**: loader reads room definitions from config; each preset can specify tilemap or template ID and dimensions
- [x] **Floor generator**: per floor, build a **maze-like graph** that **forms a square** (or near-square); **number of rooms increases with floor level**; place **one “stair up” room**; **lucky room rules**: max 2 per floor, at least 1 if previous floor had none; **boss room** every 5 floors
- [x] **Next room by exit**: when player exits through a door (top/bottom/left/right), **next room is chosen at random** from presets that have a matching entrance; connectivity and pool defined in config
- [x] **Entering dungeon from hub**: play **short animation + zoom** when passing through dungeon door
- [x] **Map overlay**: **icon in top-right** (placeholder image; you provide asset later); tap toggles **overlay** that shows **current floor map** with **walls in white** only; tap again to hide; **overlay must not capture input** for movement/combat (input-transparent for game controls)
- [x] **Backtracking**: within floor, allow re-entering cleared rooms; when player enters “stair up”, load next floor and **disable going back** to previous floor

---

## Chapter 5 – Player combat & controls (dungeon)

- [x] **Player stats model**: HP, damage, speed, armor, resistances, crit, etc.; support **status effects** (poison, burn, slow) and **flat damage**
- [x] **Input**: **virtual joystick** (move) + **buttons** (attack, dash, use consumable, interact); same as hub plus combat actions
- [ ] **Weapons**: support **melee (sword, axe)** and **ranged (bow, gun)**; switch/equip from inventory or weapon wheel; base stats and modifiers from config
- [x] **Attacks**: hit detection (AABB or hitbox); apply damage with **crits**, **armor**, **resistances**; trigger **hit** and **death** animations
- [x] **Health UI**: show current HP; damage feedback (flash, numbers, or both)
- [x] **Camera**: **camera follows player** within current room bounds (smooth or clamped)

---

## Chapter 6 – Enemies & pathfinding

- [x] **Enemy config**: each archetype in **JSON/YAML** — type (melee/ranged), stats, sprite/animation keys, **floor range**, behavior flags; **pools per floor** so adding new enemies is config-only
- [x] **Spawning**: when player **enters a room**, spawn enemies; number and types from **floor level + room type** (waves in Ch7)
- [x] **Movement**: chase toward player with **wall collision** (obstacle detection); enemies don’t pass through walls
- [x] **Ranged enemies**: shoot projectiles toward player; **no friendly fire** (projectiles don’t hit other enemies)
- [x] **Bomb-on-death**: for archetypes that have it, on death spawn **damage zone** that **affects everyone** (player + enemies)
- [x] **Death & drops**: on death cleanup and remove from room (loot table in Ch11)

---

## Chapter 7 – Floors, difficulty & waves

- [x] **Floor progression**: floors **1–25**; difficulty (enemy HP/damage scale, wave count) **increases with floor**; all driven by **game_config.json**
- [x] **Rooms per floor**: **increasing count per floor** from config (`roomCountBase`, `roomCountPer5Floors`, `roomCountMax`)
- [x] **Wave-based rooms**: combat rooms have **multiple waves**; wave count from config per floor; when all enemies dead, next wave spawns until wave count reached
- [x] **Stair-up room**: one room per floor leads to next floor; entering it **locks** previous floor (no return)
- [x] **Per-floor enemy and room pools**: generator uses **room presets** (floorMin/floorMax) and **archetypesForFloor**; config has HP/damage scale per floor

---

## Chapter 8 – Lucky rooms, chests & keys

- [ ] **Lucky room type**: mark rooms as “lucky” in generator; enforce **max 2 per floor** and **at least 1 if previous had none**; apply **block for next 4 rooms** after encountering a lucky room (rule as you specified)
- [ ] **Chest**: interactable chest in lucky room; requires **key** to open
- [ ] **Keys**: **lucky room key** — buy in **hub shop**; **max stack 3**; consume one on open
- [ ] **Chest rewards**: open a **reward choice screen** with **3 cards**; player **picks 1 of 3** from the chest reward pool (strong run-bound: +1 HP, weapon perks, etc.); pool in **JSON/YAML**, extendable
- [ ] Ensure chest content and key type are config-driven so new rewards don’t need code changes

---

## Chapter 9 – Bosses

- [ ] **Boss rooms**: generated **every 5 floors** (5, 10, 15, 20, 25); one boss room per such floor
- [ ] **Boss archetypes**: at least **one distinct boss per milestone** (5 total for v1); each with **multi-phase** behavior (phases defined in config or code pattern)
- [ ] **Arena**: boss room locks player in (arena lock-in); optional intro sequence
- [ ] **Rewards**: on kill grant **rubys** (for Hunter Log); then show **reward choice screen** with **3 cards**; player **picks 1 of 3** from the boss reward pool (run-bound items); update best-floor and save
- [ ] **Boss list extendable**: new bosses added via config + art + behavior hook

---

## Chapter 10 – Hunter log & perk system

- [ ] **Hunter log UI**: opened from hub interactable; **full-screen (or nearly)** window; pixel art, sharp corners
- [ ] **Currency**: spend **rubys** (earned from bosses) only in this menu
- [ ] **Three perk trees** (data-driven):
  - **Tree 1**: Raw stats (HP, damage, movement, crit, defenses, etc.)
  - **Tree 2**: Weapon unlocks (unlock new weapons for runs)
  - **Tree 3**: Overall weapon upgrades (e.g. global gun damage, reload speed)
- [ ] Perks persist **across runs** (meta); apply when starting a run or when entering dungeon
- [ ] All perks and costs in **JSON/YAML**; no hardcoded trees

---

## Chapter 11 – Items, weapons & consumables (full)

- [ ] **Inventory UI**: **grid-based**; **two regions** — run perks/items and **consumables**; show weapon slots (equipped melee/ranged)
- [ ] **Consumables**: **health**, **mana/energy**, **temporary buffs**, **escape items**, **keys** (lucky room keys, max 3); use from button or quick slot
- [ ] **Weapon system**: **swords, axes, bows, guns**; base stats and modifiers from config; swap/equip; support **crits**, **armor**, **resistances**, **status effects** in damage calc
- [ ] **Loot**: **small coin drops** during room; **end-of-room reward** — one better drop (consumable or weapon upgrade) from configurable table
- [ ] **Run vs meta**: run items/perks lost on death; **coins kept**; keys and consumables are run-bound

---

## Chapter 12 – Save system & persistence

- [ ] **Save schema**: versioned; includes: **slot id**, **meta currencies** (gold, gems, rubys), **unlocked characters**, **Hunter Log perk state**, **best floor + character icon**, **current run state** (floor, room, HP, inventory, etc.), **settings**
- [ ] **4 save slots**: auto-save into one or multiple slots (define UX: e.g. “last 4 runs” or “slot 1 = main”); **Continue** loads from chosen slot
- [ ] **When to save**: **on room clear** (if cheap) or **at start of each floor**; also on **return to hub**, **death**, **quit**
- [ ] **Local storage**: persist to device (e.g. JSON files or shared_preferences); path and format documented
- [ ] **Migration**: schema version in save file; support reading older versions and upgrading (for future changes)
- [ ] **Online leaderboard**: stub or placeholder for “submit score / best floor” and **validation** to prevent cheating; full implementation can be Chapter 14 or post-launch

---

## Chapter 13 – Polish, effects & performance

- [ ] **Audio**: **background music** (hub + dungeon); **gun sounds**, **hit sounds**; volume toggles in Settings
- [ ] **VFX**: hit flashes, projectiles, dash trail, death effects; you provide assets; we hook them to events
- [ ] **Haptics**: **light vibration** on **player hit**, **room clear (doors open)**, **boss attacks**
- [ ] **Settings**: apply **sound on/off**, **graphics quality**, **damage numbers**, **camera shake** (if any) from saved settings
- [ ] **Performance**: profile on target devices; **60 FPS** target; avoid allocations in `update`; optimize hot paths
- [ ] **Revived-by-ad flow**: on death, **once per run**, offer choice — **rewarded ad** to **restart at start of current floor** (keep run state) or **go to hub**; if ad not available or skipped, go to hub; gems (revive) can be separate or same UX — align with your monetization

---

## Chapter 14 – Release & extras

- [ ] **App icon & splash**: final assets for Android & iOS
- [ ] **Store metadata**: listing, screenshots, description
- [ ] **Build**: signed **Android** and **iOS** release builds; min SDK/API per “most popular” targets
- [ ] **Manual**: in-app or external **manual** for hints and tips (no tutorial)
- [ ] **Analytics/logger**: optional hooks for crashes and key events (e.g. floor reached, death)
- [ ] **Tag v1.0.0** and prepare store submission

---

## Optional / future (in plan, not for v1 launch)

- **Online leaderboard**: submit best floor (and maybe rubys/coins for validation); server-side checks to reduce cheating.
- **User-generated content**: level editor, publish level if creator can finish it; architecture should not block this later.
- **More ads**: optional rewarded ads elsewhere (e.g. extra coins, extra chest) always as **optional trade for reward**, never forced.

---

*When implementing, always refer to the “Design decisions” section at the top so every feature matches your answers. Check off tasks in this file as you complete them.*
