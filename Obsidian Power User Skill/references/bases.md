# Bases (`.base` files)

Bases is Obsidian's native database. A `.base` file is YAML that defines a queryable view over the notes in the vault — filtered, sorted, grouped, and decorated with formula columns. It replaces most everyday Dataview use cases without any community plugins.

The skill produces these as **complete, valid YAML** in a fenced ` ```yaml` block, with a filename comment. Save to `Whatever.base` in the vault to use it.

## 1. What Bases is for

- Project dashboards (status, due date, owner, priority)
- Reading lists, content calendars, hiring pipelines, CRM-lite people directories
- Anything you want as a *live, filtered, sorted, multi-view* table over notes
- Cards, kanban-style boards (via the `cards` view)
- Geographic browsing (via the `map` view, requires the Maps plugin)

If you're producing a dashboard, default to a Base. Use Dataview only when the user has it installed and explicitly prefers it, or when you need behavior Bases doesn't support yet (e.g., very complex group-by aggregations).

## 2. File structure — the four top-level blocks

```yaml
filters:    # which notes are included at all (global to the file)
formulas:   # computed columns available across views
properties: # display configuration for properties (column titles, etc.)
views:      # one or more named views with their own filters/sort/columns
```

All four are optional, but a useful `.base` will have at least `filters` and `views`.

## 3. Filters

Filter expressions support `and`, `or`, and `not` composition.

```yaml
filters:
  and:
    - file.inFolder("1 Projects")
    - 'status != "done"'
    - or:
        - 'priority <= 2'
        - taggedWith(file.file, "urgent")
    - not:
        file.name.contains("Template")
```

### Available functions

| Function | Returns | Example |
|---|---|---|
| `file.inFolder("path")` | boolean | `file.inFolder("Projects")` (recursive) |
| `file.hasTag("tag")` | boolean | `file.hasTag("project")` |
| `file.hasProperty("prop")` | boolean | filters out notes missing the property |
| `taggedWith(file.file, "tag")` | boolean | tag check (no `#`) |
| `linksTo(file.file, "Note Name")` | boolean | true if note links to target |
| `linkedFrom(file.file, "Note Name")` | boolean | true if note is linked from target |
| `contains(value, "x")` | boolean | string or list contains |
| `startsWith(value, "x")` | boolean | |
| `endsWith(value, "x")` | boolean | |
| `now()` | datetime | current time |
| `today()` | date | current date |
| `date("2026-05-15")` | date | literal |

### File metadata you can filter on

| Property | Type |
|---|---|
| `file.name` | string (basename, no extension) |
| `file.path` | string (full vault-relative path) |
| `file.folder` | string |
| `file.ext` | string (e.g., `"md"`, `"canvas"`, `"base"`) |
| `file.ctime` | datetime (file creation) |
| `file.mtime` | datetime (file modification) |
| `file.size` | number (bytes) |
| `file.tags` | list of strings |
| `file.links` | list of links |
| `file.backlinks` | list of links |

### Comparison operators

`==` `!=` `<` `<=` `>` `>=` and these can be combined with the logical functions above.

Quoting rules: wrap whole expressions in single quotes if they contain `:` or `=`; quote string literals with double quotes.

## 4. Formulas — computed columns

```yaml
formulas:
  days_old: '(now() - file.ctime) / (1000 * 60 * 60 * 24)'
  is_overdue: 'due < today() && status != "done"'
  display_title: 'concat(title, " — ", status)'
  est_effort: 'if(priority <= 2, "high", "low")'
```

Formulas are referenced in `views` as `formula.<name>`.

### Function reference

**Arithmetic**: `+` `-` `*` `/` `%`

**Comparison & logic**: `==` `!=` `<` `<=` `>` `>=` `&&` `||` `!`

**String**:

| Function | Description |
|---|---|
| `concat(a, b, ...)` | join strings |
| `upper(s)` / `lower(s)` | case |
| `length(s)` | character count |
| `contains(s, sub)` | substring |
| `startsWith(s, sub)` | |
| `endsWith(s, sub)` | |
| `replace(s, find, with)` | substitution |
| `slice(s, start, end)` | substring by index |
| `split(s, sep)` | returns list |

**Date / time**:

| Function | Description |
|---|---|
| `now()` | current datetime |
| `today()` | current date (midnight) |
| `date("YYYY-MM-DD")` | parse a literal date |
| `datetime.format(d, "YYYY-MM-DD")` | format a date/datetime as a string |
| `daysBetween(a, b)` | integer days |

**Conditional**:

| Function | Description |
|---|---|
| `if(cond, a, b)` | ternary |

**Lists**:

| Method | Description |
|---|---|
| `list.length` | count |
| `list.contains(x)` | membership |
| `list.first()` / `list.last()` | endpoints |
| `list.map(item -> expr)` | transform each |
| `list.filter(item -> cond)` | keep matching |
| `list.join(sep)` | join to string |

## 5. Properties — display configuration

Lets you rename columns or tweak how they appear in views.

```yaml
properties:
  status:
    displayName: "Status"
  priority:
    displayName: "P"
  formula.days_old:
    displayName: "Age (days)"
  file.name:
    displayName: "Note"
  file.mtime:
    displayName: "Modified"
```

This block is optional but makes views read better.

## 6. Views

Each view has a `type`, optionally `name`, plus its own `filters`, `order` (sort), and view-specific config.

### View types

| Type | Best for |
|---|---|
| `table` | the spreadsheet default — most projects, lists, dashboards |
| `cards` | kanban-style, visual browsing, content calendars |
| `list` | simple linear lists (reading queues, brainstorm dumps) |
| `map` | geographic notes (requires Maps plugin) |

### Common view fields

| Field | Type | Notes |
|---|---|---|
| `type` | string | required |
| `name` | string | shown in the view picker |
| `filters` | filter expression | scoped to this view, AND'd with the file-level `filters` |
| `order` | list of strings | sort columns; prefix `-` for descending |
| `limit` | number | optional max rows |

### Table-specific

| Field | Notes |
|---|---|
| `columns` | ordered list of properties / formula refs to show |
| `groupBy` | property to collapse rows by |

### Cards-specific

| Field | Notes |
|---|---|
| `groupBy` | property used to create card columns (kanban) |
| `coverProperty` | property whose value is an image path or URL — used as card cover |
| `image` | alternative cover spec |

### Example — table view

```yaml
views:
  - type: table
    name: Active Projects
    filters:
      and:
        - 'status == "active"'
    columns:
      - file.name
      - status
      - priority
      - due
      - formula.days_old
    order:
      - priority
      - due
```

### Example — cards (kanban)

```yaml
views:
  - type: cards
    name: Kanban
    groupBy: status
    columns:
      - file.name
      - priority
      - due
    order:
      - -due
```

## 7. Property reference inside expressions

| Reference | Meaning |
|---|---|
| `status` (or `note.status`) | a frontmatter property of the note |
| `tags` | list of tags (frontmatter + inline) |
| `file.name`, `file.path`, etc. | file metadata (see §3) |
| `formula.days_old` | a formula defined in the `formulas` block |
| `link` | reference to a `[[wikilink]]` value (returns the linked file) |

If a property is missing on a note, it evaluates to null. `status != "done"` is true for both `status: active` and notes with no `status:` at all. Use `file.hasProperty("status")` if you want to require presence.

## 8. Complete example — Project Dashboard

For the prompt *"Create a `.base` file that acts like an Obsidian dashboard for my projects"*. Save as `Project Dashboard.base`.

```yaml
# Save as: Project Dashboard.base
filters:
  and:
    - file.inFolder("1 Projects")
    - file.hasTag("project")

formulas:
  days_until_due: 'daysBetween(today(), due)'
  age_days: '(now() - file.ctime) / (1000 * 60 * 60 * 24)'
  is_overdue: 'due < today() && status != "done"'
  health: 'if(status == "done", "✅ done", if(formula.is_overdue, "🔴 overdue", if(formula.days_until_due <= 7, "🟡 soon", "🟢 ok")))'

properties:
  file.name:
    displayName: "Project"
  status:
    displayName: "Status"
  priority:
    displayName: "P"
  owner:
    displayName: "Owner"
  due:
    displayName: "Due"
  formula.days_until_due:
    displayName: "Days left"
  formula.health:
    displayName: "Health"
  formula.age_days:
    displayName: "Age"

views:
  - type: table
    name: All Active
    filters:
      and:
        - 'status != "done"'
        - 'status != "archived"'
    columns:
      - file.name
      - formula.health
      - status
      - priority
      - owner
      - due
      - formula.days_until_due
    order:
      - priority
      - due

  - type: cards
    name: Board
    groupBy: status
    coverProperty: cover
    columns:
      - file.name
      - priority
      - due
      - owner
    order:
      - -priority
      - due

  - type: table
    name: Overdue
    filters:
      and:
        - 'formula.is_overdue'
    columns:
      - file.name
      - owner
      - due
      - formula.days_until_due
    order:
      - due

  - type: table
    name: Shipped this quarter
    filters:
      and:
        - 'status == "done"'
        - 'file.mtime > date("2026-04-01")'
    columns:
      - file.name
      - owner
      - file.mtime
    order:
      - -file.mtime
```

## 9. Smaller examples (recipes)

### Notes tagged `#project` that are not done (test prompt #4 in the brief)

```yaml
# Save as: Open Projects.base
filters:
  and:
    - file.hasTag("project")
    - 'status != "done"'

views:
  - type: table
    name: Open
    columns:
      - file.name
      - status
      - priority
      - due
    order:
      - priority
      - due
```

### Reading list — books with status `to-read`

```yaml
# Save as: Reading List.base
filters:
  and:
    - file.inFolder("Resources/Books")
    - 'status == "to-read"'

views:
  - type: cards
    name: To read
    coverProperty: cover
    columns:
      - file.name
      - author
      - genre
    order:
      - -priority
```

### Daily notes from this month

```yaml
# Save as: This Month's Journal.base
filters:
  and:
    - file.inFolder("Journal/Daily")
    - 'file.ctime >= date(datetime.format(today(), "YYYY-MM-01"))'

views:
  - type: list
    name: This month
    order:
      - -file.ctime
```

### Meeting notes that mention a specific person

```yaml
# Save as: Meetings with Alex.base
filters:
  and:
    - file.inFolder("Meetings")
    - linksTo(file.file, "People/Alex")

views:
  - type: table
    name: Meetings with Alex
    columns:
      - file.name
      - date
      - attendees
    order:
      - -date
```

## 10. Bases vs Dataview — quick chooser

| Use Bases when | Use Dataview when |
|---|---|
| You want a persistent dashboard you can open as its own file | You want an inline query inside a note (e.g., a project README that lists its child meetings) |
| Native install — no community plugin dependency | You need `TASK` queries pulling individual checkboxes |
| You want cards / kanban / multi-view | You need complex `GROUP BY ... FLATTEN` aggregations |
| You want column-style formulas | You need JavaScript-level dynamic logic |

The skill defaults to **Bases** for top-level dashboards and **Dataview** for inline queries inside individual notes.

## 11. Output rules for Claude

1. **Always produce a complete file** — at minimum `filters` and one `views` entry.
2. **Wrap expressions containing operators in single quotes** to keep YAML happy.
3. **Use realistic property names** matching the vault conventions (`status`, `priority`, `due`, `owner`).
4. **Default sort by what matters**: priority first, then due. Never random order.
5. **For multi-view bases, always include**: a primary view ("All Active" or similar), a board/kanban view, and at least one "exception" view (overdue, blocked, etc.).
6. **Add a `formulas:` block when the dashboard would benefit from derived values** (health indicators, age, days-left). Don't force formulas where simple property columns suffice.
7. **Filename comment** at the top of the fenced block, prefixed `# Save as: <name>.base`.
