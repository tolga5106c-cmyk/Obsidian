# Linking Notes & Files

Obsidian's power is the graph. The graph is built from links. Be generous with linking, deliberate about syntax.

## 1. Internal links — `[[wikilinks]]`

```markdown
[[Note Name]]                   basic link
[[Note Name#Heading]]           link to a specific heading inside the note
[[Note Name#^block-id]]         link to a specific block by block ID
[[Note Name|Display Text]]      pipe alias — show "Display Text" but link to "Note Name"
[[Note Name#Heading|Alias]]     combine heading + alias
[[#Heading in this note]]       link to a heading in the current note
[[#^block-id]]                  link to a block in the current note
```

**Resolution rules:**

- Obsidian resolves `[[Note Name]]` against:
  1. exact filename match in any folder, then
  2. `aliases:` array of any other note.
- If a note doesn't exist yet, the link shows in muted color and clicking creates it. This is how you stub future notes from the current one.
- Paths can be included for disambiguation: `[[Projects/2026/Q4 Plan]]`. But in general, **don't** include paths — moving the file would break links. Let Obsidian resolve by filename.

## 2. Block references

Append `^id` to the end of a line/paragraph to give it a stable ID. Then link to it.

```markdown
This is a key finding. ^finding-1

Elsewhere: [[Source Note#^finding-1]]
```

Type `^` while inside a `[[...]]` and Obsidian's link autocomplete will surface the available blocks of the target note.

## 3. Aliases

Two complementary mechanisms.

**Inline pipe alias** — for a one-off display string:

```markdown
We followed [[Q4 GTM Plan|the plan]] from last quarter.
```

**Frontmatter aliases** — for persistent alternative names that should resolve to the same note:

```yaml
---
title: "Q4 GTM Plan"
aliases:
  - Q4 plan
  - fall plan
  - fall 2026 launch
---
```

Any of `[[Q4 plan]]`, `[[fall plan]]`, `[[fall 2026 launch]]` will now resolve to this note, *and* they'll appear in Quick Switcher.

## 4. Embeds — `![[...]]`

The `!` prefix changes "link to" into "inline this".

```markdown
![[Note Name]]                  embed full note inline
![[Note Name#Heading]]          embed just the content under that heading
![[Note Name#^block-id]]        embed a single block
![[image.png|500]]              embed image at 500px wide
![[clip.mp4]]                   embed video as a player
```

When the embedded note changes, the embed updates everywhere it appears — a powerful "transclude" pattern. Use for shared definitions, status callouts, common warnings.

**Recursion is not allowed.** Note A embedding Note B which embeds Note A will cut off cleanly; Obsidian won't loop.

## 5. External links

Standard markdown:

```markdown
[Anthropic](https://www.anthropic.com)
<https://www.anthropic.com>            auto-link
```

## 6. Linking strategy — when to use what

| Goal | Use |
|---|---|
| Reference another concept casually | `[[Concept]]` |
| Reference but display different text | `[[Concept\|display]]` |
| Pull a paragraph into another note | `![[Concept#Heading]]` |
| Cite a specific sentence/claim | block ID + `[[Note#^id]]` |
| Build a Map of Content (MOC) | bulleted list of `[[wikilinks]]`, grouped by H2 sections, often inside callouts |
| Maintain bidirectional discoverability | rely on Obsidian's automatic backlinks — no special syntax needed |

## 7. Unlinked mentions

If you've typed a note's title or alias as plain text (not in `[[brackets]]`), the Backlinks pane shows it under "Unlinked mentions" and offers a one-click "Link" button. Worth running periodically over high-value notes.

## 8. The graph view, in one line

The global graph is the bird's-eye visualization of all wikilinks. The local graph (Ctrl+P → "Open local graph") shows just neighbors of the current note. Configure forces (repel/link/center) and filters in the graph settings panel — see `core-plugins.md`.

## 9. Linking conventions for this skill

When generating notes, follow these defaults:

1. **Link generously** — any concept that could plausibly become its own note deserves brackets.
2. **Don't pre-create stub notes**. A red `[[Future Note]]` is fine; Obsidian users expect them.
3. **MOC entries use H2 grouping**: don't just dump a flat bullet list — group by topic with H2 headings and short callouts at the top of each group.
4. **Embed sparingly, link generously**. Embeds are visual weight; reserve them for content the reader genuinely needs to see in context (a definition, a status callout, a key chart).
5. **In frontmatter**, related-note arrays use `"[[Note]]"` (quoted) so YAML doesn't mis-parse the brackets.
