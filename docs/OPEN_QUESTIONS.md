## Open Questions for Roguelike Dungeon

> Please answer directly under each question. Leave anything you are unsure about blank so we can iterate later.

### 1. Core Game Feel

- **1.1 Real‑time vs turn‑based combat?**  
  _Your answer:_

- **1.2 Target orientation (portrait vs landscape)?**  
  (Menu taking 30–40% of the screen: do you imagine this in portrait or landscape?)  
  _Your answer:_

- **1.3 Target frame rate & performance priority?**  
  (e.g. 60 FPS on mid‑range Android; are you okay dropping visual fidelity to keep FPS stable?)  
  _Your answer:_

- **1.4 Input scheme on mobile?**  
  (Virtual joystick + buttons, tap‑to‑move, swipe‑based, or something else?)  
  _Your answer:_

- **1.5 Camera behavior in dungeon rooms?**  
  (Fixed camera per room vs camera following player within room bounds?)  
  _Your answer:_

### 2. Visual Style & Assets

- **2.1 Art style reference?**  
  (Pixel art, vector/HD 2D, specific games you want to be close to?)  
  _Your answer:_

- **2.2 Base resolution / tile size?**  
  (e.g. 16x16, 32x32 tiles, and target base resolution for layout.)  
  _Your answer:_

- **2.3 Player and enemy sprite sheets format?**  
  (Number of directions: 4‑dir, 8‑dir, or only facing one direction with rotation handled in‑engine?)  
  _Your answer:_

- **2.4 Animation requirements per character type?**  
  (Idle, walk, attack, cast, hit, death, dash, etc. — which are mandatory for v1?)  
  _Your answer:_

- **2.5 FX assets (projectiles, hits, spells)?**  
  (Will you create bespoke FX for each enemy/weapon, or a shared, reusable FX set?)  
  _Your answer:_

- **2.6 UI asset style?**  
  (Flat/minimal vs textured fantasy UI; rounded vs sharp corners, etc.)  
  _Your answer:_

### 3. Game Structure & Progression

- **3.1 Overall run length target?**  
  (Average time to reach floor 25 for a successful run?)  
  _Your answer:_

- **3.2 Meta‑progression scope?**  
  (Hunter log: do perks persist across runs only, or some also affect the current run?)  
  _Your answer:_

- **3.3 Number of save slots & save semantics?**  
  (Single auto‑save per account, multiple manual slots, or both?)  
  _Your answer:_

- **3.4 When exactly do we save?**  
  (On room enter/clear, on hub visit, on floor change, on quit, etc.)  
  _Your answer:_

- **3.5 Death behavior?**  
  (On death: go back to hub with some currencies, lose all run items, keep some meta‑progress?)  
  _Your answer:_

### 4. Hub Design

- **4.1 Hub layout complexity for v1?**  
  (Single screen with all interactables vs multi‑area hub that we explore by walking?)  
  _Your answer:_

- **4.2 Shop structure & currencies?**  
  - What currencies exist (gold, gems, run‑only shards, etc.)?  
  - Which are meta (persistent) vs run‑bound (lost on death)?  
  _Your answer:_

- **4.3 Hunter log interaction flow?**  
  (Is it an in‑world object only, or also accessible from menu? Are perks grouped by trees, categories, or flat list?)  
  _Your answer:_

- **4.4 Additional playable characters unlocking?**  
  (Unlock conditions: specific floor reached, boss killed, achievements, or via currency in hub?)  
  _Your answer:_

- **4.5 Best‑floor display behavior?**  
  (Show best floor per character, per difficulty, or overall account best?)  
  _Your answer:_

### 5. Dungeon & Rooms

- **5.1 Room size and aspect?**  
  (Number of tiles wide/high for a typical combat room; same for all floors?)  
  _Your answer:_

- **5.2 Room graph structure per floor?**  
  (Linear path with occasional branches, or more maze‑like with multiple optional rooms?)  
  _Your answer:_

- **5.3 Room presets quantity for v1?**  
  (Approximate number of combat room templates per floor range — e.g. 10 per floor band?)  
  _Your answer:_

- **5.4 “Lucky room” frequency & rules?**  
  (Rough % chance per room, any guarantees per floor, can two appear on the same floor?)  
  _Your answer:_

- **5.5 Wave structure for higher floors?**  
  (Max number of waves per room; do we ever mix waves + elite enemies + traps?)  
  _Your answer:_

- **5.6 Boss room cadence beyond floor 25?**  
  (If we later extend past 25, do we keep “every 5 floors” as the rule?)  
  _Your answer:_

- **5.7 Backtracking rules between rooms/floors?**  
  (You said “once you go up you can’t go back” — does that mean free backtracking within a floor only?)  
  _Your answer:_

### 6. Enemies & Combat

- **6.1 Initial enemy archetype list?**  
  (For v1, how many melee archetypes and how many ranged archetypes do you want?)  
  _Your answer:_

- **6.2 AI sophistication level for v1?**  
  (Simple chase & shoot vs more advanced (kiting, flanking, line‑of‑sight checks, etc.)?)  
  _Your answer:_

- **6.3 Friendly‑fire / collision rules?**  
  (Can enemies block each other; can they hit each other with projectiles?)  
  _Your answer:_

- **6.4 Damage model granularity?**  
  (Flat damage, crits, status effects (poison, burn, slow), armor, resistances?)  
  _Your answer:_

- **6.5 Boss design expectations for v1?**  
  (Number of distinct bosses by floor 25; do you expect multi‑phase fights from the start?)  
  _Your answer:_

### 7. Items, Loot & Consumables

- **7.1 Inventory structure?**  
  (Grid‑based like classic roguelikes, simple list with slots, or Diablo‑style with item rarity?)  
  _Your answer:_

- **7.2 Consumables categories?**  
  (Health, mana/energy, temporary buffs, escape items, keys, etc. Which are required for v1?)  
  _Your answer:_

- **7.3 Weapon types and behavior?**  
  (Melee swords/axes, ranged bows/guns, staves, etc. Any must‑have archetypes for v1?)  
  _Your answer:_

- **7.4 Loot drop philosophy?**  
  (Many small drops vs fewer, more meaningful drops; guaranteed rewards in certain rooms?)  
  _Your answer:_

- **7.5 Chest contents & power level in lucky rooms?**  
  (Are chests always “very strong” rewards, or can they also be small bonuses?)  
  _Your answer:_

### 8. Technical & Architecture

- **8.1 Save data location & format?**  
  (Pure local on device using JSON + Flutter storage, or do you plan any backend later?)  
  _Your answer:_

- **8.2 Target minimum Android/iOS versions?**  
  _Your answer:_

- **8.3 Audio expectations?**  
  (Background music per floor type, SFX variety, any dynamic music requirements?)  
  _Your answer:_

- **8.4 Monetization or purely premium/experimental?**  
  (Free, premium, ads, IAP for cosmetics only, etc. Even if not implemented now, direction matters.)  
  _Your answer:_

- **8.5 Data‑driven configuration expectations?**  
  (Are you comfortable editing JSON/YAML for enemies/rooms/loot pools, or do you prefer everything in code?)  
  _Your answer:_

### 9. UX & Accessibility

- **9.1 Colorblind / accessibility requirements?**  
  _Your answer:_

- **9.2 Haptics & vibration?**  
  (On hit, on level‑up, on boss entry, etc.)  
  _Your answer:_

- **9.3 Tutorial / onboarding expectations?**  
  (Full guided tutorial, minimal hints, or learn‑by‑dying with small tips?)  
  _Your answer:_

### 10. Future‑Proofing & Extensibility

- **10.1 Room / enemy pool extension workflow?**  
  (When you “add more rooms/enemies later”, do you want to mostly add config + art and have them auto‑integrated?)  
  _Your answer:_

- **10.2 Planned platforms beyond Android/iOS?**  
  (Desktop/web later? This can affect how we design input and UI scale.)  
  _Your answer:_

- **10.3 Modding or user‑generated content ambitions?**  
  (Even if far‑future, useful to know now.)  
  _Your answer:_

