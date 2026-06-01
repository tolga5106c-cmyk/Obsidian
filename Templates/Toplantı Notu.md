<%*
const title = await tp.system.prompt("Toplantı başlığı:");
const date = tp.date.now("YYYY-MM-DD");
const meetingType = await tp.system.suggester(
  ["1:1", "Standup", "İnceleme", "Planlama", "Retro", "Müşteri", "Diğer"],
  ["1on1", "standup", "inceleme", "planlama", "retro", "musteri", "diger"]
);
await tp.file.rename(`${date} — ${title}`);
-%>
---
title: "<% title %>"
date: <% date %>
type: meeting
toplanti_turu: <% meetingType %>
katilimcilar: []
tags: [toplanti, <% meetingType %>]
status: planli
---

# <% title %>

**Tarih:** <% date %>
**Tür:** <% meetingType %>
**Katılımcılar:** 

> [!ABSTRACT]+ Özet
> _(Toplantı bittikten sonra tek cümleyle sonucu yaz)_

## Gündem

- 

## Notlar

<% tp.file.cursor() %>

## Alınan Kararlar

> [!SUCCESS]+ Kararlar
> - 

## Eylem Maddeleri

- [ ] 

## Açık Sorular

> [!QUESTION]- Bekleyen sorular
> - 

## İlgili Notlar

- 

---

%% Oluşturuldu: <% date %> · Tür: <% meetingType %> %%
