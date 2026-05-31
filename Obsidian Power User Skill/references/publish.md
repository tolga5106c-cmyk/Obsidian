# Obsidian Publish

Obsidian Publish turns a vault (or a subset of it) into a static website you control. Paid add-on, billed per site. The skill produces ready-to-paste frontmatter and configuration; it doesn't manage the user's account.

## 1. Setup

1. Subscribe to Obsidian Publish (Settings → Account → Publish).
2. In the vault, open Command Palette → **"Publish: Publish changes"** for the first time → it prompts you to create or attach a site.
3. Choose which notes to start publishing — you can publish all, or pick a subset (recommended for early publishes).
4. After the first publish, the **Publish** icon in the ribbon (cloud icon) opens a dialog showing changed/added/removed notes since last publish, with checkboxes for what to push.

## 2. Managing multiple sites

A single vault can be attached to multiple Publish sites. Useful when one vault holds both personal and team content.

- Command Palette → "Publish: Switch site".
- Each site has its own list of published notes.

## 3. Customizing the site

### Custom CSS

Add a file named **`publish.css`** at the root of the vault. Obsidian Publish picks it up automatically on the next publish and applies it to the site. Use this for:

- Brand colors (override accent + body background).
- Maximum content width, line height.
- Custom callout styles tailored for web reading.
- Hiding elements you don't want public (`.published-only-hidden`).

### Navigation

The site's left navigation comes from a special file at the vault root: **`navigation.md`**. Edit it manually to set the order and grouping. Example:

```markdown
- [[Home]]
- [[About]]
- Topics
  - [[Productivity]]
  - [[Writing]]
- [[Now]]
```

Indented bullets become nested navigation. Notes you don't reference in `navigation.md` are still reachable via search or links, just not in the sidebar.

### Logo and favicon

In **Publish settings** (gear icon inside the Publish dialog):

- *Site logo*: upload an image; appears top-left.
- *Favicon*: upload `.ico` or `.png`.
- *Site name*: appears as the page title and in the browser tab.

## 4. Publishing content

### Per-note actions

- Right-click a note → **Publish** or **Unpublish**.
- Inside the editor, the status bar shows whether the current note is published or has unpublished changes.

### Bulk actions

The Publish dialog (cloud icon) shows every changed/added/removed note since the last publish. Check what you want to push, click "Publish".

### Controlling what appears in navigation

A note can be published *without* appearing in the sidebar — just leave it out of `navigation.md`. Useful for "private but linkable" pages.

## 5. Collaboration

Invite collaborators in the Publish web dashboard. They get access to:

- The Publish settings (logo, custom domain, etc.).
- Publish/unpublish actions from their own vault, *if* they have a copy of the same vault.

There's no "team editing" of the live site itself — content edits still happen in someone's local vault and get pushed.

## 6. Social media link previews (Open Graph)

The site honors a few frontmatter properties to control Open Graph tags:

```yaml
---
title: "The cost of distraction"
description: "Why meetings fragment deep work — and what a Friday afternoon ritual fixes."
image: "Attachments/cost-of-distraction-cover.png"
---
```

- `title` → `<title>` tag and `og:title`.
- `description` → meta description and `og:description`. Keep under ~150 characters; longer gets truncated by most platforms.
- `image` → vault-relative path to the social card image; rendered as `og:image`. Optimum size: 1200×630.

Without these, the site falls back to the note's H1 and first paragraph.

## 7. Media files

- Images, audio, video referenced in published notes get uploaded with the publish.
- File size limit per asset is generous (in the tens of MB), but the total site has a quota — check the Publish dashboard.
- For large videos, host externally (YouTube, Vimeo) and embed via iframe rather than uploading the raw file.

## 8. Analytics

Built into the Publish dashboard at a basic level (page views, top pages). For more:

- *Google Analytics*: Publish settings → Analytics → paste your Measurement ID (`G-XXXXXXX`).
- *Plausible*: Publish settings → Analytics → paste your Plausible domain.

Both work via standard tags injected into the page; no other setup.

## 9. Custom domain

- Publish settings → **Custom domain**.
- Enter `notes.yourname.com` (or your apex `yourname.com`).
- Obsidian shows you the DNS record to add at your registrar — typically a `CNAME` pointing to `publish.obsidian.md`.
- Wait for DNS to propagate (a few minutes to a few hours). SSL is provisioned automatically once propagation completes.

## 10. Permalinks

By default, the URL of a published note is derived from its filename (slugified). Override with:

```yaml
---
permalink: "writing/cost-of-distraction"
---
```

That note will live at `https://your-site.com/writing/cost-of-distraction` regardless of its filename or folder location.

Use permalinks for:

- Stable URLs that survive renaming the file.
- Hand-crafted slugs.
- Building a clean URL structure independent of the vault's folder hierarchy.

## 11. SEO

The basics, baked into the site:

- `title:` and `description:` in frontmatter drive `<title>` and meta description.
- `cover:` or `image:` drive the og:image.
- Canonical URLs are auto-set to the Publish URL of each note.
- Heading hierarchy (H1, H2, H3) is preserved → use real H1s.
- Internal `[[wikilinks]]` resolve to relative URLs — great for site-internal SEO.

Recommended SEO frontmatter pattern for any published note:

```yaml
---
title: "Cost of Distraction"
description: "Why meetings fragment deep work — and a Friday ritual that fixes it."
image: "Attachments/cost-of-distraction-cover.png"
permalink: "writing/cost-of-distraction"
publish-date: 2026-05-01
tags: [writing, productivity]
---
```

## 12. Security & privacy

- **Site password protection**: Publish settings → "Password protection" → set a password. Visitors must enter it before any content loads.
- **Per-note privacy**: just don't publish the note. Published notes are public by default; unpublished notes are not on the server at all.
- **Excluding folders**: Publish settings → "Excluded folders" → list folders that should never be published, even if you accidentally check a note in them.

## 13. Limitations to flag

- **Plugins don't run on the Publish site.** A note that uses a Dataview query or a Bases view will render as raw text or with a placeholder. Convert dynamic content to static before publishing, or document the limitation.
- **Templater code blocks** show as raw `<% ... %>` to readers. Strip or transform them before publishing.
- **Some callout types may render with a different color** than your local theme (the Publish theme is its own CSS). Customize via `publish.css` if you need pixel parity.
- **Local CSS snippets don't apply to Publish** — you have to put the styles in `publish.css`.
- **Mermaid and math** are supported.
- **PDFs** display as a download link rather than an inline viewer.

## 14. Pattern Claude follows when setting up a Publish site

When asked "set up Obsidian Publish for my digital garden", produce:

1. A short setup checklist (steps 1–4 in §1 above).
2. A `navigation.md` starter that includes Home, About, an MOC or two, and a Now page.
3. A `publish.css` starter with sane defaults (slightly wider body, comfy line height, prominent callout colors).
4. A frontmatter template (see §11) for the user's content notes.
5. A short note on what to set in the Publish dashboard: site name, logo, favicon, custom domain, analytics.
6. The privacy gotcha: confirm what's excluded.

### Starter `publish.css`

```css
/* publish.css — drop this at the vault root */

:root {
  --pub-accent: #4e7eff;
  --pub-bg: #fbfbfa;
  --pub-text: #1a1a1a;
  --pub-muted: #6b6b6b;
  --pub-body-max: 720px;
}

body {
  background: var(--pub-bg);
  color: var(--pub-text);
}

.published-container {
  max-width: var(--pub-body-max);
  line-height: 1.7;
  font-size: 17px;
}

h1, h2, h3 {
  letter-spacing: -0.01em;
}

a {
  color: var(--pub-accent);
  text-decoration: none;
  border-bottom: 1px solid currentColor;
}
a:hover { opacity: 0.8; }

.callout {
  border-radius: 8px;
  padding: 1em 1.2em;
}

/* Hide the "edit on Obsidian" hover if you want a cleaner look */
.published-callout-hover-action { display: none; }
```

### Starter `navigation.md`

```markdown
- [[Home]]
- [[Now]]
- Writing
  - [[_MOC — Writing]]
- Notes
  - [[_MOC — Notes]]
- [[About]]
- [[Colophon]]
```

### Starter content frontmatter

```yaml
---
title: "Working title"
description: "One sentence, under 150 chars."
image: "Attachments/cover.png"
permalink: "writing/working-title"
publish-date: 2026-05-15
tags: [writing]
status: draft
---
```

Move `status: draft` → `published` (or remove it) when you actually publish.
