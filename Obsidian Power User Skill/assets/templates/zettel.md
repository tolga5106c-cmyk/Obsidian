<%*
const title = await tp.system.prompt("Note title:");
const id = tp.date.now("YYYYMMDDHHmm");
await tp.file.rename(`${id} — ${title}`);
-%>
---
title: "<% title %>"
zettel_id: <% id %>
created: <% tp.date.now("YYYY-MM-DD") %>
tags: [zettel]
type: permanent
status: active
---

# <% title %>

> [!ABSTRACT]+ Claim
> _(one sentence — the single idea this note is about)_

## In my own words

<% tp.file.cursor() %>

## Why this matters

> [!INFO] So what?
> 

## Connections

- Builds on: [[ ]]
- Contradicts: [[ ]]
- Related: [[ ]]
- Source: [[ ]]

## Open thread

> [!QUESTION] What's still unclear?
> 

---

%% <% id %> %%
