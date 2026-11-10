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
Der Benachrichtigungsdienst wird von `argvus-session` gestartet; das Bedienfeld zeigt den Benachrichtigungsstatus und Steuerungen an. Während "Nicht stören" aktiv ist, bewahrt Dunst eingehende Benachrichtigungen für später auf und ARGVUS schließt alle bereits auf dem Bildschirm befindlichen Pop-ups. Das Bedienfeld verbirgt seine Benachrichtigungsliste, bis "Nicht stören" deaktiviert wird. Themenänderungen verzögern das Neuladen von Dunst, bis "Nicht stören" ausgeschaltet wird, sodass das Ändern von Themen es nicht deaktiviert.
