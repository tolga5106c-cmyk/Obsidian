<%*
const title = await tp.system.prompt("Meeting title:");
const attendeesRaw = await tp.system.prompt("Attendees (comma-separated):", "");
const date = tp.date.now("YYYY-MM-DD");
const meetingType = await tp.system.suggester(
  ["1:1", "Standup", "Review", "Planning", "Retro", "Interview", "External"],
  ["1on1", "standup", "review", "planning", "retro", "interview", "external"]
);
await tp.file.rename(`${date} — ${title}`);
const attendeesYaml = attendeesRaw
  .split(",")
  .map(a => a.trim())
  .filter(Boolean)
  .map(a => `"[[People/${a}]]"`)
  .join(", ");
-%>
---
title: "<% title %>"
date: <% date %>
type: meeting
meeting_type: <% meetingType %>
attendees: [<% attendeesYaml %>]
tags: [meeting, <% meetingType %>]
status: scheduled
---

# <% title %>

**Date:** <% date %>
**Type:** <% meetingType %>
**Attendees:** <% attendeesRaw %>

> [!ABSTRACT]+ TL;DR
> _(one-line outcome — fill after the meeting)_

## Agenda

- 

## Notes

<% tp.file.cursor() %>

## Decisions

> [!SUCCESS]+ Decisions
> - 

## Action items

- [ ] 

## Follow-ups & open questions

> [!QUESTION]- Open
> - 

## Related

- 

---

%% Created <% date %> · Type: <% meetingType %> %%
