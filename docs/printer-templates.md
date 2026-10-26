# Printer settings templates

`scripts/templates/<printer>/` holds `project_settings.config`, the Bambu Studio settings for one filament, plus `per_filament_keys.json`, which maps each per-filament key to its block size. On the P2S, per-filament keys hold 3 values (one per extruder variant), not 1.

`scripts/templates/P2S/end-gcode-melody.txt` is the author's personal end G-code with a finish melody. Keep it out of `project_settings.config` when building models to publish.

To add a printer, slice the same model twice with the bambu-studio-ai skill's `slice.py --printer <model>`: once with one filament and once with `--load-filaments` patched to load two. Store the one-filament config, then diff the two configs: the keys whose length doubled are the per-filament keys. Don't assume a block size of 1 per filament.
