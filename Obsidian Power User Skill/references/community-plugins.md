# Community Plugins — Dataview, Templater, Tasks

These are **third-party community plugins**, not core. Always label them as such when recommending them. All three are installed from **Settings → Community plugins → Browse**.

---

## Dataview

A query language for your vault. Reads YAML frontmatter, inline fields, tags, file metadata — and renders the results as tables, lists, task lists, or calendars right inside a note.

If the user wants an **inline query inside a note**, use Dataview. If they want a **standalone dashboard file**, prefer Bases (see `bases.md`).

### Query block syntax

````markdown
```dataview
TABLE status, priority, due
FROM #project
WHERE status != "done"
SORT due ASC
```
````

A query has up to five parts, in this order:

1. **Query type** — `TABLE`, `LIST`, `TASK`, `CALENDAR`.
2. **Columns** (`TABLE` only) — properties or expressions to show.
3. **`FROM`** — the source: a tag, a folder, a link, or boolean combinations.
4. **`WHERE`** / **`SORT`** / **`GROUP BY`** / **`FLATTEN`** / **`LIMIT`** — optional filters and shaping.
5. **(implicit)** — defaults to showing `file.link`.

### Query types

#### `TABLE` — multi-column table

```dataview
TABLE
  status AS Status,
  priority AS P,
  due AS Due,
  file.mtime AS Modified
FROM "1 Projects"
WHERE status != "done"
SORT priority ASC, due ASC
```

#### `LIST` — bulleted list with optional second column

```dataview
LIST file.mtime
FROM "Journal/Daily"
WHERE file.day >= date(today) - dur(7 days)
SORT file.day DESC
```

#### `TASK` — individual checkbox tasks across notes

```dataview
TASK
FROM "1 Projects" OR "2 Areas"
WHERE !completed AND due
SORT due ASC
GROUP BY file.link
```

The `TASK` query returns individual `- [ ]` items, not whole notes — and you can render, check, and edit them inline. Combine with the **Tasks** community plugin for richer due-date syntax (see below).

#### `CALENDAR` — date-positioned dots/items

```dataview
CALENDAR file.day
FROM "Journal/Daily"
```

Each dot is a note. Click to open. Useful as a "year at a glance" of which days have entries.

### `FROM` sources

| Source | Example |
|---|---|
| Tag | `FROM #project` |
| Folder | `FROM "1 Projects"` (path in quotes) |
| Specific note | `FROM [[Q4 GTM Plan]]` |
| Linked from | `FROM outgoing([[MOC]])` |
| Linked to | `FROM [[MOC]]` |
| Boolean combos | `FROM #project AND -#archived` |
| All notes | `FROM ""` |

### Clauses

- **`WHERE expr`** — filter rows.
- **`SORT prop [ASC|DESC]`** — sort.
- **`GROUP BY expr`** — aggregate.
- **`FLATTEN list-prop`** — explode a list-valued property into one row per item.
- **`LIMIT n`** — top n only.

### Inline fields

Beyond frontmatter, Dataview indexes inline fields written inside note bodies:

```markdown
Status:: active
Priority:: 2
Due:: 2026-08-15
```

And inline at the end of a line:

```markdown
- Wrote outline for Q4 plan [status:: done] [time:: 45m]
```

These are queryable with `WHERE status = "active"` exactly like frontmatter.

### Inline queries (single-value)

```markdown
This project is `= status` and due `= due`.
```

Renders inline within prose. Great for "smart" sentences in MOCs.

```markdown
Days until launch: `= (due - date(today)).days`
```

### Implicit fields available on every note

| Field | Meaning |
|---|---|
| `file.name` | filename without extension |
| `file.path` | full vault-relative path |
| `file.folder` | parent folder path |
| `file.link` | a clickable link to the note |
| `file.size` | size in bytes |
| `file.ctime` | created datetime |
| `file.mtime` | modified datetime |
| `file.cday` | created date (midnight) |
| `file.mday` | modified date (midnight) |
| `file.tags` | list of tags |
| `file.etags` | explicit tags (no nesting prefixes) |
| `file.inlinks` | list of incoming links |
| `file.outlinks` | list of outgoing links |
| `file.aliases` | aliases list |
| `file.tasks` | list of task objects |
| `file.lists` | list of all bullets |
| `file.starred` / `file.bookmarked` | whether bookmarked |
| `file.day` | date parsed from filename when it looks like a date |

### Functions

Most useful:

| Function | Notes |
|---|---|
| `date("2026-05-15")` | parse a literal date |
| `dur(7 days)` / `dur(2 weeks)` | durations |
| `length(list)` | count |
| `sum(list)` / `min(list)` / `max(list)` / `average(list)` | aggregates |
| `contains(list, x)` | membership |
| `striptime(d)` | date from datetime |
| `dateformat(d, "yyyy-MM-dd")` | format |
| `round(n, decimals)` | round |
| `regexmatch(re, s)` | regex test |
| `regexreplace(s, re, with)` | regex replace |

### Worked example — "all tasks due this week grouped by project"

```dataview
TASK
FROM "1 Projects"
WHERE !completed
  AND due >= date(today)
  AND due <= date(today) + dur(7 days)
SORT due ASC
GROUP BY file.link
```

### Output rules for Claude when writing Dataview

1. **Always wrap in a fenced ` ```dataview` code block** — Obsidian's renderer keys off the language tag.
2. **Quote folder paths** (`FROM "1 Projects"`) — without quotes Dataview will try to interpret as a tag.
3. **Use `AS Display` aliases** for columns whose property name is awkward (`file.mtime AS Modified`).
4. **Prefer `file.link` as the first column** in TABLE queries — it makes results clickable.
5. **For TASK queries grouped by project**, `GROUP BY file.link` is the conventional pattern.
6. **Don't write Dataview when Bases would do.** Standalone dashboards → Bases. Inline queries inside notes → Dataview.

---

## Templater

Dynamic templates. Replaces the static `{{title}}` / `{{date}}` tokens of the core Templates plugin with full JavaScript expressions and a rich `tp.*` API.

### How a Templater template works

Three kinds of blocks:

| Syntax | When it runs | Use for |
|---|---|---|
| `<% expr %>` | render, inline | inserting a value into the note |
| `<%* expr %>` | execute, no output | running setup logic, prompting the user, manipulating state |
| `<%- ... -%>` | trim whitespace | tidying output |

### Most useful `tp.*` functions

#### Date / time

```javascript
<% tp.date.now() %>                       // "2026-05-15"
<% tp.date.now("YYYY-MM-DD") %>           // same as default
<% tp.date.now("HH:mm") %>                // "10:42"
<% tp.date.tomorrow("YYYY-MM-DD") %>      // "2026-05-16"
<% tp.date.yesterday("YYYY-MM-DD") %>     // "2026-05-14"
<% tp.date.weekday("YYYY-MM-DD", 1) %>    // next Monday
```

#### File / note context

```javascript
<% tp.file.title %>                       // current note's filename
<% tp.file.creation_date("YYYY-MM-DD") %>
<% tp.file.last_modified_date("YYYY-MM-DD HH:mm") %>
<% tp.file.path(true) %>                  // path (true = absolute, false = vault-relative)
<% tp.file.folder() %>                    // containing folder
<% tp.file.tags %>                        // list of tags
<% await tp.file.cursor() %>              // place cursor here after template runs
```

#### System / interaction

```javascript
<% tp.system.prompt("Title:") %>                       // text input
<% tp.system.prompt("Priority:", "2") %>               // text with default
<% tp.system.suggester(["A","B","C"], ["A","B","C"]) %>  // pick from list
<% tp.system.clipboard() %>                            // current clipboard
```

#### File operations

```javascript
<% await tp.file.move("Projects/" + tp.file.title) %>
<% await tp.file.rename(tp.date.now("YYYYMMDDHHmm") + " — " + tp.file.title) %>
```

### Worked example — meeting notes template

````markdown
<%*
const title = await tp.system.prompt("Meeting title:");
const attendees = await tp.system.prompt("Attendees (comma-separated):");
const date = tp.date.now("YYYY-MM-DD");
await tp.file.rename(`${date} — ${title}`);
-%>
---
title: "<% title %>"
date: <% date %>
type: meeting
attendees: [<% attendees.split(",").map(a => `"${a.trim()}"`).join(", ") %>]
tags: [meeting]
---

# <% title %>

**Date:** <% date %>
**Attendees:** <% attendees %>

> [!ABSTRACT]+ TL;DR
> _(one-line outcome)_

## Agenda

- 

## Notes

<% tp.file.cursor() %>

## Decisions

- 

## Action items

- [ ] 

## Follow-ups

- 

%% Related: [[]] %%
````

### Worked example — daily note template (founder)

````markdown
---
title: "<% tp.date.now("YYYY-MM-DD") %>"
date: <% tp.date.now("YYYY-MM-DD") %>
type: daily
tags: [daily]
mood:
energy:
---

# <% tp.date.now("dddd, MMMM D, YYYY") %>

> [!ABSTRACT]+ Today
> Three things that will move the needle:
> 1. 
> 2. 
> 3. 

## Morning intention

<% tp.file.cursor() %>

## Calendar

- 

## Tasks

- [ ] 

## Notes

## Wins

- 

## What I learned

- 

## Tomorrow

- 

%% Yesterday: [[<% tp.date.yesterday("YYYY-MM-DD") %>]] · Tomorrow: [[<% tp.date.tomorrow("YYYY-MM-DD") %>]] %%
````

### Patterns

- **Use `<%* ... -%>` at the top** for setup that shouldn't produce text output (prompts, renames, file moves).
- **Always include a `<% tp.file.cursor() %>`** somewhere in the body so the user lands ready to type.
- **Pair Templater with Daily Notes**: set the Templater template as your Daily Notes template (Settings → Core plugins → Daily notes → Template file location), so every new day automatically applies it.
- **Set as startup template** in Templater settings to apply automatically when a note is created in a specific folder (e.g., every new note in `Meetings/` runs the meeting template).

### Output rules for Claude when writing Templater

1. **Fenced as ` ```javascript`**, because that's what Obsidian's renderer expects and what most plugin docs use. (The Templater plugin itself doesn't care about the language tag, but ` ```javascript` gets syntax highlighting in Obsidian.)
2. **Frontmatter must be valid YAML** even with `<% ... %>` substitutions inside string values — quote any string that contains `:` or other YAML-sensitive characters.
3. **Use `<% tp.file.cursor() %>` exactly once** per template.
4. **Use `<%* ... -%>` for renames/moves** at the top, so the file is in the right place before anything else runs.

---

## Tasks Plugin

Rich task syntax on top of standard `- [ ]` checkboxes, plus a query language for showing/filtering tasks across the vault.

### Task syntax

A Tasks-aware task looks like this:

```markdown
- [ ] Write the Q4 GTM plan 📅 2026-08-15 ⏳ 2026-06-01 🛫 2026-05-15 ⏫ 🔁 every quarter #project/q4
```

Emoji are the syntactic markers — each has a meaning.

| Emoji | Meaning | Example |
|---|---|---|
| 📅 | due date | `📅 2026-08-15` |
| ⏳ | scheduled (when to do it) | `⏳ 2026-06-01` |
| 🛫 | start date (don't show before) | `🛫 2026-05-15` |
| ➕ | created date | `➕ 2026-05-10` |
| ✅ | completion date | added when checked |
| 🔁 | recurrence | `🔁 every week`, `🔁 every 2 days when done`, `🔁 every month on the 1st` |
| 🔺 | highest priority | (no value) |
| ⏫ | high | |
| 🔼 | medium | |
| 🔽 | low | |
| ⏬ | lowest | |
| 🆔 | task ID | `🆔 abc123` |
| ⛔ | blocked by | `⛔ abc123,def456` |
| 🏁 | on completion behavior | `🏁 keep`, `🏁 delete` |

Tasks plugin also supports inline tags inside a task and recognizes them as filterable metadata.

### Recurrence syntax

```
🔁 every day
🔁 every weekday
🔁 every 2 weeks
🔁 every month
🔁 every year
🔁 every Saturday
🔁 every 3 days when done    (next instance scheduled from completion date)
🔁 every month on the 15th
```

When a recurring task is checked, Tasks creates the next instance automatically.

### Query block

A `tasks` code block renders matching tasks anywhere.

````markdown
```tasks
not done
due before next week
sort by due
group by file
```
````

| Filter | Meaning |
|---|---|
| `not done` / `done` | completion status |
| `due before today` / `due after today` / `due on YYYY-MM-DD` | date comparisons |
| `due before next week` | natural-language dates supported |
| `scheduled before today` | |
| `starts before today` | |
| `path includes Projects` | path filter |
| `tag includes #project` | tag filter |
| `priority is high` | priority filter |
| `description includes <text>` | substring match |
| `is recurring` / `is not recurring` | |

| Sort/group | Notes |
|---|---|
| `sort by due` / `sort by priority` / `sort by path` | use `reverse` for desc |
| `group by file` | group output by source note |
| `group by happens` | by computed "next date" |
| `group by priority` | |

### Worked examples

**All overdue tasks across the vault:**

````markdown
```tasks
not done
due before today
sort by due
group by file
```
````

**This week's tasks for a specific project:**

````markdown
```tasks
not done
path includes 1 Projects/Q4 GTM Plan
due before next week
sort by priority
```
````

**Today's intentions (date math):**

````markdown
```tasks
not done
scheduled today OR due today
sort by priority
```
````

### Tasks + Dataview

The two plugins coexist. Use Tasks for rich syntax and lightweight inline queries. Use Dataview when you need *full* metadata access (combine task fields with frontmatter on the parent note).

### Output rules for Claude when writing Tasks

1. **Fenced as ` ```tasks`** — the plugin keys off this exact language tag.
2. **Each line is a filter or sort/group clause** — keep one per line.
3. **Default sort order: `sort by due`** for due-date-driven queries.
4. **Group by `file` or `happens`** for readability when the query spans many notes.
5. **When generating a task inside a note**, use the rich syntax: due/priority/recurrence at minimum where it makes sense. Don't over-stuff every task with every emoji; only add what's true.

---

## Quick comparison — when to reach for which

| Need | Plugin |
|---|---|
| A standalone dashboard file | **Bases** (core, no install) |
| An inline query inside a note | **Dataview** |
| Rich tasks with due dates and recurrence | **Tasks** |
| Dynamic templates with prompts and JS | **Templater** |
| Multi-cadence periodic notes (weekly/monthly) | **Periodic Notes** (community) |
| Sidebar calendar of daily notes | **Calendar** (community) |
| Hand-drawn diagrams | **Excalidraw** (community) |
