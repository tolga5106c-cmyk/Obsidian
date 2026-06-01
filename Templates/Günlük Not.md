<%*
const date = tp.date.now("YYYY-MM-DD");
const dayName = tp.date.now("dddd");
const longDate = tp.date.now("D MMMM YYYY");
-%>
---
title: "<% date %>"
date: <% date %>
type: daily
tags: [gunluk, journal]
ruh_hali:
enerji:
hava:
---

# <% dayName %>, <% longDate %>

> [!ABSTRACT]+ Bugünün niyeti
> Bugünü başarılı kılan üç şey:
> 1. 
> 2. 
> 3. 

## Görevler

- [ ] 

## Notlar & Yakalamalar

<% tp.file.cursor() %>

## Kararlar

- 

## Kazanımlar

- 

## Öğrendiklerim

- 

## Yansımalar

> [!QUESTION]- Yarınki ben bugün ne için teşekkür eder?

> [!QUESTION]- Beni ne harcattı?

## Yarın

- [ ] 

---

%% Dün: [[<% tp.date.yesterday("YYYY-MM-DD") %>]] · Yarın: [[<% tp.date.tomorrow("YYYY-MM-DD") %>]] %%
