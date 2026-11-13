# Game Dev Progress
Updated: 11.11.2026

## Setup

- Godot version: 4.7
- OS: Windows
- Language: GDScript
- Editor: VS Code
- GDD: in Project Knowledge (v1.3)
- Roadmap: roadmap.md in Project Knowledge (and docs/ in the repo)
- Type: 3D only, third-person
- Repo: github.com/Lazy13909/the-adventure-of-lazy

## Roadmap (short; details in roadmap.md)

| # | Milestone | Status |
|---|---|---|
| M0 | Foundation | done |
| M1 | Player systems | in progress (M1.1, M1.2, M1.3 left) |
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

M1: Player systems. Goal: the player moves, gets tired and gets scared, as in GDD Section 3.
Remaining: M1.1 jump zones, M1.2 crouch camera, M1.3 cleanup.

## Done

- M0 (17.10.2026): git cleanup, mouse capture, interact and inventory input actions.
- Player state machine: Idle, Walking, Jump, CrouchIdle, CrouchWalk, Running.
- Health and Stamina with signals + setters. HUD in Main (tested).
- FearDamage (2-5 Health, every 30-60 s) and the Kitchen trigger (tested).
- DamageOverlay: red blotches on each fear hit, fade out with a Tween (tested, no errors).
  The permanent-scar dial is ready for the Screamer, not used yet.
- Greybox test level (throwaway).
- Roadmap M0-M10 written (11.11.2026).

## In progress

- Nothing started yet. Next is M1.1.

## Known bugs

- Free jump still enabled (GDD: jump zones only, 20% stamina per jump) -> M1.1.
- Crouch camera cannot look under the bed -> M1.2.
- No-op line `player.movement_input.normalized()` in player_walking_state.gd -> M1.3.
- StateMachine is_log_enabled is on (turn off in M10).
- stop_fear_damage() not used yet (needed in M7 ending and M8 lose condition).

## Technical decisions

- Slower running at low stamina: rejected. GDD unchanged.
- Food: radial menu (BioShock style), hold Q.
- Ending: no second key. Opening the final door is the "key". Door ~35 degrees,
  white 3-5 s, camera turns 180 degrees, fade to black within 10 s.
- Fear damage: starts in the Kitchen, none in the Entry Hall, pauses with journal/pages viewer.
- Health/Stamina: signals + setters (clamp in setter, emit only on change).
- HUD in Main scene, listens to player signals.
- DamageOverlay: CanvasLayer in Main (Layer lower than HUD), ColorRect (Full Rect, Mouse Filter Ignore)
  with ShaderMaterial. Script on the CanvasLayer: @export player, @export flash_duration (1.2 s).
  Listens to FearDamage.damage_dealt. remap(2..5 -> 0.5..1.0). If the damage range changes, update remap.
  flash(intensity): kill old tween, set flash_strength, Tween to 0 (TRANS_QUAD, EASE_OUT).
  set_permanent_strength(value): lasting edge blotches.
- Shader: own hash + value_noise + fbm (4 octaves). Not used: sin rand, NoiseTexture2D.
  Uniforms: blotch_color, flash_strength, permanent_strength, noise_scale (3.0).
- Screamer later (M6): flash(1.0) and set_permanent_strength(...).
- Plan: greybox first, art in M9. Feature freeze after M8.
- Bookshelf push (M6) is a scripted push, not physics (physics puzzles are out of scope).
- Folder rule: put a file next to the thing it belongs to.

## Open questions

- Where do jump zones appear in the level? (GDD 3.1 has no jump obstacle in 4.3.)
- Puzzle healing +10 Health (GDD 3.3): confirm.
- Cutscene limit: GDD 12 says 15 s, an old note said 5 s, the ending may be 15-20 s. Which is right?
- Note #4 wording ("The key is behind that door") vs no second key.
- After the credits: quit or menu?
- Main menu / pause menu: needed? (decide in M8)
- Confirm the updated GDD text (Sections 3.3, 3.4, 4.3, 8.2, 12) is pasted into the GDD.

## Concepts learned / need practice

- Learned: shader basics (uniform, UV, alpha), hash/value_noise/fbm (idea level; black boxes are OK),
  mix/lerp, smoothstep, clamp, signals, @onready, $Node, Tween, remap, material vs shader.
- Practice: change one shader number at a time and predict the result;
  debug a shader by showing a variable as gray (COLOR = vec4(vec3(noise), 1.0)).
- Learning style: small interactive visuals and numeric examples help. If "I don't understand",
  give the big picture first (what and why), then ask which part is unclear.

## Next task

M1.1: make the player jump only inside a JumpZone (Area3D), with a 20% stamina cost per jump.
