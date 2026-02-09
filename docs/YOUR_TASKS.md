## What You Need To Do

This is your personal checklist based on the design answers and plan so far.

### 1. Visual & Art Tasks

- [ ] **Main menu background**
  - Create a landscape pixel‑art background image for the title/menu screen.
  - Leave space where a 30–40% width menu panel can sit without hiding important details.

- [ ] **Hub tileset**
  - Create a 32×32 pixel‑art tilesheet for the hub (ground, walls, decorations, interactables).
  - Include distinct visuals for: shop area, hunter log area, character gallery area, best‑floor display, dungeon door.

- [ ] **Dungeon tilesets**
  - Create at least one 32×32 tilesheet for the first dungeon floor (ground, walls, basic props).
  - Optional: start a second set for higher floors with slightly different color/theme.

- [ ] **Player sprite sheets**
  - One default player character with 8 directions (N, NE, E, SE, S, SW, W, NW).
  - Animations (each with enough frames to feel smooth):
    - Idle
    - Walk
    - Attack (for weapons)
    - Cast (if visually distinct from attack)
    - Hit (flinch)
    - Death
    - Dash
  - Keep frames aligned on a 32×32 grid; we’ll configure exact layout in JSON once you settle on a pattern (single big sheet vs one sheet per animation).

- [ ] **Enemy sprite sheets (initial set)**
  - For v1 prototype: at least **1 melee** and **1 ranged** enemy with:
    - 8 directions.
    - Idle, walk, attack, hit, death animations.
  - Reuse or recolor these to later expand towards your goal of 8 melee + 8 ranged.

- [ ] **FX and projectiles**
  - Projectile sprites (bullets, arrows, basic magic bolts), 16×16 or 32×32, with 2–4 frame loops.
  - Generic hit/impact animation (6–8 frames).
  - Simple AoE / bomb indicator and explosion (e.g. circle or rune effect).

- [ ] **UI assets**
  - Pixel‑art, sharp‑cornered panels and buttons for:
    - Main menu panel.
    - Settings, Continue, New Game buttons.
    - Hunter log big window (almost full‑screen panel).
  - Icons for:
    - Currencies: gold, gems, rubys.
    - Weapons and consumables (32×32 or 48×48).
    - Dungeon map button (small icon for top‑right corner).
  - HUD elements (HP bar, ammo/consumable slots, perk/inventory icons).

### 2. Audio Tasks

- [ ] **Music**
  - Background track for hub.
  - Background track for early dungeon floors (can reuse or loop).

- [ ] **Sound effects**
  - Player weapon sounds (at least one for melee, one for ranged).
  - Enemy hit/death sound.
  - UI sounds (button click, menu open/close, hunter log open).
  - Room clear / doors opening sound.

### 3. Design & Balancing Tasks

- [ ] **Enemy and weapon concepts**
  - Write a short description for at least:
    - 3–4 melee enemy archetypes.
    - 3–4 ranged enemy archetypes.
    - 3–4 weapon archetypes (sword, axe, bow, gun variants).
  - For each, define rough stats: HP, damage, speed, special behavior (bomb on death, etc.).

- [ ] **Room & floor feel**
  - Decide approximate **min/max number of rooms** per floor band (e.g. floors 1–5, 6–15, 16–25).
  - Decide how “dense” enemy waves should feel per band (few strong enemies vs many weak ones).

- [ ] **Lucky rooms & rewards**
  - List example rewards you want from lucky room chests:
    - Strong run‑only perks (HP +1, strong gun perks, movement speed, damage).
    - Rare weapons or weapon upgrades.

- [ ] **Hunter log perk trees**
  - Draft the 3 branches:
    - Raw stats (HP, damage, movement, crit, defenses).
    - Weapon unlocks.
    - Overall weapon upgrades (e.g. global gun damage, reload speed).
  - For each branch, list at least 5–10 perks with rough costs in rubys.

### 4. Monetization & Meta Decisions

- [ ] **Rewarded ad flow**
  - Finalize the exact UX for “revive once per run” via rewarded ad:
    - What happens if the ad fails or is skipped?
    - Any other places where optional rewarded ads appear (extra coins, extra chest, etc.)?

- [ ] **Gem usage**
  - Define what gems can buy besides revive (if anything), and how often players earn free gems vs IAP.

### 5. Future Content & Modding (Optional Prep)

- [ ] **Long‑term content ideas**
  - Keep a running list of:
    - Future floor themes.
    - Future enemies, bosses, and weapons.
    - Ideas for user‑generated content / level editor (even if post‑launch).

- [ ] **JSON/YAML comfort**
  - Once we have the first enemy/room/loot JSON configs in place, skim them so you’re comfortable editing values yourself for iteration.

---

As you work through this list, you don’t need to do everything at once. For the **first playable prototype**, prioritize:

- One hub tileset, one dungeon tileset.  
- Main menu background and basic UI panels.  
- Player sprites (idle/walk/attack/hit/death) in 8 directions.  
- One melee + one ranged enemy with simple animations.  

Once those exist, I’ll wire them in and we’ll iterate on rooms, floors, and meta systems using JSON/YAML configs.

