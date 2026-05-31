# Canvas (`.canvas` files)

Canvas is Obsidian's native infinite-canvas plugin. Files are saved as `.canvas` and use a documented, open JSON format (the **JSON Canvas spec**). Drop one into your vault and Obsidian opens it as a board.

The skill produces these as **complete, valid JSON** — never descriptions, never placeholders. Save the JSON to `Whatever.canvas` and open it.

## 1. Top-level structure

```json
{
  "nodes": [],
  "edges": []
}
```

That's the whole shape: an object with two arrays. `nodes` are the cards, `edges` are the arrows. Order of items in each array doesn't affect rendering.

## 2. Node types

Every node has these shared fields, then type-specific ones.

### Shared fields (all node types)

| Field | Type | Required | Notes |
|---|---|---|---|
| `id` | string | yes | Unique within the file. Anything stable — UUID, slug, sequence (`n1`, `n2`). |
| `type` | string | yes | One of: `text` `file` `link` `group`. |
| `x` | number | yes | X coordinate of the top-left, in canvas units (≈ pixels). |
| `y` | number | yes | Y coordinate of the top-left. |
| `width` | number | yes | In canvas units. |
| `height` | number | yes | In canvas units. |
| `color` | string | no | `"1"`–`"6"` for preset colors, or `"#hex"` for custom. |

Color palette (string keys):

| Key | Color |
|---|---|
| `"1"` | red |
| `"2"` | orange |
| `"3"` | yellow |
| `"4"` | green |
| `"5"` | cyan |
| `"6"` | purple |

### `type: "text"` — standalone card containing markdown

```json
{
  "id": "n1",
  "type": "text",
  "x": 0, "y": 0,
  "width": 400, "height": 200,
  "color": "4",
  "text": "## Card title\n\nBody can use **markdown**, [[wikilinks]], and even ![[images]]."
}
```

`text` is the only type-specific field — it's a markdown string. Newlines as `\n`.

### `type: "file"` — references a note or attachment in the vault

```json
{
  "id": "n2",
  "type": "file",
  "x": 500, "y": 0,
  "width": 400, "height": 300,
  "file": "Projects/Q4 GTM Plan/_README.md"
}
```

`file` is a path **relative to the vault root**, including the extension. Works for `.md`, images, PDFs, audio, video, `.canvas`, `.base`. Embedding a `.canvas` lets you nest canvases.

Optional: `subpath` for jumping to a specific heading or block within the file:

```json
{
  "id": "n3",
  "type": "file",
  "x": 0, "y": 400,
  "width": 400, "height": 200,
  "file": "Notes/Concepts.md",
  "subpath": "#Linking strategy"
}
```

### `type: "link"` — external URL card

```json
{
  "id": "n4",
  "type": "link",
  "x": 1000, "y": 0,
  "width": 400, "height": 300,
  "url": "https://help.obsidian.md/canvas"
}
```

Renders as a card showing the URL preview when available.

### `type: "group"` — visual container for related nodes

```json
{
  "id": "g1",
  "type": "group",
  "x": -50, "y": -50,
  "width": 500, "height": 700,
  "label": "Inbox",
  "color": "3"
}
```

Groups are visual rectangles that other nodes can sit inside. They have a `label` and an optional `background` image. Moving a group moves the nodes inside it. Use groups for swim lanes, pipeline stages, or topic clusters.

Optional `background` field for a group with an image backdrop:

```json
{
  "id": "g2",
  "type": "group",
  "x": 0, "y": 0,
  "width": 800, "height": 600,
  "label": "Vision board",
  "background": "Attachments/vision.png",
  "backgroundStyle": "cover"
}
```

`backgroundStyle` may be `"cover"`, `"ratio"`, or `"repeat"`.

## 3. Edge schema

Edges connect two nodes by `id`.

```json
{
  "id": "e1",
  "fromNode": "n1",
  "toNode": "n2",
  "fromSide": "right",
  "toSide": "left",
  "label": "Triggers",
  "color": "4"
}
```

| Field | Type | Required | Notes |
|---|---|---|---|
| `id` | string | yes | Unique within the file. |
| `fromNode` | string | yes | ID of source node. |
| `toNode` | string | yes | ID of target node. |
| `fromSide` | string | no | `"top"` `"right"` `"bottom"` `"left"`. Optional — auto-routes if omitted. |
| `toSide` | string | no | Same as above. |
| `fromEnd` | string | no | `"none"` or `"arrow"`. Default `"none"`. |
| `toEnd` | string | no | `"none"` or `"arrow"`. Default `"arrow"`. |
| `label` | string | no | Text shown on the edge. |
| `color` | string | no | Same palette as nodes. |

## 4. Coordinate system

- Origin is wherever you place it; the canvas extends infinitely in all directions.
- Positive `x` is right, positive `y` is **down** (screen coordinates).
- Default unit is roughly 1 pixel at 100% zoom — typical card widths are 250–500.
- Leave 60–120 units of padding between cards so the user can lay arrows cleanly.

## 5. Layout strategies — pick one before placing nodes

The skill should choose layout based on the intent of the canvas:

| Intent | Layout | How to place |
|---|---|---|
| Pipeline / process | **Swim lane (horizontal)** | Cards left → right. One vertical column per stage. Optional `group` nodes wrapping each column with stage label. |
| Brainstorm / mind map | **Hub & spoke** | Central node at (0,0). Children radiating in a circle at radius ~600. Sub-children at radius ~1100. |
| Hierarchy / org chart | **Tree top-down** | Root at top. Children below, balanced by subtree width. |
| Status board (Kanban) | **Swim lane (vertical columns)** | One `group` per column ("Todo", "Doing", "Done"). Cards stacked inside. |
| Comparison / matrix | **2D grid** | Equal-spaced rows × cols. No edges. |
| Argument map / debate | **Tree with labeled edges** | Claim at top, evidence below, attacks across. Use `label` on edges (`supports`, `attacks`). |

### Spacing defaults Claude uses

- Card width: 360
- Card height: 200 (text), 300 (file embeds)
- Horizontal gap between columns in swim lanes: 100
- Vertical gap between stacked cards: 60
- Padding inside groups: 40 on all sides

## 6. Complete example — Content creation pipeline (swim lane)

A working `.canvas` Claude can produce for the prompt *"Build me an Obsidian canvas for a content creation pipeline"*. Save as `Content Pipeline.canvas`.

```json
{
  "nodes": [
    { "id": "g-ideas",     "type": "group", "x": -40,   "y": -40, "width": 440, "height": 760, "label": "1. Ideas",     "color": "3" },
    { "id": "g-drafting",  "type": "group", "x": 460,   "y": -40, "width": 440, "height": 760, "label": "2. Drafting",  "color": "2" },
    { "id": "g-review",    "type": "group", "x": 960,   "y": -40, "width": 440, "height": 760, "label": "3. Review",    "color": "5" },
    { "id": "g-scheduled", "type": "group", "x": 1460,  "y": -40, "width": 440, "height": 760, "label": "4. Scheduled", "color": "4" },
    { "id": "g-published", "type": "group", "x": 1960,  "y": -40, "width": 440, "height": 760, "label": "5. Published", "color": "6" },

    { "id": "n-idea-1",   "type": "text", "x": 0,    "y": 20,  "width": 360, "height": 160, "color": "3", "text": "## The cost of distraction\n\nAngle: how meetings fragment deep work. Cite Newport." },
    { "id": "n-idea-2",   "type": "text", "x": 0,    "y": 220, "width": 360, "height": 160, "color": "3", "text": "## How I run weekly reviews\n\nWalkthrough of the actual ritual. Screenshot the template." },
    { "id": "n-idea-3",   "type": "text", "x": 0,    "y": 420, "width": 360, "height": 160, "color": "3", "text": "## Why I left Notion for Obsidian\n\nPersonal POV. Risky — fact-check before publishing." },

    { "id": "n-draft-1",  "type": "file", "x": 500,  "y": 20,  "width": 360, "height": 240, "file": "2 Drafts/The cost of distraction.md" },
    { "id": "n-draft-2",  "type": "file", "x": 500,  "y": 290, "width": 360, "height": 240, "file": "2 Drafts/How I run weekly reviews.md" },

    { "id": "n-review-1", "type": "text", "x": 1000, "y": 20,  "width": 360, "height": 200, "color": "5", "text": "> [!QUESTION] Does the opening hook work?\n\nFlag for editor." },

    { "id": "n-sched-1",  "type": "file", "x": 1500, "y": 20,  "width": 360, "height": 240, "file": "3 Ready/The cost of distraction.md" },

    { "id": "n-pub-1",    "type": "link", "x": 2000, "y": 20,  "width": 360, "height": 240, "url": "https://example.com/posts/cost-of-distraction" }
  ],
  "edges": [
    { "id": "e1", "fromNode": "n-idea-1",  "toNode": "n-draft-1",  "fromSide": "right", "toSide": "left", "label": "promote", "color": "4" },
    { "id": "e2", "fromNode": "n-idea-2",  "toNode": "n-draft-2",  "fromSide": "right", "toSide": "left", "label": "promote", "color": "4" },
    { "id": "e3", "fromNode": "n-draft-1", "toNode": "n-review-1", "fromSide": "right", "toSide": "left", "label": "ready for edit" },
    { "id": "e4", "fromNode": "n-review-1","toNode": "n-sched-1",  "fromSide": "right", "toSide": "left", "label": "approved", "color": "4" },
    { "id": "e5", "fromNode": "n-sched-1", "toNode": "n-pub-1",    "fromSide": "right", "toSide": "left", "label": "shipped",  "color": "6" }
  ]
}
```

## 7. Common patterns — copy-and-modify recipes

### Hub & spoke (mind map)

```json
{
  "nodes": [
    { "id": "hub", "type": "text", "x": 0,    "y": 0,    "width": 320, "height": 120, "color": "6", "text": "## AI Research" },
    { "id": "s1",  "type": "text", "x": 500,  "y": -200, "width": 280, "height": 100, "text": "## Interpretability" },
    { "id": "s2",  "type": "text", "x": 500,  "y": 0,    "width": 280, "height": 100, "text": "## Alignment" },
    { "id": "s3",  "type": "text", "x": 500,  "y": 200,  "width": 280, "height": 100, "text": "## Evaluations" },
    { "id": "s4",  "type": "text", "x": -700, "y": 0,    "width": 280, "height": 100, "text": "## Open questions" }
  ],
  "edges": [
    { "id": "e1", "fromNode": "hub", "toNode": "s1", "fromSide": "right", "toSide": "left" },
    { "id": "e2", "fromNode": "hub", "toNode": "s2", "fromSide": "right", "toSide": "left" },
    { "id": "e3", "fromNode": "hub", "toNode": "s3", "fromSide": "right", "toSide": "left" },
    { "id": "e4", "fromNode": "hub", "toNode": "s4", "fromSide": "left",  "toSide": "right" }
  ]
}
```

### Kanban (vertical swim lanes)

```json
{
  "nodes": [
    { "id": "g-todo",  "type": "group", "x": 0,    "y": 0, "width": 400, "height": 900, "label": "Todo",  "color": "3" },
    { "id": "g-doing", "type": "group", "x": 440,  "y": 0, "width": 400, "height": 900, "label": "Doing", "color": "2" },
    { "id": "g-done",  "type": "group", "x": 880,  "y": 0, "width": 400, "height": 900, "label": "Done",  "color": "4" },

    { "id": "c1", "type": "text", "x": 20,  "y": 60,  "width": 360, "height": 120, "text": "## Spec the import flow" },
    { "id": "c2", "type": "text", "x": 20,  "y": 200, "width": 360, "height": 120, "text": "## Draft Q4 plan" },
    { "id": "c3", "type": "text", "x": 460, "y": 60,  "width": 360, "height": 120, "text": "## Migrate from Notion" },
    { "id": "c4", "type": "text", "x": 900, "y": 60,  "width": 360, "height": 120, "text": "## Set up daily notes" }
  ],
  "edges": []
}
```

## 8. Output rules for Claude

1. **Always emit a complete file**: top-level `{ "nodes": [...], "edges": [...] }`. Never partial fragments.
2. **All `id` values must be unique strings** within the file.
3. **All `fromNode`/`toNode` in edges must match an existing node id**.
4. **No trailing commas, no JS comments inside the JSON**. It is strict JSON.
5. **Fence the block as ` ```json`** and add a comment line *outside* the JSON noting the filename: `// Save as: Content Pipeline.canvas`.
6. **Layout matters**: lay out the nodes deliberately. A pile of overlapping cards at (0,0) is broken output. Pick a layout strategy from §5 and follow it.
7. **Use colors meaningfully**: pipeline stages → different colors; risks → red (`"1"`); approved → green (`"4"`).
8. **Card text is markdown**: use `## Heading`, `[[wikilinks]]`, callouts. The whole point is leverage.
