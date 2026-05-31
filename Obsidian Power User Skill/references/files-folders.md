# Files, Folders, and Vault Structure

A vault is a folder. Notes are plaintext `.md` files. Everything else is data sitting next to them. No proprietary format, no lock-in, fully portable.

## 1. Accepted file formats

| Category | Extensions |
|---|---|
| Notes | `.md` |
| Database | `.base` |
| Canvas | `.canvas` |
| Documents | `.pdf` |
| Images | `.png` `.jpg` `.jpeg` `.gif` `.svg` `.webp` `.bmp` |
| Audio | `.mp3` `.wav` `.ogg` `.m4a` `.flac` |
| Video | `.mp4` `.webm` `.ogv` `.mov` `.mkv` |

Anything else is treated as an "unsupported attachment" — it still lives in the vault and can be referenced, just not previewed inside Obsidian.

## 2. The `.obsidian/` configuration folder

Every vault has a `.obsidian/` directory at its root. This is the vault's brain.

```
.obsidian/
├── app.json              core settings (line numbers, file recovery interval, etc.)
├── appearance.json       theme, font sizes, accent color, CSS snippet states
├── hotkeys.json          user-customized key bindings
├── workspace.json        current tab/pane layout
├── workspaces.json       named saved workspaces
├── core-plugins.json     which core plugins are enabled
├── core-plugins-migration.json
├── community-plugins.json  list of installed community plugin IDs
├── graph.json            graph view settings (forces, filters, groups)
├── canvas.json           canvas defaults
├── bookmarks.json        the bookmarks plugin's data
├── types.json            property types registry
├── plugins/              one folder per installed community plugin
│   └── dataview/
│       ├── main.js
│       ├── manifest.json
│       └── data.json     plugin's own settings
├── snippets/             user CSS — every .css file here is selectable in Settings
│   └── my-callouts.css
└── themes/               installed community themes
    └── Minimal/
        ├── manifest.json
        └── theme.css
```

To share a vault setup, copy `.obsidian/` alongside the notes. To wipe and start fresh, delete it — the next launch will recreate defaults.

## 3. Local-first, plaintext, portable

- **Local-first**: vault lives on the filesystem. No required cloud, no required account.
- **Plaintext**: `.md` files open in any text editor, viewer, or static site generator.
- **Portable**: drag the folder anywhere. Open the same vault from desktop or mobile.
- **Symlink-friendly**: Obsidian follows OS symbolic links and junctions. Useful for keeping a single "Inbox" folder shared between vaults, or for storing attachments on a separate drive.

## 4. Vault archetypes

Six battle-tested structures. For each: tree diagram + `mkdir -p` script. Recommend based on the user's stated use.

---

### 4.1 Personal PKM (general purpose)

The "starter" vault. Optimized for thought capture and easy retrieval.

```text
MyVault/
├── 00 — Inbox/              quick capture; triage to other folders weekly
├── 10 — Notes/              evergreen notes, atomic, internally linked
├── 20 — Journal/
│   └── Daily/
│       └── 2026/
│           └── 05/
├── 30 — People/             one note per person, with `aliases:`
├── 40 — Projects/           one folder per active project
├── 50 — Areas/              ongoing responsibilities (Health, Finance, ...)
├── 60 — Resources/          reference material; books, articles, snippets
├── 70 — Archive/            completed / dormant
├── 80 — Attachments/        media; configured as default attachment location
├── 90 — MOCs/               Maps of Content
└── _Templates/              note templates
```

```bash
mkdir -p MyVault/{00\ —\ Inbox,10\ —\ Notes,20\ —\ Journal/Daily/2026/05,30\ —\ People,40\ —\ Projects,50\ —\ Areas,60\ —\ Resources,70\ —\ Archive,80\ —\ Attachments,90\ —\ MOCs,_Templates}
```

---

### 4.2 Zettelkasten (research, slow writing)

Atomic notes, unique timestamped IDs, ruthless linking.

```text
Zettel/
├── 0 — Inbox/               fleeting notes, captured ideas
├── 1 — Literature/          notes about sources (one per source)
├── 2 — Permanent/           atomic evergreen notes (timestamped IDs)
├── 3 — Index/               MOCs, hubs, structure notes
├── _Templates/
└── _Attachments/
```

Permanent note filename convention (from the Unique Note Creator core plugin): `YYYYMMDDHHmm — Title.md` — sortable, collision-free.

```bash
mkdir -p Zettel/{0\ —\ Inbox,1\ —\ Literature,2\ —\ Permanent,3\ —\ Index,_Templates,_Attachments}
```

---

### 4.3 Second Brain — PARA (work)

Tiago Forte's Projects / Areas / Resources / Archive. The most common work-vault pattern.

```text
PARA/
├── 1 Projects/              short-term efforts with a clear outcome
│   └── _MOC — Projects.md
├── 2 Areas/                 ongoing standards (Engineering, People, Health)
│   └── _MOC — Areas.md
├── 3 Resources/             topics of interest, reference
│   └── _MOC — Resources.md
├── 4 Archive/               anything from 1–3 that's now inactive
├── Journal/
│   └── Daily/
├── Inbox/
├── Templates/
└── Attachments/
```

```bash
mkdir -p PARA/{1\ Projects,2\ Areas,3\ Resources,4\ Archive,Journal/Daily,Inbox,Templates,Attachments}
touch "PARA/1 Projects/_MOC — Projects.md" "PARA/2 Areas/_MOC — Areas.md" "PARA/3 Resources/_MOC — Resources.md"
```

**Project folder convention** inside `1 Projects/`:

```
1 Projects/
└── Q4 GTM Plan/
    ├── _README.md           the project's hub note (frontmatter status, due, owner)
    ├── Meetings/
    ├── Notes/
    └── Attachments/
```

---

### 4.4 Work / Team vault

For a team using a shared vault (often via Obsidian Sync, Git, or a shared drive).

```text
TeamVault/
├── 01 Company/
│   ├── Handbook/
│   ├── Strategy/
│   └── Policies/
├── 02 Teams/
│   ├── Engineering/
│   ├── Product/
│   ├── Marketing/
│   └── Operations/
├── 03 Projects/
├── 04 People/              one note per teammate (alias = preferred name)
├── 05 Meetings/
│   └── 2026/
├── 06 Decisions/           ADRs / decision logs
├── 07 Inbox/
├── 90 Archive/
├── _Templates/
└── _Attachments/
```

```bash
mkdir -p TeamVault/{01\ Company/{Handbook,Strategy,Policies},02\ Teams/{Engineering,Product,Marketing,Operations},03\ Projects,04\ People,05\ Meetings/2026,06\ Decisions,07\ Inbox,90\ Archive,_Templates,_Attachments}
```

---

### 4.5 Content Creation vault

For writers, podcasters, YouTubers. Pipeline-shaped.

```text
ContentVault/
├── 1 Ideas/                  raw sparks
├── 2 Drafts/                 in-progress pieces
├── 3 Ready/                  scheduled / queued
├── 4 Published/              shipped (with permalinks in frontmatter)
├── Series/                   long-form / multi-part bodies of work
├── Research/                 sources, transcripts, screenshots
├── Templates/
├── Attachments/
└── Editorial Calendar.base    multi-view base — see bases.md
```

```bash
mkdir -p ContentVault/{1\ Ideas,2\ Drafts,3\ Ready,4\ Published,Series,Research,Templates,Attachments}
```

---

### 4.6 Research vault (academic / literature)

```text
Research/
├── Literature/              one note per paper; filename = citation key
├── Authors/                 one note per researcher
├── Topics/                  thematic MOCs
├── Methods/                 methodology notes
├── Reading Queue/
├── Drafts/                  papers / chapters you're writing
├── Talks/
├── Attachments/             PDFs of papers (huge; consider a symlink)
└── Templates/
```

```bash
mkdir -p Research/{Literature,Authors,Topics,Methods,Reading\ Queue,Drafts,Talks,Attachments,Templates}
```

## 5. Recommended Obsidian settings to pair with these structures

In **Settings → Files & Links**:

- *Default location for new notes*: configurable per vault. For PARA/PKM, use the **Inbox** folder so all stray captures land in one place.
- *Default location for new attachments*: a dedicated subfolder, e.g., `Attachments/` (single global) or "In subfolder under current folder" with name `attachments` (keeps media beside the note).
- *Use [[Wikilinks]]*: ON.
- *New link format*: "Shortest path when possible" — prevents long path strings in links.
- *Automatically update internal links*: ON. Renames stay coherent.

In **Settings → Core plugins → Templates**:

- *Template folder location*: `_Templates` (or `Templates`).
- *Date format*: `YYYY-MM-DD`.
- *Time format*: `HH:mm`.

In **Settings → Core plugins → Daily notes**:

- *Date format*: `YYYY-MM-DD`.
- *New file location*: `Journal/Daily/YYYY/MM` (or simpler) — set this exactly to match your tree.
- *Template file*: `_Templates/Daily Note.md`.
- *Open daily note on startup*: ON for journalers.

## 6. Default conventions Claude follows when generating vault structures

- Numeric prefixes (`00`, `10`, `20`...) for top-level sortability — Obsidian sorts folders alphabetically, and numeric prefixes give a deliberate order. Use 10-step gaps so you can insert later.
- Underscore prefix (`_Templates`, `_MOC — Foo`) for things you want to keep visually pinned at the top of a folder.
- Em-dash separator (` — `) between numeric prefix and label — cleaner than `-` and renders consistently in the file explorer.
- Folder names with spaces are fine — Obsidian and the OS handle them. In the bash script, escape spaces (`Q4\ Plan`) or quote (`"Q4 Plan"`).
- Always include a `Templates/` and `Attachments/` folder, even if empty.

## 7. When the user wants a structure not listed above

Combine archetypes. PARA-with-Zettelkasten is common: PARA at the top, plus an `Atomic/` folder using Zettel conventions. A research vault often borrows PARA's Archive folder. Don't be precious — the vault is theirs, and folder structure is the easiest thing to change later.

## 8. Migrating an existing folder of markdown into a vault

If the user already has `.md` files (Bear export, Notion export, raw markdown):

1. Create a new folder, drop the files in.
2. Open it in Obsidian → File → Open vault → select that folder. Obsidian writes `.obsidian/` into it.
3. Run **Format Converter** (core plugin) if the source was a non-Obsidian markdown flavor — see `core-plugins.md`.
4. For Notion/Roam/Evernote/Apple Notes etc., use the **Importer** community plugin — see `import.md`.
