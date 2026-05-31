<%*
const title = await tp.system.prompt("Fikrin başlığı:");
const id = tp.date.now("YYYYMMDDHHmm");
await tp.file.rename(`${id} — ${title}`);
-%>
---
title: "<% title %>"
fikir_id: <% id %>
created: <% tp.date.now("YYYY-MM-DD") %>
tags: [fikir]
type: permanent
status: active
---

# <% title %>

> [!ABSTRACT]+ Ana İddia
> _(Bu notun tek cümlelik özü nedir?)_

## Kendi Kelimelerimle

<% tp.file.cursor() %>

## Neden Önemli?

> [!INFO] Peki ne olmuş?
> 

## Bağlantılar

- Üzerine inşa edildi: [[ ]]
- Bununla çelişiyor: [[ ]]
- İlgili: [[ ]]
- Kaynak: [[ ]]

## Açık Sorular

> [!QUESTION] Hala neyi bilmiyorum?
> 

---

%% <% id %> %%
