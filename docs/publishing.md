# Publishing

## Publishing on MakerWorld

Keep the listing (name, category, tags, BOM, profiles, pictures, description) in `<project>/makerworld.md`, and add the MakerWorld link to the project README and the root README table once it's published. Link the GitHub folder as `https://github.com/artemnovichkov/3d-prints/tree/main/designs/<project>`.

- Upload `models/<project>.3mf`. MakerWorld lists plates from the plate thumbnails and slice info that Bambu Studio writes; `build-models.py` keeps them.
- A `.f3d` raw file is rejected without favourite user parameters (MakerWorld turns them into a customizer). Link the GitHub folder in the description instead.
- At least 3 real-life photos are required, plus a 4:3 cover (3:4 app cover optional). Strip EXIF/GPS from phone photos (`sips` to JPEG, then re-save with Pillow).
- The model form takes one print profile; add the others after publishing via ⋮ → Add Print Profile on the model page.

## Publishing on Printables

Keep the Printables listing in `<project>/printables.md` and link it next to MakerWorld in both READMEs. Printables has no customizer, so upload the `models/parts/` STLs, copied with names like `<project>-<variant>-<part>.stl`, in one folder per variant, plus the `.scad` and the main 3MF for Bambu users. Mention the `.scad` and the MakerWorld customizer in the description. Tags take only lower-case letters and digits.
