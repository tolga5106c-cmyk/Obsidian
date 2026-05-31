# Core Plugins

Core plugins ship with Obsidian. They're toggled in **Settings → Core plugins**. This reference covers every core plugin — configuration knobs, hotkeys, and how to use them well.

Order roughly matches Obsidian's own settings list.

---

## Audio Recorder

Records short audio notes directly into the vault. The mic icon appears in the ribbon when enabled.

- *Recording format*: `webm` (default) or `mp3`. mp3 needs a working ffmpeg-style codec.
- *New recording filename*: `Recording YYYYMMDDHHmmss`.
- *Folder*: defaults to the attachments folder set in Settings → Files & Links.
- Workflow tip: click the mic to start, click again to stop, the file is auto-linked into the active note at the cursor position.

---

## Backlinks

The shows-who-references-this pane. Two display modes:

- **Pane**: dedicated sidebar showing backlinks to the current note.
- **In-document footer**: appended at the bottom of the note in Reading view. Toggle in Settings → Backlinks → "Backlink in document".

Each backlink groups:

- *Linked mentions* — explicit `[[wikilinks]]` to this note.
- *Unlinked mentions* — plain-text occurrences of the note's title/aliases. Click "Link" to convert.

Hotkey: `Ctrl/Cmd+Shift+B` opens the backlinks pane.

---

## Bookmarks

Replaces the older "Starred" plugin. Bookmarks anything — notes, headings, blocks, searches, graph views, files, web pages (with Web Viewer).

- Organize in folders ("groups").
- Drag-and-drop to reorder.
- Right-click in the bookmarks pane → New bookmark → choose type.
- Hotkey suggestion: assign `Ctrl/Cmd+B` to "Bookmarks: Show bookmarks".

---

## Canvas

See `canvas.md` for the full `.canvas` JSON spec and complete examples. Enable this plugin to create `.canvas` files via File → New canvas.

---

## Command Palette

The keyboard-driven everything-launcher. Default hotkey: `Ctrl/Cmd+P`.

- Fuzzy-search every command across core plugins, community plugins, and your custom hotkeys.
- Pin frequently used commands (gear icon in the palette) for top placement.
- The palette also surfaces theme switching, plugin toggling, and editor commands.

---

## Daily Notes

The journaling backbone.

- *Date format*: defaults to `YYYY-MM-DD`. Use Moment.js tokens (`YYYY-[W]ww` for week, `[Q]Q-YYYY` for quarter).
- *New file location*: which folder to put daily notes in. Supports a fixed folder or a folder pattern (set in Templater or via Periodic Notes community plugin).
- *Template file location*: path to a markdown file (or Templater template) used when creating a new daily note.
- *Open daily note on startup*: ON for daily journalers, OFF for occasional.
- Command: "Daily notes: Open today's daily note" — hotkey it to `Ctrl/Cmd+T` or similar.
- "Go to previous/next daily note" navigates by adjacent dated file.

---

## File Explorer

The left sidebar tree.

- Right-click a folder for: New note, New folder, Set as default folder for new notes, Show in system explorer (Reveal in Finder), Duplicate, Move, Rename, Delete.
- Drag-and-drop notes between folders — links update automatically (if "Automatically update internal links" is ON in Settings → Files & Links).
- *Sort order*: file name (A→Z, Z→A), modified time, created time. Per-folder via the gear icon.
- Multi-select with `Shift+click` or `Ctrl/Cmd+click`.

---

## File Recovery

A safety net against the worst editing accident.

- Saves automatic snapshots of every modified note.
- *Snapshot interval*: how often to capture (default 5 min).
- *Retention*: how long to keep snapshots (default 7 days).
- Access via Command Palette → "File recovery: Open" → pick a file and a timestamp → restore.
- Snapshots live in `.obsidian/file-recovery/` (binary store; doesn't bloat your sync naively if you exclude it).

---

## Format Converter

Converts legacy markdown variants into Obsidian-flavored markdown.

- Converts `[note title](note%20title.md)` style links → `[[note title]]`.
- Converts `==highlight==` from other apps if needed.
- Useful right after importing from a different markdown app.
- Run via Command Palette → "Format converter: Convert...".

---

## Graph View

Two graphs:

- **Global graph** — every note as a node, every link as an edge. Hotkey `Ctrl/Cmd+G`.
- **Local graph** — neighbors of the current note. Command Palette → "Open local graph in new pane".

Controls in the graph filter panel:

- *Filters*: search query (limits which notes appear), show/hide tags, attachments, existing-only, orphans.
- *Groups*: color subgraphs by query (e.g., `path:Projects` → orange).
- *Display*: arrows on links, node text fade threshold, node size based on incoming links.
- *Forces*: center force, repel force, link force, link distance.

The most useful single setting: **Groups by path/tag** — gives instant visual structure to a sprawling graph.

---

## Note Composer

Two commands worth their weight:

- **Merge file with another**: pick a target note, the current note's content is appended to it, the current file is deleted, all incoming links to it are redirected.
- **Extract current selection**: cuts the selected text into a new note, leaves a `[[link]]` in its place. Configurable template file for the new note.

---

## Outgoing Links

The mirror of Backlinks. Pane shows every link going *out* of the current note, plus unlinked mentions inside the current note for other notes that might be worth linking.

---

## Outline

A live, clickable headings panel for the current note. Toggle the pane in the right sidebar. Best for long notes (essays, RFCs).

---

## Page Preview

Hover any internal link with `Ctrl/Cmd` held down to see a preview of the target. Settings let you also enable hover-preview from the file explorer, the graph view, the search results, etc.

Turn this off if previews feel jittery on slow disks.

---

## Properties View

A panel for browsing all properties used in the vault and the type Obsidian has inferred for each. From this view you can:

- Rename a property across the entire vault (refactor `tag` → `tags`).
- Change a property's type (turn `priority` from text into number — and Obsidian re-parses it everywhere).
- Add a property to the current note from the type list.

Properties are typed in `.obsidian/types.json` — that file is human-readable if you want to audit it.

---

## Quick Switcher

The "jump to any note" launcher. Hotkey: `Ctrl/Cmd+O`.

- Fuzzy match across filenames + aliases.
- Press Enter to open the matched note, or `Shift+Enter` to create a new note with the typed title.
- Append `#` to the query to switch to a heading within a matched note.

This is the single most-used command in Obsidian. Make sure all aliases are well-curated.

---

## Random Note

Opens a randomly chosen note from the vault. Surprisingly useful for serendipitous re-encountering of old notes (the Zettelkasten "review" practice). Bind to a hotkey if used often.

---

## Search

Full-text search across the vault. Hotkey: `Ctrl/Cmd+Shift+F`.

### Operators

| Operator | Matches |
|---|---|
| `path:Projects` | notes whose path contains `Projects` |
| `file:README` | notes whose filename contains `README` |
| `tag:#project` | tagged with `#project` |
| `tag:#project/active` | nested-tag aware |
| `line:(foo bar)` | both terms in the same line |
| `block:(foo bar)` | both terms in the same block |
| `section:(foo bar)` | both terms in the same H-section |
| `content:(foo)` | search only body, not frontmatter |
| `task:foo` | inside open tasks (`- [ ]`) |
| `task-done:foo` | inside completed tasks (`- [x]`) |
| `task-todo:foo` | open task containing query |
| `"exact phrase"` | exact match |
| `-foo` | exclude |
| `/regex/` | regex (with optional `/i` for case-insensitive) |
| `match-case:foo` | case-sensitive match (alternative to regex) |

### Combinators

```
path:Projects tag:#active -tag:#archived
```

Multiple terms AND together. Use `OR` (uppercase) for OR. Group with parentheses.

### Embedding results

Search results can be embedded into a note as a live block:

````markdown
```query
path:Projects tag:#active
```
````

Renders as a live, clickable list inside the note. Use this for lightweight dashboards when you don't need Bases.

---

## Slash Commands

Type `/` while editing → a popup of editor commands (insert table, insert callout, insert link, etc.). Toggleable per-command. Power users often disable this in favor of hotkeys; new users find it discoverable.

---

## Slides

Turns a markdown note into a slide deck. Slides are separated by `---` on its own line.

```markdown
# Title slide

---

## Slide 2

- bullet
- bullet

---

## Slide 3

> [!QUOTE] Pull-quote here
```

Run "Slides: Start presentation" from the command palette. Arrow keys / spacebar advance. `Esc` exits.

The slide renderer respects callouts, images, embeds, and code blocks — useful for technical talks straight out of a vault.

---

## Tags View

Browses all tags used in the vault. Hierarchical (nested tags show as tree). Click a tag to filter the search to just notes with that tag. Rename a tag here to rename it across all notes that use it.

---

## Templates

Static template insertion. The lighter-weight cousin of Templater.

- *Template folder location*: where templates live (typically `_Templates/`).
- *Date format*: tokens used inside templates.
- *Time format*: same.

Built-in tokens:

| Token | Replaced with |
|---|---|
| `{{title}}` | current note's title (filename minus `.md`) |
| `{{date}}` | current date (using the Date format) |
| `{{time}}` | current time |
| `{{date:YYYY-MM-DD}}` | inline format override |
| `{{time:HH:mm}}` | inline format override |

Insert via Command Palette → "Templates: Insert template" → pick the template.

For dynamic logic (conditionals, prompts, user functions), reach for the **Templater** community plugin — see `community-plugins.md`.

---

## Unique Note Creator

Creates a new note with a timestamped prefix — the canonical Zettelkasten pattern.

- *Date format*: defaults to `YYYYMMDDHHmm` — sortable and collision-resistant.
- *Folder for new notes*: where unique notes land.
- *Template*: optional template applied at creation time.
- Filename pattern: `<prefix> — <title>.md`.

Bind to a hotkey for instant capture.

---

## Web Viewer

Lets you open a URL inside an Obsidian pane (built-in browser). Useful for:

- Researching alongside a note without leaving the app.
- Bookmarking pages (combined with the Bookmarks plugin).
- Clipping the page using Web Clipper.

Open a URL via Command Palette → "Web viewer: Open URL" or via a bookmark.

---

## Word Count

Shows the current note's word count in the status bar (bottom-right). Hovering shows total characters and selected text count. The full-vault word count is available via Command Palette → "Word count: Show vault statistics".

---

## Workspaces

Saves and restores entire pane layouts — every open tab, sidebar state, graph filter — under a name.

- Save: Command Palette → "Workspaces: Save layout".
- Load: Command Palette → "Workspaces: Load workspace" → pick.
- Use cases:
  - "Writing" workspace: one editor pane, outline on the right, no graph.
  - "Reviewing" workspace: graph view, backlinks, outline.
  - "Daily" workspace: today's daily note in center, weekly note on the right.

Workspaces live in `.obsidian/workspaces.json`.

---

## Suggested core-plugin defaults this skill recommends

For a typical PKM user, enable:

```
Audio Recorder, Backlinks, Bookmarks, Canvas, Command Palette, Daily Notes,
File Explorer, File Recovery, Graph View, Note Composer, Outgoing Links,
Outline, Page Preview, Properties View, Quick Switcher, Search,
Tags View, Templates, Word Count, Workspaces
```

Optional based on use case:

- *Random Note* — for active-recall practices.
- *Unique Note Creator* — for Zettelkasten users.
- *Slides* — when presenting from a note is part of the workflow.
- *Format Converter* — after a migration only.
- *Web Viewer* — for research-heavy workflows; otherwise it can feel busy.
- *Slash Commands* — taste; new users on, vets off.
