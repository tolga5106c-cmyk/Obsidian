# Importing Notes Into Obsidian

The **Importer** community plugin (by Obsidian's team — install from Settings → Community plugins → Browse → "Importer") supports most of the sources below. Anything not covered by Importer has its own path; Claude points to that path explicitly.

General approach the skill recommends:

1. Pick the destination folder *before* importing — typically a new top-level `Imports/<Source>/` folder so you can audit the result before merging into the main vault.
2. Run Format Converter (core plugin) afterward to normalize any non-Obsidian link syntax.
3. Open the imported set, run a quick sweep with `tag:#imported` to confirm everything is tagged for future cleanup, then file/merge.

---

## Apple Notes

- **Via Importer plugin** → Apple Notes (macOS only).
- Preserves: text, basic formatting (bold/italic), checkboxes, lists, attachments.
- Limitations: handwritten ink → static images; some table layouts may flatten.
- Output: one `.md` per Apple note, plus an `attachments/` folder.

For Windows/Linux users with iCloud Notes: there's no first-party path. The most reliable workaround is to forward each note to yourself as an email or copy/paste manually.

---

## Bear

- **Via Importer plugin** → Bear.
- Preserves: nested tags, attachments, links between notes (converted to `[[wikilinks]]`).
- Bear `#tag/subtag` becomes Obsidian `#tag/subtag`.
- Bear cross-note links become `[[wikilinks]]`.

---

## Craft

- Craft's export is markdown via the app's export menu (Document → Export As → Markdown).
- Move the resulting folder of `.md` files into a new vault (or vault subfolder).
- Run Format Converter to clean up Craft-specific link styles.

---

## Evernote

- **Via Importer plugin** → Evernote.
- Input: `.enex` files (Evernote's export format). Export from Evernote desktop: File → Export Notes.
- Preserves: text, basic formatting, attachments, creation/modification dates (stored as frontmatter), notebook → folder mapping, tags.
- Limitations: nested attachments inside complex tables may flatten.

---

## Google Keep

- **Via Importer plugin** → Google Keep.
- Input: a Google Takeout export (Takeout → Google Keep → JSON).
- Each Keep note → `.md` with tags preserved and attachments downloaded.
- Pinned notes are tagged `#pinned` for filtering.

---

## Microsoft OneNote

- **Via Importer plugin** → OneNote.
- Input: OneNote `.onepkg` or `.one` files (export from OneNote desktop).
- Preserves: page hierarchy → folder hierarchy, basic formatting.
- Limitations: complex OneNote layouts (free-positioned text boxes, ink drawings) don't have a perfect markdown analog; positions are linearized top-to-bottom.

---

## Notion

- **Via Importer plugin** → Notion.
- Input: a Notion export (Notion → ⋯ → Export → Markdown & CSV).
  - **Important**: choose "Markdown & CSV", not "HTML". Toggle "Include subpages" ON.
- Preserves: page hierarchy → folder structure, properties → YAML frontmatter, databases → CSV files (and the Importer converts each row into a note with the columns as frontmatter), cover images, attachments.
- Internal Notion links become `[[wikilinks]]` once Format Converter is run.
- Common cleanup after import:
  - Property names from Notion may use spaces — Importer preserves them. Decide whether to rename to underscored/lowercase form via Properties View.
  - Remove the Notion-style page-ID suffixes from filenames (the plugin offers an option to strip them; turn it on).

---

## Roam Research

- **Via Importer plugin** → Roam Research.
- Input: a Roam JSON export (Roam → … menu → Export All → JSON).
- Preserves: pages (→ notes), block references, page references (→ wikilinks), nested bullets, daily notes.
- Block references in Roam → block-id wikilinks in Obsidian (the importer assigns `^block-id`s and rewrites refs).

---

## CSV files

- **Use a Templater script or the Importer's CSV mode** if the importer supports it for your case.
- Manual path: each row → one note. Columns → YAML frontmatter properties. Use a python/JS script or the `csv-to-md` community plugin.
- Best when you have a structured list (book list, contacts, tickets) you want to live as one-note-per-row to take advantage of Bases.

---

## HTML files

- **Via the Web Clipper extension** for one-off HTML pages.
- **Via the Importer plugin** for bulk HTML folders (e.g., an exported Evernote `.html`).
- Use Pandoc as a fallback: `pandoc input.html -o output.md` per file or scripted across a directory.

---

## Markdown files

- The simplest case. Just copy the `.md` files into the vault folder.
- If the source used a non-Obsidian link flavor (e.g., `[Title](Title.md)` instead of `[[Title]]`), run Format Converter afterward.
- Frontmatter from other tools (Jekyll, Hugo, Quartz) is preserved as-is, which is usually what you want.

---

## Textbundle files

- **Via the Importer plugin** or by extracting the `.textbundle` (it's a directory with a `text.md` and an `assets/` folder).
- Common with Ulysses and iA Writer exports.

---

## Zettelkasten notes (from The Archive, Zettlr, Sublimeless_ZK, etc.)

- Most Zettelkasten apps already export `.md` with timestamped filenames and `[[link]]` syntax — drop them in.
- If the source uses `§foo` or `@id` link style, run a find-and-replace pass (Format Converter can help) or write a one-off regex script.

---

## Apple Journal (iOS)

- Apple Journal doesn't currently expose an export format. The workaround:
  1. Use the iOS Share sheet on each journal entry → Notes → Save to Apple Notes.
  2. Then import from Apple Notes via the Importer plugin.
- For ongoing flow, consider replacing Apple Journal with Obsidian's own Daily Notes (with Templater) to stay in one system.

---

## Post-import checklist

Apply this after every bulk import:

1. **Tag the import** — add `#imported/<source>` to every imported file (find-and-replace, or the Importer's option).
2. **Spot-check formatting** — open 5–10 random imported notes, look for broken syntax, mangled tables, missing attachments.
3. **Run Format Converter** — Command Palette → "Format converter: Convert markdown links to wikilinks".
4. **Verify attachments** — check that `![[image.png]]` references resolve. If not, the attachment folder probably needs to be set in Settings → Files & Links.
5. **Build a quick Base** — make a temporary `.base` filtering `file.inFolder("Imports")` so you can review the import as a table.
6. **Merge into the main vault** — once happy, drag folders out of `Imports/` into their final PARA/Zettel/etc. locations. Internal links update automatically if "Automatically update internal links" is ON.
7. **Delete the `Imports/` folder** when the migration is done.

## Things to warn the user about

- **Image-heavy imports double the vault size.** OneNote and Evernote exports can be huge. Consider storing attachments on a separate drive via a symlink before importing.
- **Block references survive only if the source supported them.** Roam and Logseq are the only common sources where block refs round-trip. Notion, Bear, Evernote, etc. produce best-effort `[[wikilinks]]` to the *page*, not the block.
- **Property names often need cleanup.** Notion uses "Date Created", "Last Edited Time"; Obsidian convention is `created`, `modified`. Use the Properties View to rename in bulk.
- **Some links won't resolve immediately.** If the source had ambiguous link text or used IDs, expect a small number of red links after import — fixable with a quick "Find and replace" or by renaming target notes' aliases.
