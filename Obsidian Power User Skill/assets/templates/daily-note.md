<%*
const date = tp.date.now("YYYY-MM-DD");
const dayName = tp.date.now("dddd");
const longDate = tp.date.now("MMMM D, YYYY");
-%>
---
title: "<% date %>"
date: <% date %>
type: daily
tags: [daily, journal]
mood:
energy:
focus_score:
weather:
---

# <% dayName %>, <% longDate %>

> [!ABSTRACT]+ Today's intention
> The three things that, if done, make this a good day:
> 1. 
> 2. 
> 3. 

## Schedule

> [!INFO]+ Calendar
> - [ ] 

## Morning pages

<% tp.file.cursor() %>

## Tasks

- [ ] 

## Notes & captures

## Decisions made today

- 

## Wins

- 

## What I learned

- 

## Reflections

> [!QUESTION]- What would tomorrow's me thank me for?

> [!QUESTION]- What drained me today?

## Tomorrow

- [ ] 

---

%% Yesterday: [[<% tp.date.yesterday("YYYY-MM-DD") %>]] · Tomorrow: [[<% tp.date.tomorrow("YYYY-MM-DD") %>]] · Week: [[<% tp.date.now("YYYY-[W]ww") %>]] %%
