# THE ADVENTURE OF LAZY

### Game Design Document & Narrative Bible

**Version:** 1.3 (revised 19.10.2026) **Original Date:** 28.06.2026 **Author:** Lazy **Engine:** Godot 4.7 **Genre:** Short-form psychological/mystery horror — third-person exploration & light puzzle **Platform:** PC (Windows), distributed via itch.io **Target Audience:** Adults 18+ — fans of atmospheric, narrative-driven horror (e.g. _Visage_, _What Remains of Edith Finch_, _The Beast Inside_ notes-and-exploration segments) **Estimated Playtime:** 20–35 minutes (single sitting, single ending)

## Table of Contents

**Part I — Game Design Document**

1. [Game Overview](#1-game-overview)
2. [Core Loop](#2-core-loop)
3. [The Player](#3-the-player)
4. [World & Level Design](#xytc8kfqjs0x)
5. [Resources & Inventory](#ydyuh3685kt3)
6. [Puzzle Design](#6-puzzle-design)
7. [The Enemy — The Screamer](#iq5b3x9wkpud)
8. [Win / Lose Conditions & Save System](#2qvrwlulik2d)
9. [UI / UX](#xsdpu2jjsrwf)
10. [Art Direction](#10-art-direction)
11. [Technical Requirements](#11-technical-requirements)
12. [Scope Boundaries — Not in v1](#bbt4gx3tu6r9)
13. [Ideas for v2](#13-ideas-for-v2)
14. [Development Timeline](#14-development-timeline)

**Part II — Narrative Document** 15. [Premise & Themes](#j3ealuh2d3vw) 16. [Character Profile — Lazy](#ktvilqt3x226) 17. [The Screamer as a Narrative Device](#17-the-screamer-as-a-narrative-device) 18. [The Notes (Full Text & Placement)](#lc66ly758bly) 19. [Pacing & Emotional Arc](#salqm9afvw1t)

**Part III — Audio Design** 20. [Sourcing Sounds](#20-sourcing-sounds) 21. [Sound Map](#21-sound-map)

## PART I — GAME DESIGN DOCUMENT

## 1\. Game Overview

### 1.1 One-Line Description

A short third-person mystery-horror game in which the player explores a dark, abandoned house, solves simple environmental puzzles, reads scattered notes left behind by the house's former occupant, and searches for a way out — all while an unexplainable presence, the Screamer, reacts to their progress.

### 1.2 Player Fantasy

The player is not a hero and not a victim of a "haunting" in the traditional sense. They are a trespasser who stumbles into the aftermath of someone else's collapse — piecing together, room by room, what happened to the man who lived here, while something in the house responds to their presence as if they were him. The fantasy is one of dread-tinged curiosity: the pull to know what happened here outweighs the instinct to leave.

### 1.3 Unique Selling Points

- **A four-room story told almost entirely through environmental storytelling** — no dialogue, no combat, just notes, objects, and space.
- **A monster that is a metaphor, not a villain.** The Screamer never needs to be explained away with lore dumps; its nature is revealed gradually through the protagonist's own notes.
- **Tight, controlled scope** — a single linear path, a single ending, designed to be finished in one sitting and polished rather than padded.

### 1.4 Design Pillars

| **Pillar**                                 | **What it means in practice**                                                                                                       |
| ------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------- |
| **No combat, no escape from dread**        | The player can never fight back. Tension is resolved by enduring, not by winning a confrontation.                                   |
| ---                                        | ---                                                                                                                                 |
| **Show, don't explain**                    | The Screamer, the house, and Lazy's fate are understood through environmental detail and notes, never exposition dumps or dialogue. |
| ---                                        | ---                                                                                                                                 |
| **Small and polished over large and thin** | Four rooms, one ending, but every room fully realized in atmosphere, puzzle, and story beat.                                        |
| ---                                        | ---                                                                                                                                 |

## 2\. Core Loop

Enter room → Explore and interact → Find clue or key → Solve puzzle

→ Unlock next room → Encounter the Screamer (Room 3 only) → Repeat

Each room is a self-contained loop of exploration and problem-solving that gates progress to the next room, with the narrative delivered as a reward for exploration rather than a requirement to progress (notes are optional reading, keys are not).

## 3\. The Player

### 3.1 Perspective & Movement

- **Camera:** Third-person, mouse-controlled.
- **Movement:** WASD to walk; **Shift** to sprint (consumes Stamina).
- **Crouch:** **Ctrl** toggles crouching. Crouching lowers the view so the player can look under furniture, such as the bed, even though the camera is third-person.
- **Jump:** **Space** works only inside specially marked jump zones, where the player has to jump to get past an obstacle. Free jumping is disabled. Each jump costs Stamina.

### 3.2 Actions

| **Input**        | **Action**                                                                                                                                               |
| ---------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **E**            | Context-sensitive interact: pick up items, open drawers, read notes, light a torch or candle (requires Matches when lighting a flame)                    |
| ---              | ---                                                                                                                                                      |
| **Tab**          | Open/close the journal: a list of every note collected so far. Selecting a note opens it in the pages viewer. The game pauses while the journal is open. |
| ---              | ---                                                                                                                                                      |
| **Shift** (hold) | Sprint                                                                                                                                                   |
| ---              | ---                                                                                                                                                      |
| **Ctrl**         | Crouch / stand up (toggle); lets the player look under furniture                                                                                         |
| ---              | ---                                                                                                                                                      |
| **Space**        | Jump (marked jump zones only)                                                                                                                            |
| ---              | ---                                                                                                                                                      |
| **Escape**       | Close the notes/pages viewer or the journal                                                                                                              |
| ---              | ---                                                                                                                                                      |

### 3.3 Player Stats

| **Stat**    | **Starting Value** | **Drops When**                                                                                                                                     | **Restores When**                                                                                                                     |
| ----------- | ------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| **Health**  | 100                |Fear damage: small random hits (2–5 Health) every 30–60 seconds (see 3.4); Screamer encounter (−25)                                                 | Eating food (+20); solving a puzzle (+10)
| ---         | ---                | ---                                                                                                                                                | ---                                                                                                                                   |
| **Stamina** | 100                | Continuous running: empties the bar in 4–7 seconds (15%–25% of the bar per second);<br><br>Each jump: 20% of the bar;<br><br>Pushing heavy objects | Whenever the player is not running. Standing still: full refill in about 5 seconds. Walking: slower, full refill in about 12 seconds. |
| ---         | ---                | ---                                                                                                                                                | ---                                                                                                                                   |

### 3.4 Fear Damage
- Rule: Fear damage starts when the player enters the Kitchen and continues until the end of the game. There is no fear damage in the Entry Hall. While it is active, the player loses a small, random amount of Health at random intervals (for example, for example, −4 after 35 seconds, then −2 after 52 seconds). It represents the fear and pressure of the house.
- Pause: Fear damage stops while the journal or the pages viewer is open. The game is paused, but the audio keeps playing.
- Feedback: Each time Health drops, red blotches appear across the whole screen and fade out, in the style of The Evil Within and Amnesia. The Screamer’s permanent red blotches (Section 7.1) use the same visual language.
-Tuning: Tuning: Starting values are 2–5 Health per hit, one hit every 30–60 seconds. They are balanced for about 20 minutes of fear time with 3 food portions (+20 each), and will be adjusted during playtesting. Falling damage no longer exists.

## 4\. World & Level Design

### 4.1 Setting

An abandoned house, isolated and in unnaturally good condition for how long it appears to have been empty. Four rooms, connected in a strictly linear sequence: **Entry Hall → Kitchen → Living Room → Bedroom.** There is no open-world exploration and no backtracking between rooms once a door is unlocked and passed.

### 4.2 Navigation Cue

**Lit wall torches mark traversable doors.** A torch beside a door means it can currently be opened; an unlit or torch-less doorway is locked or inaccessible. This single, consistent visual language means the player is never given an explicit objective marker or waypoint, but always has a clear, readable next goal.

### 4.3 Room Breakdown

#### Room 1 — Entry Hall _(Tutorial)_

- **Atmosphere:** Calm, ordinary, almost cozy — deliberately free of horror cues.
- **Danger:** None. There is no fear damage in this room. It starts when the player enters the Kitchen.
- **Content:** The player spawns here and finds **Note #1** on a table. Two lit torches mark the door to the Kitchen.
- **Design intent:** By the time the player leaves this room, they should feel safe and slightly relieved — a feeling the rest of the game will slowly dismantle.

#### Room 2 — Kitchen

- **Atmosphere:** Dim daylight filtering through a grimy window; a faint smell of rot implied through visual and audio cues (never shown directly).
- **Puzzle — The Hidden Code:** A 3-digit code is scattered across three separate hiding spots in the room:

  1. The **first digit** is inside the wall-mounted cabinet.
  2. The **second digit** is behind the wall clock — the player must lift the clock off its hook to reveal a hole in the wall behind it, then may either discard the clock or hang it back up.
  3. The **third digit** is on the refrigerator.
  - Each digit is printed **upside-down** and the three are **presented out of sequence**, so the player must mentally invert and reorder them to reconstruct the true code (e.g. a real code of 259 might be displayed as fragments that read as 5, 6, 2 upside-down and out of order until correctly interpreted).
  - Once all three digits are found, the player approaches the padlock and solves a short input puzzle, entering the digits in the correct order to unlock it.
  - **Reward:** **Key #1**, which opens the corridor door leading toward the Living Room (marked by a lit torch).
- Fear damage begins here.

#### Room 3 — Living Room

- **Atmosphere:** Dusty furniture, a cold fireplace with dead ashes — a room that has clearly not been warm in a long time.
- **Story content:** Two important notes are found here:
  - **Note #2**, on the sofa — the player learns what the house's occupant was thinking and feeling in the early days of his stay.
  - **Note #3** — this note does not start visible. It is revealed only after the player triggers the shelf event below, appearing among the shelf's contents.
- **Puzzle — The Blocked Door:** The path onward is blocked by a heavy bookshelf, which the former occupant pushed in front of the door himself out of fear (see Note #3). The player must push it aside, which costs Stamina.
- **The First Screamer Encounter:** The moment the player pushes the bookshelf, the Screamer appears (full behavioral spec in [Section 7](#iq5b3x9wkpud)).
- **After the encounter:** Behind the shelf, the player finds **Note #3** and **Key #2** in a drawer. Key #2 opens the corridor door toward the Bedroom (marked by a lit torch).

#### Room 4 — Bedroom _(Finale)_

- **Atmosphere:** Total darkness. No torches are lit at the start of this room — this is the one space the player must light themselves.
- **Puzzle — Let There Be Light:**
  1. **Matches** are hidden on the nightstand; they catch a faint glint of ambient light so the player can spot them even in near-total darkness.
  2. Once the matches are found, a **candle** on the desk becomes noticeable the same way — it also catches a faint highlight the player learns to look for.
  3. Lighting the candle reveals enough of the room to find a wall torch, which the player then lights, fully illuminating the Bedroom.
- **Reward:** With the room lit, the player finds **Key #3** hidden under the mattress.
- **Final Note (#4):** Appears on the door once the candle is lit. It is the most emotionally direct note in the game (full text in [Section 18](#lc66ly758bly)) and ends with an explicit warning not to take the key that lies behind the final door — because if the player takes it, "it follows you out."
- **The Ending:** After the player reads Note #4, an unsettling ambient cue begins. Key #3 unlocks the final door. The player opens it by about 35 degrees. Beyond it there is only white, held for 3–5 seconds. Then the camera turns 180 degrees, and the player looks back at the Bedroom, which is now in complete disarray. Within 10 seconds, the screen fades to black and the credits appear.

There is no second key and no choice. Opening the door is the step itself: to face fear, paranoia, and the voices in his head, the player must leave isolation, even when it hurts. One small step changes everything (the butterfly effect). The player’s past (the Screamer) leaves the house together with them. If the game is well received, the story continues from this point; otherwise this is the final ending.

## 5\. Resources & Inventory

| **Resource** | **Where Found**                                      | **Used For**                                                                                                                                                                                         |
| ------------ | ---------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Keys ×3**  | Hidden in each room, gated behind that room's puzzle | Unlock the corridor doors between rooms; used immediately on the door, so they never take an inventory slot                                                                                          |
| ---          | ---                                                  | ---                                                                                                                                                                                                  |
| **Pages ×4** | Tables, floors, and shelves throughout the house     | Narrative — no mechanical effect, purely story; stored in the journal                                                                                                                                |
| ---          | ---                                                  | ---                                                                                                                                                                                                  |
| **Food ×3**  | Entry Hall, Kitchen, Living Room                     | Carried and eaten when the player chooses, through the radial menu (Section 9); each portion restores 20 Health. The first time food is picked up, a one-time tutorial prompt teaches how to eat it. |
| ---          | ---                                                  | ---                                                                                                                                                                                                  |
| **Matches**  | Bedroom nightstand                                   | Required to see in the dark and to light candles and torches                                                                                                                                         |
| ---          | ---                                                  | ---                                                                                                                                                                                                  |

There is no slot-based inventory. Keys are used immediately, and pages are kept in the **journal** (Tab to open), which lists every note found so far, as in Amnesia. Food and matches are carried without a capacity limit, so the player never has to manage space or make discard decisions. Food is eaten through the radial menu (see Section 9).

## 6\. Puzzle Design

| **Type**           | **Description**                                                                                                                | **Location** |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------------ | ------------ |
| **Find the Code**  | A 3-digit number, its digits scattered, inverted, and out of order across hidden spots in the room; reconstructed at a padlock | Kitchen      |
| ---                | ---                                                                                                                            | ---          |
| **Find the Key**   | A key hidden in a drawer, under furniture, or behind an obstacle                                                               | All rooms    |
| ---                | ---                                                                                                                            | ---          |
| **Read the Notes** | Four pages that reveal the story; purely narrative, with no mechanical gate                                                    | All rooms    |
| ---                | ---                                                                                                                            | ---          |

Puzzle difficulty is intentionally light — the emphasis of the experience is atmosphere and story, not challenge. No puzzle should take a first-time player more than a few minutes.

## 7\. The Enemy — The Screamer

**No combat exists in this game.** The player cannot fight, evade through a skill check, or otherwise resist the Screamer directly. The only valid response to an encounter is to endure it.

### 7.1 Trigger & Sequence

The Screamer's single scripted appearance is triggered when the player pushes the bookshelf blocking the Living Room door.

1. **Blindness:** The screen cuts to white/black and the player is effectively blinded, accompanied by a moment of total silence.
2. **The Scream:** After a few seconds of silence, a loud scream plays — the loudest sound in the game (mixed carefully, limited to −6dB to avoid harming the player's ears) — dealing **−25 Health**.
3. **Slow Return of Sight:** The player must "blink" their way back to visibility — the eyes open partway, close again, and repeat this cycle four times before vision is fully restored.
4. **Permanent Mark:** From this point until the end of the game, faint red blotches remain at the edges of the screen — a lingering visual scar from the encounter that never fully clears.
5. **Fading:** Heavy breathing loops in the background for 10 seconds, then fades out as the Screamer disappears.

### 7.2 Behavior by Stage

| **Stage**         | **Behavior**                                           | **Room**            |
| ----------------- | ------------------------------------------------------ | ------------------- |
| **Dormant**       | Not present; no cues                                   | Entry Hall, Kitchen |
| ---               | ---                                                    | ---                 |
| **Triggered**     | Appears instantly when the player pushes the bookshelf | Living Room         |
| ---               | ---                                                    | ---                 |
| **Flash + Sound** | 3-second blinding flash, scream, −25 Health            | Living Room         |
| ---               | ---                                                    | ---                 |
| **Fading**        | 10 seconds of heavy breathing, then disappears         | Living Room         |
| ---               | ---                                                    | ---                 |

## 8\. Win / Lose Conditions & Save System

### 8.1 Saving & Checkpoints

- Progress saves automatically once the player finds a room's key and passes through its exit.
- If the player quits before finding the current room's key, the next session resumes from the last saved checkpoint (the start of the current room).

### 8.2 Win Condition

The player reaches the Bedroom, finds Key #3, and reads the final note. The player opens the final door by about 35 degrees. Only white is visible for 3–5 seconds. Then the camera turns 180 degrees to show the Bedroom in complete disarray. Within 10 seconds, the screen fades to black and the credits appear.

### 8.3 Lose Condition

If the player's Health reaches 0, the game restarts from the last checkpoint — all previously collected items are retained.

## 9\. UI / UX

- **Top-left HUD:** Health and Stamina bars.
- **Interaction prompt:** Contextual "E" prompt for picking up, reading, and interacting with objects.
- **Journal:** Opens on Tab press and shows a list of all collected notes. Selecting a note opens the pages viewer. The game pauses while the journal or the pages viewer is open (no fear damage, no Stamina change), but the audio keeps playing.
- **Radial menu:** A BioShock-style radial menu is used to eat food. The player opens it with a dedicated key (key not chosen yet), selects Food, and then chooses how many portions to eat using a visual stack (layered UI), where the portions are shown stacked on top of each other.
- **Pages viewer:** A crumpled sheet of paper appears in the center of the screen. To help the player read the difficult handwriting, a text with a blurred background will be placed over it; closes with Escape.
- **Damage feedback:** Red blotches flash across the whole screen each time the player loses Health (see 3.4).

## 10\. Art Direction

- **Visual tone:** Realistic-leaning, low-saturation interiors — a house that looks lived-in rather than derelict, which is unsettling precisely because nothing looks obviously "haunted."
- **Lighting:** The torch-as-navigation system doubles as the primary art direction tool — warm, flickering torchlight against otherwise dim or naturally-lit rooms creates a readable path without breaking immersion with UI markers.
- **Color language:** Each room shifts subtly cooler and more desaturated than the last, mirroring the emotional descent of the notes — the Entry Hall reads warm and ordinary; the Bedroom reads near-monochrome before the candle is lit.
- **The Screamer:** Never fully or clearly shown. Its presence should be communicated almost entirely through light, sound, and screen effects (the blinding flash, the red screen blotches) rather than a fully rendered character model, keeping both budget and dread proportional to the game's scope.

## 11\. Technical Requirements

- **Engine:** Godot 4.7
- **Target platform:** PC (Windows build), distributed via itch.io
- **Target performance:** Stable 60 FPS on mid-range hardware; the small, linear level set (4 rooms, no open world) should keep this achievable without heavy optimization work
- **Save data:** Simple local checkpoint save (per-room), no cloud sync required for v1
- **Build size:** Expected to be small given the constrained scope — no large open areas, no voice acting assets

## 12\. Scope Boundaries — Not in v1

- ❌ Combat — the player cannot fight the Screamer
- ❌ Multiple enemy types
- ❌ Voice acting or recorded dialogue
- ❌ Branching story or player choices
- ❌ Mid-room saving (checkpoints occur only between rooms)
- ❌ Physics puzzles (pressure plates, box-pushing, etc.)
- ❌ Multiplayer
- ❌ Hunger or warmth survival stats
- ❌ More than 4 rooms
- ❌ Cutscenes longer than 15 seconds

## 13\. Ideas for v2

- A short epilogue room or alternate ending reflecting the consequence of taking (or refusing) the key
- A continuation of the story that starts at the moment the final door opens, if the game is well received
- Additional environmental notes for players who want deeper optional lore, without extending the critical path

## 14\. Development Timeline

| **Week**        | **Goal**                                                                                      |
| --------------- | --------------------------------------------------------------------------------------------- |
| 1 - 3           | Player movement, Health and Stamina systems                                                   |
| ---             | ---                                                                                           |
| 4-5             | Entry Hall + Kitchen geometry (no puzzles or items yet)                                       |
| ---             | ---                                                                                           |
| 6-7             | Pages and food pickup, pages viewer UI overlay                                                |
| ---             | ---                                                                                           |
| 8-9             | Key pickup and locked-door system (find key → door opens)                                     |
| ---             | ---                                                                                           |
| 10-11           | Screamer sequence scripted in the Living Room (appear, damage, disappear)                     |
| ---             | ---                                                                                           |
| 12-13           | Connect all 4 rooms; full playtest start-to-finish; recruit 2–3 external testers for feedback |
| ---             | ---                                                                                           |
| **14-15 (end)** | **Feature freeze — no new mechanics after this point**                                        |
| ---             | ---                                                                                           |
| 16-17           | Sound effects (footsteps, Screamer, ambience) and lighting polish                             |
| ---             | ---                                                                                           |
| 18-19           | Bug fixing, export build, publish to itch.io                                                  |
| ---             | ---                                                                                           |

## PART II — NARRATIVE DOCUMENT

## 15\. Premise & Themes

The house's former occupant, a man known only as **Lazy**, disappeared into voluntary isolation after years of starting things he never finished. The player, an unrelated stranger, arrives afterward and pieces together what happened to him — while something in the house responds to their presence exactly as if they were him.

**Central themes:**

- **Avoidance versus stillness.** Lazy believed silence and isolation would heal him; instead, removing all distraction left him alone with everything he had been outrunning.
- **The self as the real haunting.** The Screamer is never an external evil — it is explicitly the embodiment of everything Lazy abandoned: every unfinished project, every wasted year, every "not yet, later, wrong time."
- **Inherited consequence.** The player did nothing to earn the house's attention, yet it treats them as Lazy regardless — a story about how easily an unresolved burden can attach itself to whoever walks into its space next.
- **Taking the step.** To overcome fear and grow, you have to open the door, even when it hurts. It is like moving from primary school to high school, or choosing a university major: you decide by taking a step.

## 16\. Character Profile — Lazy

- **Age:** Early twenties.
- **Who he was:** An ordinary young man who never settled on what he wanted from life. He tried many paths and abandoned all of them early, chronically haunted by the sense that he was wasting time and should be achieving visible results faster.
- **The breaking point:** Exhausted by the pressure of that constant race, he cut himself off from everyone and retreated alone to the house, telling himself he only needed quiet to finally figure things out.
- **What happened:** He never left. Days of enforced stillness gave the parts of himself he'd spent years drowning out — in busywork, obligations, and helping everyone except himself — a voice he could no longer outrun.
- **His fate:** Implied, never explicitly shown. The final note is the last thing he wrote, addressed directly to whoever comes next.

## 17\. The Screamer as a Narrative Device

The Screamer is the physical form of everything Lazy abandoned — every dropped project, every wasted year, every moment he told himself "not yet, later, wrong time." It does not pursue the player out of malice; it manifests because it _is_ Lazy, the version of him that stayed behind in every unfinished thing.

Critically, **the player is not Lazy** — they are someone who found the house afterward — **but the Screamer does not know the difference.** This distinction should never be stated outright in-game; it exists in this document to guide tone, pacing, and any future writing (marketing copy, v2 content) so the metaphor stays consistent.

Design consequence: the Screamer should never be written or art-directed as a "monster" with independent goals. Every cue tied to it (the trigger, the blinding flash, the breathing, the lingering red screen blotches) should read as a _reaction_ to the player disturbing something Lazy left behind — not as a predator hunting them.

## 18\. The Notes

### Note #1 — Entry Hall

**Tone:** Calm, ordinary, almost cozy. The player should feel safe. No horror yet — just a person writing to himself.

Day 1. Took an open-ended leave from everything. Packed almost nothing — food for two weeks, my phone for emergencies, my laptop to write in. No plan beyond that.

I just drove. Six hours, give or take. No destination in mind. Then this house showed up, out in the middle of nowhere.

Strange — it's in better shape than it should be. Like someone still lives here. Or did, until recently.

I walked around the outside first. Nothing unusual, just old. Took me a while to work up the nerve to go in. Funny — I wanted to explore it more than I was afraid of it.

For the first time in years I have no deadline. No one waiting on me. No one to disappoint.

I think that's what I needed.

I used to think so.

### Note #2 — Living Room (found on the sofa)

**Tone:** The calm is starting to crack, but he's still rational. He notices something but explains it away.

Day 4, I think. Lost track a little.

It's quiet here. Too quiet, maybe — but that's what I came for, right?

I've been sleeping better. No notifications, no one needing anything from me. Just me and the sound of this house settling at night.

Although — I've started hearing it more than settling should sound like. Slow. Regular. Almost like breathing.

Am I going crazy...?

Old house. Old pipes. That's probably it.

I wonder how long this will last.

### Note #3 — Living Room (revealed after the bookshelf event; read right after Note #2)

**Tone:** Fear creeping in. He's no longer explaining it away — he's starting to believe something is wrong, and worse, that it might be coming from inside him.

Day 5. I moved the bookshelf in front of the back door last night.

I know how that sounds. I don't even know what I was protecting against. I just didn't want that door open anymore.

The breathing sound — it's not the house. I've stopped pretending.

It gets louder when I'm doing nothing. When I'm just sitting with my thoughts. Like it's reacting to me. Like it's been waiting for me to finally stop moving.

### Note #4 — Bedroom (revealed on the door after the candle is lit; final note)

**Tone:** The most emotionally raw. Written for whoever comes next. This is the last thing he wrote.

If you're reading this, I'm sorry — I don't know how to warn you properly.

I thought stopping would fix me. I thought if I just stayed still long enough, I'd finally figure out what I actually wanted. I was wrong.

I didn't expect stillness to have a voice.

After days of doing nothing but think, I stood in front of the mirror one night — and it wasn't a ghost looking back. It wasn't a monster. It was me.

I spent years drowning myself out — background noise, tasks, other people's problems. I helped everyone who ever needed me, and never once let anyone help me back.

Turns out silence doesn't heal you. It just waits until there's nothing left to hide behind.

The key is behind that door. Don't take it.

If you take it, it follows you out.

## 19\. Pacing & Emotional Arc

| **Room**    | **Emotional Register**      | **Player Should Feel**                                                                                              |
| ----------- | --------------------------- | ------------------------------------------------------------------------------------------------------------------- |
| Entry Hall  | Calm, safe, almost cozy     | Curiosity, no fear                                                                                                  |
| ---         | ---                         | ---                                                                                                                 |
| Kitchen     | Quiet unease                | Focus on the puzzle; a low hum of "something's a little off"                                                        |
| ---         | ---                         | ---                                                                                                                 |
| Living Room | Cracking calm → sudden fear | Rationalization gives way to a real scare — the game's single loud jolt                                             |
| ---         | ---                         | ---                                                                                                                 |
| Bedroom     | Raw, intimate dread         | Vulnerability (literal darkness), then quiet grief on reading the final note, then unresolved tension at the ending |
| ---         | ---                         | ---                                                                                                                 |

The game deliberately front-loads calm and back-loads dread — by design, there is only **one** overt scare in the entire experience (the Living Room encounter). Everything before and after it is atmosphere and story, so that single moment lands with full weight rather than being diluted by repeated jump scares.

## PART III — AUDIO DESIGN

## 20\. Sourcing Sounds

All sources below offer free-to-use assets suitable for a small indie production; always check the specific license on each individual file before use.

| **Source**        | **Best For**                     | **License**                      |
| ----------------- | -------------------------------- | -------------------------------- |
| freesound.org     | Everything — the largest library | CC, check each file individually |
| ---               | ---                              | ---                              |
| zapsplat.com      | High quality, consistent         | Free with account                |
| ---               | ---                              | ---                              |
| pixabay.com/music | Background ambience              | CC0, no attribution required     |
| ---               | ---                              | ---                              |
| soundsnap.com     | Footsteps, impacts               | 5 free downloads / month         |
| ---               | ---                              | ---                              |

**Useful search terms:**

- _Screamer:_ horror scream, creature shriek, distorted voice
- _Breathing:_ heavy breathing slow, monster breathing
- _Footsteps:_ footsteps wood floor, footsteps slow creak
- _Ambience:_ abandoned house wind, distant creak, silence hum
- _Door:_ old door creak, door unlock, door slam

## 21\. Sound Map

### Player Sounds

| **Sound**        | **Trigger**                       | **Notes**                            |
| ---------------- | --------------------------------- | ------------------------------------ |
| Footsteps (walk) | Player moves                      | Wood creak, low volume               |
| ---              | ---                               | ---                                  |
| Footsteps (run)  | Player sprints                    | Same sound, faster and louder        |
| ---              | ---                               | ---                                  |
| Pickup sound     | Player picks up an item           | Soft click or rustle                 |
| ---              | ---                               | ---                                  |
| Page turn        | Player reads a note               | Paper sound                          |
| ---              | ---                               | ---                                  |
| Match strike     | Player lights a match             | Single scratch + small flame crackle |
| ---              | ---                               | ---                                  |
| Torch ignite     | Torch lights                      | Whoosh + looping crackle             |
| ---              | ---                               | ---                                  |
| Eating           | Player eats food                  | Brief chew / swallow                 |
| ---              | ---                               | ---                                  |
| Taking damage    | Screamer hits player; fear damage | Sharp gasp or heartbeat thump        |
| ---              | ---                               | ---                                  |

### Screamer Sounds

| **Sound**       | **Trigger**                 | **Notes**                                                  |
| --------------- | --------------------------- | ---------------------------------------------------------- |
| The scream      | Screamer appears            | The loudest sound in the game — mix carefully, cap at −6dB |
| ---             | ---                         | ---                                                        |
| Heavy breathing | 10 seconds after the scream | Loops for 10 seconds, then fades out                       |
| ---             | ---                         | ---                                                        |
| Distant creak   | Random, every 60–90 seconds | Subtle; the player hears it and wonders. Never explained.  |
| ---             | ---                         | ---                                                        |

### Room Ambience (quiet background loops)

| **Room**    | **Ambience**                         | **Notes**                             |
| ----------- | ------------------------------------ | ------------------------------------- |
| Entry Hall  | Light wind outside, distant creak    | Calm, faintly eerie                   |
| ---         | ---                                  | ---                                   |
| Kitchen     | Dripping tap, flies                  | Suggests rot without ever showing it  |
| ---         | ---                                  | ---                                   |
| Living Room | Cold fireplace (no crackle), wind    | Empty, cold feeling                   |
| ---         | ---                                  | ---                                   |
| Bedroom     | Near-total silence, occasional creak | Silence reads scarier than noise here |
| ---         | ---                                  | ---                                   |

### UI Sounds

| **Sound**            | **Trigger**                                   | **Notes** |
| -------------------- | --------------------------------------------- | --------- |
| Door unlock          | Key used on a lock                            |           |
| ---                  | ---                                           | ---       |
| Journal open / close | Tab pressed                                   |           |
| ---                  | ---                                           | ---       |
| Low health warning   | Health drops below 25 — subtle heartbeat loop |           |
| ---                  | ---                                           | ---       |