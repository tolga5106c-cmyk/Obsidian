# User Interface

Everything visible on screen, and how to bend it to the user's preference.

## 1. Appearance

**Settings → Appearance**. The cosmetics layer.

- *Base theme*: System / Light / Dark. Toggle command: "Toggle light/dark theme" (hotkey it).
- *Theme*: dropdown of installed themes. Click "Manage" → "Browse" to install from the community theme directory.
- *Translucent window* (mac/Win 11): semi-transparent background.
- *Font*:
  - *Interface font* — the UI everywhere.
  - *Text font* — the body of notes.
  - *Monospace font* — code blocks and inline `code`.
  - Picks any system-installed font.
- *Font size*: scales the whole UI; `Ctrl/Cmd +` and `Ctrl/Cmd -` zoom on the fly.
- *Accent color*: a single hex/HSL slider that drives selected-link color, callouts where appropriate, and various highlights.
- *CSS snippets*: a list of every `.css` file in `.obsidian/snippets/` with a toggle each. See `extending.md` for snippet authoring.

### Quick theme picks worth knowing

| Theme | Best for |
|---|---|
| **Minimal** | clean writing, lots of typography tuning |
| **Things** | Things 3-inspired, soft pastels |
| **Catppuccin** | popular dev aesthetic, many color flavors |
| **AnuPpuccin** | Catppuccin + extended UI tweaks |
| **California Coast** | warm, journaling-friendly |

(These are community themes — install through Appearance → Manage → Browse.)

## 2. Drag and drop

- **Files** — drag from File Explorer into the editor to insert an embed/link. Drag from OS file manager into the editor to copy the file into the vault as an attachment and insert a link.
- **Tabs** — drag a tab onto the edge of a pane to split. Drag onto an empty area to make a pop-out window.
- **Sidebar items** — drag panels (Outline, Backlinks, etc.) between left and right sidebars, or stack them.

## 3. Hotkeys

**Settings → Hotkeys**. Every command in Obsidian — core, community, plugin-defined — appears here, searchable.

Procedure:

1. Find the command (search bar).
2. Click the `+` next to its row.
3. Press the key combination.
4. Obsidian checks for conflicts and shows them inline.

Hotkey conventions Claude recommends:

| Action | Suggested |
|---|---|
| Open today's daily note | `Ctrl/Cmd+T` |
| Open Quick Switcher | `Ctrl/Cmd+O` (default) |
| Open Command Palette | `Ctrl/Cmd+P` (default) |
| Toggle Backlinks pane | `Ctrl/Cmd+Shift+B` |
| Open Bookmarks pane | `Ctrl/Cmd+B` |
| Insert template | `Ctrl/Cmd+;` |
| Toggle dark mode | `Ctrl/Cmd+Shift+L` |
| New canvas | `Ctrl/Cmd+Shift+C` |
| Open graph view | `Ctrl/Cmd+G` |

Saved in `.obsidian/hotkeys.json` — portable across machines.

## 4. Language

**Settings → About → Language**. Changes the interface language. Notes themselves are untouched — they're whatever you typed.

## 5. Pop-out windows

Right-click a tab → **Move to new window**, or drag the tab off the main window. Each window has its own pane layout. Useful for:

- Dual-monitor: notes on one screen, canvas on another.
- "Reference window" — a single note pinned for the whole session.

`Ctrl/Cmd+Shift+N` (or assigned hotkey) opens a new empty window on the current vault.

## 6. Ribbon

The vertical icon strip on the far left.

- Toggle visibility per-icon via the gear at the bottom of the ribbon.
- Reorder via drag.
- Plugins surface their commands here; you can pin/unpin to keep it tidy.
- Hide the ribbon entirely with Command Palette → "Toggle ribbon" if you want max focus.

## 7. Settings modal

Sections (top-to-bottom):

- *Options*: Editor, Files & Links, Appearance, Hotkeys, About.
- *Core plugins*: each core plugin's settings.
- *Community plugins*: each installed community plugin's settings, plus the Browse + Restricted mode panel.

Always-useful tweaks in **Editor**:

- *Line wrap*: ON for prose, OFF for code-like notes.
- *Strict line breaks*: OFF (single line break = paragraph break in OFM by default — turn this ON only if writing strict CommonMark).
- *Show line numbers*: OFF for prose, ON for code-heavy notes.
- *Vim key bindings*: ON if you're a vim user.

## 8. Sidebars

Two sidebars (left, right). Each holds tabs (Outline, Backlinks, Tag Pane, Files, Plugin panels...).

- Collapse with the chevron at the top.
- Hotkey: `Ctrl/Cmd+Alt+Left` / `Ctrl/Cmd+Alt+Right` toggle the sidebars.
- Pin a pane by dragging it into the sidebar; collapse it into a vertical tab strip.
- Move panes between sidebars by dragging the tab.

## 9. Status bar

The bottom strip. Each surface (plugin) places its info here:

- Word Count → words, chars, selection word count.
- Sync → up-to-date / syncing status (if Obsidian Sync is on).
- Templater → last template applied (if relevant).
- Tasks → open task count (if Tasks plugin is enabled).

Right-click the status bar to show/hide individual items.

## 10. Tabs

- Open in new tab: middle-click a link, or `Ctrl/Cmd+click`.
- Open in split pane: `Ctrl/Cmd+Alt+click` on a link.
- Split vertically: right-click a tab → "Split right".
- Split horizontally: right-click a tab → "Split down".
- **Stacked tabs** (Andy Matuschak mode): View → "Toggle stacked tabs". Each tab opens to the right of the previous one, all visible at once. Best for working through a chain of linked notes.
- **Pin a tab**: right-click → Pin. Pinned tabs don't get replaced when you click another link; the link opens in a new tab instead.

## 11. Workspace

The combination of *which panes are visible, which tabs are open, and what's in each*. This is the thing the Workspaces core plugin saves and restores by name.

Typical workspaces a user maintains:

- *Writing* — single editor pane + Outline pinned right.
- *Researching* — editor + Web Viewer + Backlinks.
- *Reviewing* — graph + outline + open notes from yesterday/today.
- *Daily* — today's daily note + weekly note + agenda Base.

Save with "Workspaces: Save layout"; load with "Workspaces: Load workspace". Bind both to hotkeys for instant context switches.

## 12. Visual hierarchy tips Claude follows when recommending UI tweaks

1. Reduce noise before adding color. Hide the ribbon you don't use; collapse sidebars when typing; turn off slash commands if you live on hotkeys.
2. Pick **one** theme and stick with it for a while. The constant switching tax is real.
3. The single biggest readability lever is **interface font** + **text font** + **monospace font** chosen together. A great combo: SF Pro / iA Writer Quattro / JetBrains Mono.
4. Accent color should differ enough from the body text to register but not so much that it screams. Most well-designed themes get this right out of the box.
5. Use CSS snippets for last-mile polish (custom callout colors, narrower body width on Publish, larger property labels) — not for re-styling the whole app. That's what themes are for.
