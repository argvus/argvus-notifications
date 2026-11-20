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
La cronologia resta visibile con Non disturbare. Le notifiche sono raggruppate per applicazione, inizialmente chiuse con l’anteprima più recente. Espandere un gruppo e selezionare un titolo per leggere il testo completo. È possibile cancellare un gruppo o tutta la cronologia. Gli aggiornamenti mantengono i gruppi aperti. Gli avvisi sono larghi 200–340 px e alti fino a 100 px, con altezza dinamica; due notifiche possono affiancare l’indicatore di eccedenza. Il tema viene ancora ricaricato dopo Non disturbare.

```ini
dmenu = /usr/bin/argvus notification-action-picker
```
