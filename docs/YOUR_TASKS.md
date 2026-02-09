# What You Need To Do

Your personal checklist, grouped by **phase/priority**. For each phase, the list under “You need” is what to have ready so we can ship that phase.

---

## Phase 1 – First playable prototype

**Goal:** Hub → enter dungeon → move through rooms → basic combat (attack/dash) → one enemy type → room clear feel.

### You need (priority order)

1. **One hub tileset** (32×32)
   - Ground, walls, distinct areas for: shop, hunter log, character gallery, best floor, dungeon door.

2. **One dungeon tileset** (32×32)
   - Ground, walls, basic props for first floor.

3. **Main menu background**
   - Landscape pixel-art; leave 30–40% width clear for the menu panel.

4. **Basic UI panels (pixel-art, sharp corners)**
   - Main menu panel, Settings / Continue / New Game buttons.

5. **Player sprite sheets**
   - One default character, 8 directions.
   - Animations: Idle, Walk, Attack, Hit, Death, Dash (Cast if distinct).
   - 32×32 grid; layout can be defined in JSON later.

6. **One melee + one ranged enemy (v1)**
   - 8 directions; Idle, walk, attack, hit, death.
   - Enough to test combat and room clear.

7. **Minimal FX**
   - One generic hit/impact animation (6–8 frames).
   - Optional: one projectile sprite for ranged enemy.

8. **Design: enemy & weapon concepts (minimal)**
   - Short description + rough stats for the 1 melee and 1 ranged enemy.
   - One or two weapon archetypes (e.g. sword, gun) for tuning.

Once these exist, we can wire them in and you have a playable prototype.

---

## Phase 2 – Combat & enemies

**Goal:** More enemy types, full damage model (crit, armor, status), waves, room/floor feel.

### You need

1. **Enemy sprite set (expand)**
   - Toward 8 melee + 8 ranged: more sprites (or recolor/variant of existing).
   - Same animation set: idle, walk, attack, hit, death.

2. **FX and projectiles**
   - Projectile sprites (bullets, arrows, bolts), 16×16 or 32×32, 2–4 frame loops.
   - AoE / bomb indicator and explosion (e.g. circle or rune) for bomb-on-death etc.

3. **Design: enemy and weapon concepts (full)**
   - 3–4 melee archetypes, 3–4 ranged archetypes, 3–4 weapon archetypes.
   - For each: HP, damage, speed, special behavior (e.g. bomb on death).

4. **Design: room & floor feel**
   - Min/max rooms per floor band (e.g. 1–5, 6–15, 16–25).
   - Enemy density per band (few strong vs many weak).

5. **Design: lucky rooms & rewards**
   - Example rewards: run-only perks (HP, gun perks, speed, damage), rare weapons/upgrades.

6. **Sound effects (combat)**
   - Player melee and ranged weapon sounds.
   - Enemy hit/death, room clear / doors opening.

---

## Phase 3 – Progression & meta

**Goal:** Loot, perks, Hunter Log, shop, characters, currencies, save slots.

### You need

1. **Hunter log perk trees (design)**
   - 3 branches: raw stats, weapon unlocks, overall weapon upgrades.
   - 5–10 perks per branch with rough costs in rubys.

2. **UI assets**
   - Hunter log big window (almost full-screen), pixel-art, sharp corners.
   - Icons: gold, gems, rubys; weapons/consumables (32×32 or 48×48).
   - HUD: HP bar (asset), ammo/consumable slots, perk/inventory icons.

3. **Design: loot pools**
   - What can drop from rooms, chests, bosses (we’ll implement 3-card choice screen).

4. **Music (optional for phase)**
   - Hub background track; optional dungeon track.

5. **UI sounds**
   - Button click, menu open/close, hunter log open.

---

## Phase 4 – Polish & release

**Goal:** Full art pass, audio, monetization, store readiness.

### You need

1. **Monetization & meta decisions**
   - Rewarded ad flow: “revive once per run” — what if ad fails/skips? Any other rewarded ad placements?
   - Gem usage: what gems buy besides revive; free gems vs IAP cadence.

2. **Art polish**
   - Optional second dungeon tileset (e.g. higher floors).
   - Any missing character/enemy/UI assets and animation polish.

3. **Music & SFX**
   - Finalize hub and dungeon music; any missing SFX.

4. **Store assets**
   - Icons, screenshots, descriptions as required by store (we can add exact specs later).

---

## Optional / ongoing

- **Long‑term content ideas:** Future floor themes, enemies, bosses, weapons; user content / level editor.
- **JSON/YAML:** Once enemy/room/loot configs exist, skim them so you can tune values yourself.

---

## Quick reference: phase → what you need

| Phase | You need |
|-------|----------|
| **1 – First playable** | Hub tileset, dungeon tileset, menu background, basic UI panels, player sprites (8 dir + animations), 1 melee + 1 ranged enemy, minimal FX, minimal design for those enemies/weapons. |
| **2 – Combat & enemies** | More enemy sprites, FX/projectiles, full enemy/weapon/room/reward design, combat SFX. |
| **3 – Progression & meta** | Hunter log design + UI assets, loot pool design, HUD/currency icons, optional music, UI sounds. |
| **4 – Polish & release** | Monetization decisions (ads, gems), art polish, music/SFX, store assets. |
