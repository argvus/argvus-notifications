---
title: Benachrichtigungen
description: Verwenden Sie Benachrichtigungs- und Nicht-stören-Steuerungen.
---
`argvus-notifications` stellt den Benachrichtigungsbefehl und die Dunst-Konfiguration bereit. Sein öffentliches Interface umfasst:

```sh
argvus notifications status
argvus notifications dnd status
argvus notifications dnd on
argvus notifications dnd off
argvus notifications dnd toggle
```
Der Verlauf bleibt bei „Nicht stören“ sichtbar. Benachrichtigungen werden nach Anwendung gruppiert und zunächst mit der neuesten Vorschau eingeklappt. Eine Gruppe aufklappen und einen Titel auswählen, um den vollständigen Text zu lesen. Einzelne Gruppen oder den gesamten Verlauf löschen. Aktualisierungen erhalten geöffnete Gruppen. Pop-ups sind 200–340 px breit und dynamisch bis zu 100 px hoch; zwei Meldungen können neben der Überlaufanzeige erscheinen. Das Neuladen des Designs wird bei „Nicht stören“ weiterhin verschoben.
