# Obsidian Web Clipper

The official browser extension. Clips web pages directly into the vault as `.md` files, using templates the user defines. Available for Chrome, Firefox, Safari, Edge, Arc.

Install from the browser's extension store — search "Obsidian Web Clipper".

## 1. What it does

- **Clip a full page** — extracts the main article content (Mozilla Readability), strips navigation/ads, saves as markdown.
- **Clip a selection** — clip just highlighted text on a page.
- **Highlight first, clip later** — highlight passages directly on the page, then clip everything plus your highlights as a structured note.
- **Interpret a page** — uses an LLM (BYO API key) to extract structured data from the page according to a template you define.

## 2. Templates

The configurable heart of the clipper. A template defines:

- *Name* — shown in the clipper popup.
- *Vault* — which vault to save into (one or more).
- *Behavior* — how to handle the existing note if any (create new, append, replace).
- *Folder location* — where to save inside the vault. Can include variables.
- *Filename pattern* — likewise.
- *Tags* — added to the note.
- *Properties* — frontmatter to apply.
- *Note content* — the markdown body, built from variables and filters.

Templates live in the extension's settings. Export/import templates as JSON for portability between machines or sharing with a team.

## 3. Variables

Available inside any field (filename, folder, content, properties).

| Variable | Description |
|---|---|
| `{{title}}` | the page's `<title>` (or `og:title` if present) |
| `{{url}}` | the URL being clipped |
| `{{date}}` | date of clipping (today) |
| `{{time}}` | time of clipping |
| `{{content}}` | the main article body, converted to markdown |
| `{{highlights}}` | bullet list of any highlights you made on the page before clipping |
| `{{selection}}` | text you'd highlighted at clip time |
| `{{author}}` | author name from meta tags |
| `{{description}}` | page meta description (or `og:description`) |
| `{{image}}` | `og:image` URL (the social card image) |
| `{{published}}` | publication date from meta tags (or null) |
| `{{domain}}` | bare domain (e.g., `www.nytimes.com`) |
| `{{site}}` | `og:site_name` if set |
| `{{schema}}` | schema.org JSON-LD data, if present |
| `{{meta:propname}}` | any meta tag value by name |

Custom variables can be created in template settings to combine these.

## 4. Filters — transform a variable's value

Pipe syntax inside `{{ ... }}`:

```
{{title | slug}}
{{date | date:"YYYY-MM-DD"}}
{{content | trim}}
{{description | slice:0,150}}
{{title | upper}}
```

| Filter | Effect |
|---|---|
| `trim` | strip leading/trailing whitespace |
| `upper` / `lower` / `title` | case |
| `slug` | URL-friendly slug (lowercase, hyphens) |
| `slice:start,end` | substring |
| `replace:"find","with"` | substitution |
| `date:"format"` | format a date variable |
| `default:"fallback"` | fallback if value is empty |
| `safe_name` | strip filesystem-unsafe characters |
| `wikilink` | wrap as `[[...]]` |
| `list` | format as a markdown list (works on arrays like tags) |
| `markdown` | convert HTML to markdown (already applied to `content`) |
| `striphtml` | remove HTML tags |
| `length` | character/element count |
| `first` / `last` | first/last item of a list |

Chain filters: `{{title | slug | slice:0,80}}`.

## 5. Logic — conditionals and loops

Liquid-style templating inside content fields.

```liquid
{% if author %}**Author:** {{author}}{% endif %}

{% if published %}**Published:** {{published | date:"YYYY-MM-DD"}}{% endif %}

{% if highlights %}
## My highlights

{% for h in highlights %}
- {{h}}
{% endfor %}
{% endif %}
```

Operators: `==`, `!=`, `<`, `>`, `and`, `or`, `not`.

`{{value | default:"N/A"}}` — fallback when missing.

## 6. Two ready-to-paste templates

### A. "Article" — long-form reading

Save articles for read-later, with clean metadata for Bases/Dataview.

- *Folder*: `0 Inbox/Articles/`
- *Filename*: `{{title | safe_name | slice:0,80}}.md`
- *Properties*:

```yaml
title: "{{title}}"
source: "{{url}}"
author: "{{author | default:"Unknown"}}"
domain: "{{domain}}"
published: "{{published | date:"YYYY-MM-DD" | default:""}}"
clipped: "{{date}}"
status: unread
tags: [clipped, article]
```

- *Content*:

```markdown
# {{title}}

> [!INFO] Source
> - URL: {{url}}
> - Author: {{author | default:"Unknown"}}
> - Domain: {{domain}}
> - Published: {{published | date:"YYYY-MM-DD" | default:"—"}}

## Summary

{{description | default:"_(add your summary)_"}}

## Highlights

{% if highlights %}
{% for h in highlights %}
- {{h}}
{% endfor %}
{% else %}
_(none yet — highlight passages on the page, then re-clip)_
{% endif %}

## Article

{{content}}

---

_Clipped {{date}}_
```

### B. "Reference" — bookmark-style minimal clip

When the page is a reference and you don't need the full body, just the metadata and your highlights.

- *Folder*: `Resources/References/`
- *Filename*: `{{title | safe_name | slice:0,80}}.md`
- *Properties*:

```yaml
title: "{{title}}"
url: "{{url}}"
domain: "{{domain}}"
tags: [reference]
clipped: "{{date}}"
```

- *Content*:

```markdown
# {{title}}

[{{domain}}]({{url}})

{% if description %}> {{description}}{% endif %}

## Notes

{{selection | default:"_(your notes)_"}}
```

## 7. Interpret a page (LLM extraction)

For pages whose structure is annoying to parse, the Interpret feature can:

- Extract names, dates, prices, addresses into frontmatter automatically.
- Summarize the page into a short paragraph as `{{summary}}`.
- Classify the page (e.g., "is this a recipe, an article, a product, a paper?") and tag accordingly.

Configure in extension settings → Interpret → add your API key (Claude, OpenAI, Ollama for local). Define what fields to extract per template.

## 8. Patterns Claude follows when designing clip templates

1. **Folder by intent, not by source.** Articles go in `Articles/`, references in `References/`, recipes in `Recipes/`. Don't dump everything in `Clippings/` — Bases and Dataview reward structured locations.
2. **Always tag `clipped`** at minimum, plus a type tag (`article`, `reference`, `recipe`). Lets the user later run a "all clipped, unread" Base.
3. **Always set `status: unread`** in frontmatter for read-later flows — pair with a Base view.
4. **Slice the filename to ~80 chars** to avoid OS path length issues.
5. **Use `safe_name`** before any value used in the filename.
6. **Put `{{url}}` near the top** of the content, inside a callout — readers always want to find the source again.
7. **Keep `{{content}}` last** so user-written notes and the original article don't get tangled together.
