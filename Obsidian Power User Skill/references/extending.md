# Extending Obsidian

Everything beyond the core features: community plugins, themes, CSS snippets, the `obsidian://` URI scheme, the CLI, and headless syncing.

For deep coverage of specific community plugins (Dataview, Templater, Tasks), see `community-plugins.md`.

---

## 1. Community plugins

Where third-party extensions live. **Settings → Community plugins** — and the first thing you'll see is **Restricted mode**.

### Restricted mode

When on, no community plugin runs. New installs are gated.

- Default state for a fresh install (or for "Safe mode" recovery).
- Turn off only after reviewing what you're enabling.
- The trade-off is real: community plugins are JavaScript that runs locally and can read/write the vault. The Obsidian team reviews each plugin in the directory, but you're still trusting third-party code.

### Browsing and installing

- Settings → Community plugins → **Browse**.
- Search by name; filter by category, popularity, sort order.
- Click a plugin → see description, source repo, downloads, last update.
- Install → Enable.

### Updating plugins

- Settings → Community plugins → **Check for updates**.
- Updates are not automatic by default. Apply manually after eyeballing changelogs.

### Plugin permissions

There is no granular permission system. A plugin can read every file in the vault, write to any file, talk to the network, and store data in `.obsidian/plugins/<id>/data.json`. Before enabling a plugin, glance at:

- Source repo (linked from the plugin's page).
- Last release date — actively maintained?
- Open issues — are users reporting problems?

### Suggested community plugin starter pack

For a typical power user:

| Plugin | Purpose |
|---|---|
| **Dataview** | inline queries inside notes (covered in `community-plugins.md`) |
| **Templater** | dynamic templates with JS (covered in `community-plugins.md`) |
| **Tasks** | rich task syntax with due dates, recurrence (covered in `community-plugins.md`) |
| **Calendar** | sidebar calendar that opens daily notes |
| **Periodic Notes** | weekly/monthly/quarterly/yearly notes, sibling to Daily |
| **Excalidraw** | hand-drawn sketches and diagrams that live as `.excalidraw.md` |
| **Advanced URI** | richer `obsidian://` URIs (see §5 below) |
| **Style Settings** | UI knobs surfaced by themes that opt-in |
| **Iconize** | folder/note icons |
| **Outliner** | bullet-list power features (zoom, fold, drag) |

Mention only what fits the user's stated workflow — don't dump the full pack on a casual user.

---

## 2. Themes

A theme is a `theme.css` file in `.obsidian/themes/<ThemeName>/` plus a `manifest.json`.

- **Install**: Settings → Appearance → Themes → Manage → Browse → install.
- **Switch**: Settings → Appearance → Themes → pick one.
- **Light / dark variants**: some themes auto-switch with the system; others have separate light/dark CSS files.
- **Style Settings** plugin: many themes expose tunable variables (palette, body width, font) through Style Settings — install it once and many themes get instantly tweakable.

### Building a theme from scratch

The barest minimum:

```
.obsidian/themes/MyTheme/
├── manifest.json
└── theme.css
```

`manifest.json`:

```json
{
  "name": "MyTheme",
  "version": "1.0.0",
  "minAppVersion": "1.4.0",
  "author": "You",
  "authorUrl": "https://example.com"
}
```

Inside `theme.css`, override Obsidian's CSS variables. The full list lives in Obsidian's developer docs; the most commonly tuned:

```css
.theme-dark {
  --background-primary: #1d1d1d;
  --background-secondary: #232323;
  --text-normal: #e6e6e6;
  --text-muted: #9b9b9b;
  --interactive-accent: #4e7eff;
}
.theme-light {
  --background-primary: #fdfdfb;
  --background-secondary: #f4f4f0;
  --text-normal: #1a1a1a;
  --text-muted: #6b6b6b;
  --interactive-accent: #2e57c8;
}
```

---

## 3. CSS snippets

Smaller scope than themes. A snippet is a single `.css` file dropped in `.obsidian/snippets/`. Each snippet toggles independently in Settings → Appearance → CSS snippets.

### Anatomy

A snippet is plain CSS. Common targets:

- `.callout` — callout boxes.
- `.cm-line` — editor lines.
- `.markdown-rendered` — Reading view content.
- `.tag` — inline tags.
- `body.publish-mode` — when you want to scope styles to Publish only.

### Useful snippets (drop-in ready)

#### Wider notes

```css
/* .obsidian/snippets/wider.css */
.markdown-source-view.mod-cm6 .cm-content,
.markdown-reading-view {
  max-width: 920px !important;
}
```

#### Subtle callout palette

```css
/* .obsidian/snippets/callouts.css */
.callout[data-callout="note"]     { --callout-color: 80 110 200; }
.callout[data-callout="tip"]      { --callout-color: 80 180 140; }
.callout[data-callout="warning"]  { --callout-color: 220 160 60; }
.callout[data-callout="danger"]   { --callout-color: 220 80 80; }
.callout[data-callout="question"] { --callout-color: 160 80 200; }
.callout {
  border-radius: 8px;
  border-left-width: 4px;
}
```

#### Tag pill styling

```css
/* .obsidian/snippets/tags.css */
.tag {
  background: var(--background-secondary);
  border-radius: 999px;
  padding: 0 0.6em;
  font-size: 0.82em;
  letter-spacing: 0.02em;
  border: 1px solid var(--background-modifier-border);
}
```

#### Reading-view typography

```css
/* .obsidian/snippets/reading-type.css */
.markdown-reading-view {
  font-family: "iA Writer Quattro", Georgia, serif;
  line-height: 1.7;
  font-size: 17px;
}
.markdown-reading-view h1,
.markdown-reading-view h2,
.markdown-reading-view h3 {
  font-family: "Inter", system-ui, sans-serif;
  letter-spacing: -0.01em;
}
```

#### Page width via `cssclasses`

```yaml
---
cssclasses: [wide-page]
---
```

```css
/* .obsidian/snippets/wide-page.css */
.markdown-source-view.mod-cm6.wide-page .cm-content,
.markdown-reading-view.wide-page {
  max-width: 1100px !important;
}
```

`cssclasses` lets you opt notes into snippet styles individually — extremely flexible.

---

## 4. Plugin security in practice

- Use **Restricted mode** in any vault containing sensitive data until you're sure each plugin earns its place.
- Audit `.obsidian/plugins/` periodically — remove plugins you no longer use; they accumulate.
- Prefer plugins that work entirely offline; flag any plugin that requires an outbound API call.
- Mobile note: not every plugin works on mobile. The plugin's manifest declares mobile compatibility; if you live on iOS/Android, prioritize mobile-compatible plugins.

---

## 5. Obsidian URI — `obsidian://`

Protocol that lets external apps and links control Obsidian.

### Built-in actions

| URI | Behavior |
|---|---|
| `obsidian://open?vault=MyVault` | open a vault by name |
| `obsidian://open?vault=MyVault&file=Note%20Name` | open a specific note |
| `obsidian://open?path=/full/path/to/file.md` | open by absolute path |
| `obsidian://new?vault=MyVault&name=New%20Note&content=Hello` | create a new note |
| `obsidian://new?vault=MyVault&file=Path/Sub/Note&content=Hello` | create at a path |
| `obsidian://search?vault=MyVault&query=tag%3A%23project` | run a search |
| `obsidian://hook-get-address?vault=MyVault` | get a sharable URL hook (used by other apps) |

URL-encode any spaces (`%20`) or special characters in the query string.

### Examples

Open a specific note from anywhere:

```
obsidian://open?vault=MyVault&file=Projects%2FQ4%20GTM%20Plan%2F_README
```

Create a daily journal entry with seed content from a shortcut:

```
obsidian://new?vault=MyVault&file=Journal%2FDaily%2F2026-05-15&content=%23%23%20Morning%20notes%0A%0A-%20
```

Run a tagged search:

```
obsidian://search?vault=MyVault&query=tag%3A%23project%20status%3Aactive
```

### Use cases

- Bind a global system shortcut to "open today's daily note in Obsidian".
- Web Clipper appends a `obsidian://open` link to the clipped note as the "back to vault" anchor.
- Integrate with Raycast, Alfred, AutoHotkey, Shortcuts.app, KeyboardMaestro.

### Advanced URI plugin

For richer URIs (jump to a specific heading, append text, focus a specific pane), install the **Advanced URI** community plugin. It adds dozens of parameters to the `obsidian://` scheme.

---

## 6. Obsidian CLI

A first-party command-line tool that controls a vault from the terminal. Distributed separately from the desktop app.

Capabilities (subject to release availability):

- Open a note (`obsidian open <vault> <note>`).
- Create/append to a note from stdin or arguments.
- Trigger a publish push.
- Run arbitrary commands by command-id.

Use cases:

- Capture from any shell session (`echo "$(date) - thought" | obsidian append --vault MyVault --file Inbox.md`).
- CI jobs that update a "build status" note.
- Cron-driven backup scripts that touch the vault.

If the user mentions automation or shell workflows, suggest the CLI — and document the command they need.

---

## 7. Obsidian Headless

A headless mode for syncing without a display. Useful for:

- A small server that maintains a continuously-synced copy of the vault.
- CI pipelines that run analyses against the vault.
- Automated backups using the same sync engine as the app.

It's not for editing — it's for sync. Pair with the desktop app on your workstations and the headless instance keeps a server replica current.

Setup steps (high-level):

1. Install the headless binary (single executable distributed by Obsidian).
2. Authenticate against Obsidian Sync (one-time login, persisted token).
3. Start the daemon pointing at a local folder.
4. Sync runs continuously.

For ad-hoc backups without Sync, simpler options exist: cron + `rsync`, or Git. Headless's value is matching the conflict-resolution behavior of the desktop client.

---

## 8. The skill's posture toward extending Obsidian

- **Core first.** Most asks can be solved with core plugins + good frontmatter + Bases. Only suggest a community plugin when it materially extends what core can do.
- **Disclose what's community vs. core.** Always label Dataview, Templater, Tasks as community plugins so the user knows what they're installing.
- **Prefer one good plugin over three overlapping ones.** Dataview + Bases overlap; recommend one or the other based on the use case, not both.
- **CSS snippets over forks of themes.** If the user wants a small tweak, a snippet is reversible; forking a theme is overkill.
- **URIs and CLI for automation, not as a substitute for normal workflow.** They're powerful but introduce surface area; suggest them when the user explicitly mentions automation, shortcuts, Raycast, Alfred, scripts.
