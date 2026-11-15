# Roadmap: The Adventure of Lazy

**Updated:** 11.11.2026
**Based on:** GDD 1.3 (Section 14, original week plan) and all decisions up to 10.11.2026.
**Rule:** this file is the working plan. GDD Section 14 is only the first estimate. If they differ, this file wins.

## How we use this plan

1. Work on **one milestone** at a time, and **one task** at a time.
2. Every task must be tested in the game before the next one starts.
3. After each finished milestone, update the status here and in `gamedev_progress.md`.
4. New idea during a milestone? Write it in "Ideas for later" at the bottom. Do not add it to the current milestone.
5. **Feature freeze** comes after M8. After that, no new mechanics.
6. Greybox first (simple boxes and placeholders). Final art comes in M9.

Status: `[x]` done, `[~]` in progress, `[ ]` not started.

Size is a rough guess at about 4 hours per day: S = 2-3 days, M = about 1 week, L = about 2 weeks. After M2 we measure the real speed and adjust.

## Overview

| # | Milestone | Size | Status |
|---|---|---|---|
| M0 | Foundation | S | [x] |
| M1 | Player systems | M | [~] |
| M2 | Interaction, notes, journal | M | [ ] |
| M3 | Food and radial menu | M | [ ] |
| M4 | Doors, keys, torches | M | [ ] |
| M5 | Entry Hall and Kitchen | L | [ ] |
| M6 | Living Room and the Screamer | L | [ ] |
| M7 | Bedroom and ending | L | [ ] |
| M8 | Saves, lose condition, full run | L | [ ] |
| M9 | Audio, lighting, art polish | L | [ ] |
| M10 | Bug fixing, export, release | M | [ ] |

**Playable stages**
- **Vertical slice** = end of M6 (Entry Hall, Kitchen, Living Room with the Screamer; greybox is fine).
- **MVP** = end of M8 (all 4 rooms, ending, saves; greybox is fine).
- **Release** = end of M10.

---

## M0: Foundation `[x]`

**Goal:** a clean project to build on.
**Done (17.10.2026):** git cleanup, mouse capture, interact and inventory input actions.

---

## M1: Player systems `[~]`

**Goal:** the player moves, gets tired, and gets scared, as in GDD Section 3.
**Depends on:** M0.

**Already done**
- Player state machine: Idle, Walking, Jump, CrouchIdle, CrouchWalk, Running.
- Health and Stamina (signals + setters), HUD with two bars.
- FearDamage (2-5 Health, one hit every 30-60 s) and the Kitchen trigger.
- DamageOverlay (red blotches that fade; permanent-scar dial ready for the Screamer).

**Tasks**
- `[x]` **M1.1 Jump zones.** Done 13.11.2026.
- `[ ]` **M1.2 Crouch camera.** While crouching, the camera can look under furniture.
- `[x]` **M1.3 Cleanup.** Done 15.11.2026 (helpers, tabs, folder names).

**Done when**
- Space does nothing outside a zone. Inside a zone it makes a jump and costs 20% Stamina. (done)
- In a test room, a crouching player can see under a test bed.
- No fear damage in the test hall before the Kitchen trigger. (done)
- No errors in the Output panel. (done)

**Risks:** third-person camera clipping into furniture while crouching.
**Concepts:** Area3D signals (`body_entered`, `body_exited`), guarding a state transition with a flag, camera height and collision.
**GDD:** 3.1, 3.3, 3.4.

---

## M2: Interaction, notes, journal `[ ]`

**Goal:** the player can look at an object, press E, and read a note.
**Depends on:** M1.

**Tasks**
- `[ ]` **M2.1 Interaction detection and "E" prompt.** Compare RayCast3D and Area3D in front of the player, then choose one.
- `[ ]` **M2.2 Base interactable.** One shared script or scene with an `interact()` function, in `interactables/`.
- `[ ]` **M2.3 Note pickup.** Note data (id, title, text). Collected notes are stored in `game_state.gd` (autoload).
- `[ ]` **M2.4 Pages viewer.** Crumpled paper in the center, readable text on a blurred background, closes with Escape.
- `[ ]` **M2.5 Journal (Tab).** A list of all collected notes. Selecting a note opens the pages viewer.
- `[ ]` **M2.6 Pause rules.** While the journal or viewer is open: no fear damage, no Stamina change, audio keeps playing.

**Done when:** two test notes can be picked up, read, and reopened from the journal. Fear damage does not tick while they are open, and it continues after closing.

**Risks:** pausing the whole tree would also stop audio, so use `process_mode` or our own pause flag.
**Concepts:** raycast or area detection, autoload, custom Resource, Control nodes, `process_mode`.
**GDD:** 3.2, 5, 9, 18.

---

## M3: Food and radial menu `[ ]`

**Goal:** the player can eat food to heal.
**Depends on:** M2 (interaction).

**Tasks**
- `[ ]` **M3.1 Food pickup.** A counter in `game_state.gd`. No capacity limit.
- `[ ]` **M3.2 One-time tutorial prompt** the first time food is picked up.
- `[ ]` **M3.3 Radial menu.** Hold Q to open, choose Food, choose the number of portions with the visual stack. Each portion gives +20 Health (clamped by the Health setter).
- `[ ]` **M3.4 Matches flag** in `game_state.gd` (used in M7).

**Done when:** 3 food items can be picked up. Q opens the menu. Eating 2 portions gives +40 Health, and Health never goes above 100. Mouse look still works after the menu closes.

**Risks:** angle math for choosing a sector (atan2); mouse mode while the menu is open.
**Concepts:** 2D angles and `atan2`, custom UI drawing and input, mouse capture modes, hold-input.
**GDD:** 3.3, 5, 9.

---

## M4: Doors, keys, torches `[ ]`

**Goal:** the navigation language of the game works.
**Depends on:** M2.

**Tasks**
- `[ ]` **M4.1 Door.** Open animation, locked or unlocked state.
- `[ ]` **M4.2 Key pickup and use.** The key is used immediately on the door. No inventory slot.
- `[ ]` **M4.3 Torch.** Lit or unlit look (light and flame). A lit torch beside a door means "you can go here".
- `[ ]` **M4.4 Placeholders** for the door and key sounds.

**Done when:** a test room has a locked door and a key somewhere else. The door opens only with the key. Two lit torches mark an open door. An unlit torch is dark.

**Risks:** door collision and animation; too many lights hurting performance.
**Concepts:** AnimationPlayer, scene instancing, signals between scenes, Light3D.
**GDD:** 4.2, 5.

---

## M5: Entry Hall and Kitchen `[ ]`

**Goal:** the first two rooms are playable, including the Kitchen puzzle.
**Depends on:** M2, M3, M4.

**Tasks**
- `[ ]` **M5.1 Entry Hall.** Player spawn, Note #1 on a table, one food, two lit torches at the Kitchen door. No fear damage.
- `[ ]` **M5.2 Kitchen.** Window light, props, one food. Move `KitchenFearTrigger` into `kitchen.tscn`.
- `[ ]` **M5.3 Code puzzle.** Three digits: in the wall cabinet, behind the wall clock (lift the clock to see a hole in the wall; discard it or hang it back), and on the refrigerator. Digits are upside-down and out of order. Padlock UI for a 3-digit code.
- `[ ]` **M5.4 Key #1** opens the corridor door (lit torch) toward the Living Room.
- `[ ]` **M5.5 Level structure.** Each room is its own scene in `levels/`, and the Main scene loads them.

**Done when:** start in the Entry Hall, read the note, enter the Kitchen (fear damage starts once), find three digits, solve the padlock, and Key #1 opens the door.

**Risks:** how to show upside-down digits; too much time on room decoration (greybox is enough here).
**Concepts:** scene composition, Label3D or textures, UI for the padlock, scene loading.
**GDD:** 4.3 (Rooms 1 and 2), 6.

---

## M6: Living Room and the Screamer `[ ]` (vertical slice)

**Goal:** the one big scare of the game.
**Depends on:** M5, DamageOverlay.

**Tasks**
- `[ ]` **M6.1 Living Room.** Sofa with Note #2, cold fireplace, bookshelf blocking the door.
- `[ ]` **M6.2 Bookshelf push.** A scripted push (not physics, because physics puzzles are out of scope). It costs Stamina.
- `[ ]` **M6.3 Screamer sequence** (starts when the push starts):
  1. White or black cut, a few seconds of silence.
  2. The scream (loudest sound, capped at -6 dB), -25 Health, `flash(1.0)`.
  3. "Blinking" return of sight, four cycles.
  4. `set_permanent_strength(...)` so the red edge blotches stay until the end.
  5. Heavy breathing for 10 seconds, then it fades.
- `[ ]` **M6.4 After the event.** Note #3 appears on the shelf, Key #2 is in a drawer, and the torch door toward the Bedroom opens.

**Done when:** a full walk from the Entry Hall to the Living Room works. The scare happens only once. The permanent blotches stay. Note #3 appears only after the event. Key #2 opens the door.

**Risks:** loudness (test with low volume first); timing of the sequence; keeping the scare triggered only once.
**Concepts:** sequences with `await` or Tween, AudioStreamPlayer, screen effects in a CanvasLayer, one-shot flags.
**GDD:** 4.3 (Room 3), 7, 17.
**Stage:** vertical slice. If possible, let 1-2 people try it.

---

## M7: Bedroom and ending `[ ]`

**Goal:** the last room and the final scene.
**Depends on:** M6.

**Tasks**
- `[ ]` **M7.1 Dark Bedroom.** No torches lit. Matches on the nightstand (faint glint). After finding the matches, the candle on the desk gets a glint. Light the candle (E, needs matches). That shows the room enough to find a wall torch. Light it, and the room is fully lit.
- `[ ]` **M7.2 Note #4** appears on the door when the candle is lit. **Key #3** is under the mattress.
- `[ ]` **M7.3 Ending sequence.**
  1. After reading Note #4, an unsettling ambient cue starts.
  2. Key #3 unlocks the final door, which opens about 35 degrees.
  3. Only white for 3-5 seconds.
  4. The camera turns 180 degrees and shows the Bedroom in complete disarray.
  5. Within 10 seconds, fade to black, then the credits.
  6. Call `stop_fear_damage()`.
- `[ ]` **M7.4 Credits scene** (simple text).

**Done when:** the whole path, from entering the Bedroom to the credits, works.

**Risks:** showing the "disarray" version of the room (a second set of props or an animation); smooth camera turn; the bright white from the door.
**Concepts:** light and glow in WorldEnvironment, camera animation, Tween sequences, stopping systems cleanly, scene switching.
**GDD:** 4.3 (Room 4), 8.2, 15-18.

---

## M8: Saves, lose condition, full run `[ ]` (MVP)

**Goal:** the game is finished from start to end.
**Depends on:** M7.

**Tasks**
- `[ ]` **M8.1 Checkpoint save.** Save automatically when the player finds a room's key and passes through its exit. A simple local file.
- `[ ]` **M8.2 Resume.** If the player quits before finding the key, the next session starts at the beginning of that room.
- `[ ]` **M8.3 Lose condition.** Health 0 restarts from the last checkpoint. All collected items stay. Fear damage restarts correctly.
- `[ ]` **M8.4 Real flow.** Replace the greybox Main scene with Entry Hall, Kitchen, Living Room, Bedroom, credits. Linear, no backtracking.
- `[ ]` **M8.5 Full playtest** from start to finish (target 20-35 minutes). Recruit 2-3 external testers.

**Done when:** one full run works without a crash. Death and resume work. A checkpoint survives closing the game.

**Risks:** deciding what to save (current room, Health, notes, food, matches, "Screamer happened" flag). If the Screamer already happened, the permanent blotches must come back after loading.
**Concepts:** saving a dictionary to a file, autoload state, loading scenes, flags.
**GDD:** 8.1, 8.3, 14.

**FEATURE FREEZE after M8.**

---

## M9: Audio, lighting, art polish `[ ]`

**Goal:** the game feels like the GDD.
**Depends on:** M8.

**Tasks**
- `[ ]` **M9.1 Sounds** from the GDD sound map: footsteps, pickups, page turn, match, torch, eating, damage, scream, breathing, distant creak (every 60-90 s), door unlock, journal, low-health heartbeat (below 25 Health), and room ambience.
- `[ ]` **M9.2 Audio buses** (master, sfx, ambience, UI). Keep the scream peak at -6 dB.
- `[ ]` **M9.3 Lighting and color.** Each room cooler and less saturated than the last. Flickering torch light.
- `[ ]` **M9.4 Art pass.** Replace greybox with free assets (check each license).
- `[ ]` **M9.5 Performance.** Stable 60 FPS on mid-range hardware.

**Done when:** every row of the sound map is done or consciously cut. 60 FPS on the test PC.

**Risks:** asset licenses; polish that never ends, so set a time limit.
**Concepts:** AudioBus, AudioStreamPlayer vs AudioStreamPlayer3D, WorldEnvironment, the profiler.
**GDD:** 10, 20, 21.

---

## M10: Bug fixing, export, release `[ ]`

**Goal:** a public build on itch.io.
**Depends on:** M9.

**Tasks**
- `[ ]` **M10.1 Bug list** from playtests, then fix the important ones.
- `[ ]` **M10.2 Remove debug code.** Logs (`is_log_enabled`), test lines, test Inspector values.
- `[ ]` **M10.3 Export** a Windows build. Test it on another PC or a clean folder.
- `[ ]` **M10.4 itch.io page.** Description, screenshots, 18+ audience, credits for all assets and sounds.
- `[ ]` **M10.5 Announcement** (Telegram, Reddit dev log).

**Done when:** the build runs on another PC and the page is public.

**Risks:** missing export templates; file paths that work only in the editor.
**Concepts:** export presets, project settings, release checklist.
**GDD:** 11.

---

## Out of scope (GDD Section 12)

Combat, multiple enemy types, voice acting, branching story, mid-room saves, physics puzzles, multiplayer, hunger or warmth stats, more than 4 rooms. Ideas for v2 (GDD Section 13) wait until after release.

## Open questions

1. **Jump zones:** GDD 3.1 requires them, but Section 4.3 has no jump obstacle. Plan: build the mechanic with a test zone in M1.1, decide the real places in M5-M7.
2. **Puzzle healing +10 Health** (GDD 3.3): suggested, not confirmed.
3. **Cutscene length:** GDD Section 12 says no cutscenes longer than 15 seconds. An earlier note said 5 seconds. The ending may take about 15-20 seconds. Which number is right?
4. **Note #4** says "The key is behind that door", but there is no second key now. Reword it, or keep it as a metaphor?
5. **After the credits:** quit the game, or go back to a menu?
6. **Main menu / pause menu:** not in the GDD. Decide in M8.
7. **GDD text** for Sections 3.3, 3.4, 4.3, 8.2 and 12: confirm the updated version is pasted into the GDD.

## Ideas for later

(empty: write new ideas here, not into the current milestone)
