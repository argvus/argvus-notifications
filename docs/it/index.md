---
title: Notifiche
description: Usa i controlli delle notifiche e della modalità Non disturbare.
---
`argvus-notifications` fornisce il comando di notifica e la configurazione di Dunst. La sua interfaccia pubblica include:

```sh
argvus notifications status
argvus notifications dnd status
argvus notifications dnd on
argvus notifications dnd off
argvus notifications dnd toggle
```
Il servizio di notifica è avviato da `argvus-session`; il Pannello di Controllo espone lo stato delle notifiche e i controlli. Quando Non Disturbare è attivo, Dunst conserva le notifiche in arrivo per dopo e ARGVUS chiude eventuali popup già presenti sullo schermo. Il Pannello di Controllo nasconde la sua lista di notifiche fino a quando Non Disturbare non viene disattivato. Le modifiche al tema differiscono il riavvio di Dunst fino a quando Non Disturbare non viene disattivato, quindi cambiare tema non lo disabilita.
