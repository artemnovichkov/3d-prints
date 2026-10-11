# MakerWorld publishing plan

## Research summary (2026-10-11)

### Similar models

| Model | Downloads / likes | Notes |
|---|---|---|
| [Perpetual Desk Calendar – Infinity](https://makerworld.com/en/models/2760237) | 2.3k / 4.4k | Closest competitor: white plate, pegs, black rings, stand. Profiles: EN / ES / PT (P2S). 0.2 mm nozzle recommended |
| [PERPETUAL CALENDAR](https://makerworld.com/en/models/3205445) | 2.1k / 4.9k | Staff pick. 9 profiles: full print / hybrid / fast / single-colour / per language. Has video |
| [Ring-a-date](https://makerworld.com/en/models/1170513) | 3.2k / 2.4k | Strong story (1970s MoMA design remake). Non-AMS path via M600 pause |
| [Desk Calendar – Reusable](https://makerworld.com/en/models/2986708) | 0.5k / 0.7k | Ring calendar, 6 profiles incl. Russian |
| ["Date Keeper"](https://makerworld.com/en/models/115260) | 15.7k / 9.1k | 2024 calendar contest winner, staff pick |
| [Customizable parametric calendar](https://makerworld.com/en/models/511591) | 53 / 232 customizations | Only PMM calendar. Usage happens via Customize, not downloads |
| PMM references: [2651953](https://makerworld.com/en/models/2651953), [1699192](https://makerworld.com/en/models/1699192), [3026224](https://makerworld.com/en/models/3026224), [1284229](https://makerworld.com/en/models/1284229) | 8–34k | Profiles are example outputs, "Make Your Model" button |

### Conventions

- **Description:** 1–2 sentence hook → emoji feature bullets → how to use → print notes (supports, layer, nozzle, non-AMS pause) → call to post a make / Boost. PMM models add "what you can customize" and how to export parts separately. 150–400 words, friendly, 5–10 emoji.
- **Images:** 4–8. Cover is a real photo in context (desk, hands), sometimes with a title overlay. Then close-ups, colour variants, customizer screenshots, plate shots. Renders only as secondary. Cover 4:3.
- **Profiles:** named by variant ("English", "Russian version", "Example Only – Use the Customize Button"). One per language is the most common pattern. Separate ring plate is normal. Each profile needs ≥1 real photo of that print.
- **Categories:** Decor + Household, or Office + Household.
- **Tags (8–18):** calendar, perpetual calendar, desk calendar, ring calendar, office, home decor, minimalist, gift, customizable, parametric, openscad.
- **Licence:** most use Standard Digital File License; CC options exist (511591 uses CC BY). Pick CC BY-NC-SA explicitly.

### Positioning vs 2760237

Lead with what it lacks: fully parametric (any language, font, Mon/Sun week start, ring clearance), flush two-colour inlay, fits A1 mini, single plate + rings.

## Plan

1. **Model changes**
   - [x] Labels centred on baseline + x-height / cap height instead of `valign = "center"` (labels with descenders jumped).
   - [x] Layout centred on origin (PMM bed centre), .scad + .f3d.
2. Rebuild: `python3 scripts/build-models.py ringlet-calendar`, update renders in `images/`, commit `models/`.
3. [x] EN/RU render, parts, centring, parameter groups OK in PMM. Check `.scad` in PMM: Nunito available, render time OK, `part` dropdown works. Optionally `color()` on final bodies / `mw_plate_N()` (costs STL download).
4. Print each planned profile, take real photos (cover in desk context, close-up of inlay text, ring on peg, hands moving a ring, size reference).
5. Render extra images: cover 1600×1200, EN / RU / Sunday variants, customizer screenshot.
6. Write `makerworld.md`: title, EN description, tags, categories, licence, profile names and summaries.
7. Publish: upload `.scad` + 3MF, images, fill form, add profiles with photos. User clicks Publish.
8. After publish: add MakerWorld link to README.

### Draft profiles

- English · Monday · 2 plates (calendar + rings)
- English · Sunday · 2 plates
- Russian · Monday · 2 plates
- No AMS · raised text, pause at first text layer (`models/ringlet-calendar-no-ams.3mf`)

### Draft title

"Ringlet – Customizable Perpetual Ring Calendar"

## Unresolved questions

- More model changes?
- Print photos exist?
- 3 language profiles or EN only?
- Description EN only or EN+RU?
- PMM colours/plates (`color()`, `mw_plate_N`) — do or skip?
