# Game Dev Progress
Updated: 15.11.2026

## Setup

- Godot version: 4.7
- OS: Windows
- Language: GDScript (tabs for indentation, see .editorconfig)
- Editor: VS Code
- GDD: in Project Knowledge (v1.3 + stamina changes below)
- Roadmap: roadmap.md in Project Knowledge (and docs/ in the repo)
- Type: 3D only, third-person
- Repo: github.com/Lazy13909/the-adventure-of-lazy

## Roadmap (short; details in roadmap.md)

| # | Milestone | Status |
|---|---|---|
| M0 | Foundation | done |
| M1 | Player systems | in progress (only M1.2 left) |
| M2 | Interaction, notes, journal | todo |
| M3 | Food and radial menu | todo |
| M4 | Doors, keys, torches | todo |
| M5 | Entry Hall and Kitchen | todo |
| M6 | Living Room and the Screamer (vertical slice) | todo |
| M7 | Bedroom and ending | todo |
| M8 | Saves, lose condition, full run (MVP), then feature freeze | todo |
| M9 | Audio, lighting, art polish | todo |
| M10 | Bug fixing, export, release | todo |

## Current milestone

M1: Player systems. Remaining: M1.2 crouch camera.

## Done

- M0 (17.10.2026): git cleanup, mouse capture, interact and inventory input actions.
- Player state machine: Idle, Walking, Jump, CrouchIdle, CrouchWalk, Running.
- Health and Stamina with signals + setters. HUD in Main (tested).
- FearDamage and the Kitchen trigger (tested).
- DamageOverlay: red blotches, fade with a Tween (tested).
- M1.1 jump zones (13.11.2026): JumpZone (Area3D) counts zones with
  player.jump_zone_count. can_jump() needs a zone and 20% stamina.
  Each jump costs 20%. Free jump is off.
- Stamina regen changes (13.11.2026): standing 10/s, walking 5/s,
  no regen while running or jumping, 1 s delay after landing.
- M1.3 refactor (15.11.2026), batches A, B, C:
  - Jump numbers are all positive (no double negative).
  - Helpers in PlayerController: apply_horizontal_velocity, accelerate, brake,
    rotate_skin_toward_input, set_crouch_height, wants_to_jump, can_jump.
  - States use the helpers. No-op line removed.
  - camera_controller variable renamed to camera.
  - Tabs everywhere, .editorconfig updated.
  - FearDamage node type changed to Node.
  - Folders renamed: player/character/, ui/hud/ (hud.gd, hud.tscn),
    damage_overlay.tscn.

## In progress

- Nothing started yet. Next is M1.2.

## Known bugs

- Crouch camera cannot look under the bed -> M1.2.
- StateMachine is_log_enabled is on (turn off in M10).
- stop_fear_damage() not used yet (needed in M7 ending and M8 lose condition).
- Cannot jump while running (must release Shift first). Fine for now.

## Technical decisions

- Slower running at low stamina: rejected. GDD unchanged.
- Food: radial menu (BioShock style), hold Q.
- Ending: no second key. Opening the final door is the "key". Door ~35 degrees,
  white 3-5 s, camera turns 180 degrees, fade to black within 10 s.
- Fear damage: starts in the Kitchen, none in the Entry Hall, pauses with journal/pages viewer.
- Health/Stamina: signals + setters (clamp in setter, emit only on change).
- HUD in Main scene, listens to player signals.
- DamageOverlay: CanvasLayer in Main (Layer lower than HUD), ColorRect (Full Rect,
  Mouse Filter Ignore) with ShaderMaterial. @export player, @export flash_duration (1.2 s).
  Listens to FearDamage.damage_dealt. remap(2..5 -> 0.5..1.0). If the damage range
  changes, update remap. flash(intensity), set_permanent_strength(value).
- Shader: own hash + value_noise + fbm (4 octaves). Uniforms: blotch_color,
  flash_strength, permanent_strength, noise_scale (3.0).
- Screamer later (M6): flash(1.0) and set_permanent_strength(...).
- Plan: greybox first, art in M9. Feature freeze after M8.
- Bookshelf push (M6) is a scripted push, not physics.
- Folder rule: put a file next to the thing it belongs to.
- Jump zones: JumpZone lives in levels/jump_zone/ (not interactables/, because
  the player does not press E). Counter, not true/false, so overlapping zones work.
- interactables/ is for objects with E. First files come in M2.
- Rename files only in the Godot FileSystem dock. On Windows, rename
  Name -> name_tmp -> name (case-only rename trick).

## Open questions

- Where do jump zones appear in the level? (GDD 3.1 has no jump obstacle in 4.3.)
- Puzzle healing +10 Health (GDD 3.3): confirm.
- Cutscene limit: GDD 12 says 15 s, an old note said 5 s, the ending may be 15-20 s.
- Note #4 wording ("The key is behind that door") vs no second key.
- After the credits: quit or menu? Main/pause menu needed? (decide in M8)
- Confirm the updated GDD text (Sections 3.1, 3.3, 3.4, 4.3, 8.2, 12) is pasted into the GDD.
- Should the 1 s stamina delay also happen after running? (now: no)

## Concepts learned / need practice

- Learned: shader basics, hash/value_noise/fbm (idea level), mix/lerp, smoothstep,
  clamp, signals, @onready, $Node, Tween, remap, material vs shader,
  Area3D body_entered/body_exited, counter vs flag, helper functions,
  limit_length (speed cap).
- Practice: change one shader number at a time and predict the result;
  debug a shader by showing a variable as gray.
  Open check question: what does Vector2(1, 0).angle() return?
- Learning style: small interactive visuals and numeric examples help. If "I don't understand",
  give the big picture first (what and why), then ask which part is unclear.

## Next task

M1.2: crouch camera. While crouching, the player can look under furniture
(for example, under a bed). Test with a test bed in the greybox level.
