# Install Guide — Obsidian Power User Skill

## What this folder is

This folder is a Claude skill called `obsidian-power-user`. The skill turns Claude into an Obsidian expert — it can produce vault structures, `.canvas` files, `.base` dashboards, daily-note templates, Dataview/Templater/Tasks artifacts, Publish setups, Web Clipper templates, and more.

The skill itself is the `SKILL.md` file at the root of this folder. When Claude loads the skill, it reads `SKILL.md` first, then loads files from `references/` and `assets/` on demand based on what you're asking for.

```
Obsidian Power User Skill/
├── SKILL.md                  the skill's main brain (routing + rules)
├── INSTALL.md                this file
├── references/               deep reference docs Claude loads on demand
│   ├── editing-formatting.md
│   ├── linking.md
│   ├── files-folders.md
│   ├── canvas.md
│   ├── bases.md
│   ├── core-plugins.md
│   ├── ui.md
│   ├── import.md
│   ├── publish.md
│   ├── web-clipper.md
│   ├── extending.md
│   └── community-plugins.md
└── assets/
    ├── templates/            note templates (Templater-flavored)
    │   ├── daily-note.md
    │   ├── meeting-notes.md
    │   ├── moc.md
    │   └── zettel.md
    └── examples/             worked example artifacts
        ├── content-pipeline.canvas
        ├── projects-dashboard.base
        └── para-structure.sh
```

## Option 1 — Install as a Claude skill

To make Claude actually use this skill, the folder needs to live inside Claude's skills directory under the exact name `obsidian-power-user` (matching the skill's `name:` in `SKILL.md` frontmatter).

Move or copy this folder (or just its inner files) into:

```
C:\Users\tolga\AppData\Roaming\Claude\local-agent-mode-sessions\skills-plugin\fde9562a-14ce-4e87-b701-cd04b3ce8443\270180af-5c97-446a-889d-8375be798f28\skills\obsidian-power-user\
```

The destination folder must be named `obsidian-power-user` (lowercase, hyphenated) so the directory name matches the skill name declared in `SKILL.md`. Rename the folder on the way in if you're copying this whole `Obsidian Power User Skill/` directory.

After it's in place, restart Claude (or reload skills) and the `obsidian-power-user` skill becomes available. Claude will auto-load it whenever your message mentions Obsidian, vaults, canvases, bases, PKM, daily notes, MOCs, or related concepts.

## Option 2 — Use as Obsidian reference notes

You don't have to install it as a skill. Every file here is plain markdown (or JSON-flavored `.canvas` / YAML-flavored `.base` / shell `.sh`) and renders perfectly in Obsidian as ordinary notes.

Useful ways to use it inside your vault:

- **Read the references** — `references/canvas.md`, `references/bases.md`, etc. are deep documentation of Obsidian features. They render with full callouts, tables, and code blocks in Obsidian.
- **Use the templates** — copy the four files in `assets/templates/` into your Templates folder. They use Templater syntax (`<% tp.date.now() %>`, prompts, file renames). With the Templater community plugin installed, they become live daily-note / meeting / MOC / zettel templates.
- **Drop in the canvas and base examples** — `assets/examples/content-pipeline.canvas` opens as a working Obsidian Canvas. `assets/examples/projects-dashboard.base` opens as a working Base if you have notes tagged `#project` in a `1 Projects/` folder.
- **Run the PARA scaffolder** — `assets/examples/para-structure.sh` is a bash script that builds a complete PARA vault folder structure with starter templates. Run it inside the folder you want to turn into a vault, then point Obsidian at that folder.

## A note on file types

Obsidian's File Explorer shows `.canvas`, `.base`, and `.sh` files as "unsupported file types" unless the matching core plugin is enabled (Canvas core plugin for `.canvas`, Bases core plugin for `.base`). Shell scripts (`.sh`) will always show as unsupported — that's expected; they're meant to be executed outside Obsidian, not opened inside it.

Enable Canvas and Bases under Settings → Core plugins to make `.canvas` and `.base` files preview properly in this folder.
