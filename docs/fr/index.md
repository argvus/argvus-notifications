---
title: Notifications
description: Utilisez les contrôles de notification et de ne pas déranger.
---
`argvus-notifications` fournit la commande de notification et la configuration de Dunst. Son interface publique comprend :

```sh
argvus notifications status
argvus notifications dnd status
argvus notifications dnd on
argvus notifications dnd off
argvus notifications dnd toggle
```
Le service de notification est démarré par `argvus-session` ; le Panneau de configuration expose l'état des notifications et les contrôles. Lorsque Ne pas déranger est actif, Dunst conserve les notifications entrantes pour plus tard et ARGVUS ferme toutes les fenêtres pop-up déjà à l'écran. Le Panneau de configuration cache sa liste de notifications jusqu'à ce que Ne pas déranger soit désactivé. Les changements de thème différent le rechargement de Dunst jusqu'à ce que Ne pas déranger soit désactivé, donc changer de thème ne le désactive pas.
