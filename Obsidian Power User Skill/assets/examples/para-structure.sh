#!/usr/bin/env bash
# PARA vault scaffold. Run from inside the folder you want to become the vault root.
# After running: open Obsidian → Open vault → select this folder.

set -e

mkdir -p "1 Projects"
mkdir -p "2 Areas"
mkdir -p "3 Resources"
mkdir -p "4 Archive"
mkdir -p "Journal/Daily"
mkdir -p "Journal/Weekly"
mkdir -p "Inbox"
mkdir -p "Templates"
mkdir -p "Attachments"

# MOC stubs at the top of each section
touch "1 Projects/_MOC — Projects.md"
touch "2 Areas/_MOC — Areas.md"
touch "3 Resources/_MOC — Resources.md"

# Starter daily-note template
cat > "Templates/Daily Note.md" <<'EOF'
---
title: "{{date:YYYY-MM-DD}}"
date: {{date:YYYY-MM-DD}}
type: daily
tags: [daily]
---

# {{date:dddd, MMMM D, YYYY}}

> [!ABSTRACT]+ Today
> 1.
> 2.
> 3.

## Notes

## Tasks

- [ ]
EOF

# Starter project template
cat > "Templates/Project.md" <<'EOF'
---
title: "{{title}}"
type: project
tags: [project]
status: idea
priority: 3
owner:
due:
created: {{date:YYYY-MM-DD}}
---

# {{title}}

> [!ABSTRACT]+ Outcome
> What does "done" look like for this project?

## Context

## Plan

- [ ]

## Notes

## Decisions

## Related

EOF

# Inbox quick-capture stub
cat > "Inbox/_README.md" <<'EOF'
# Inbox

All quick captures land here. Triage weekly:

1. **Project material?** → move into `1 Projects/<project>/`
2. **Reference?** → `3 Resources/`
3. **Trash?** → delete
4. **Done with it?** → `4 Archive/`

Keep the inbox empty-ish.
EOF

echo "PARA vault scaffold created. Open this folder as an Obsidian vault."
