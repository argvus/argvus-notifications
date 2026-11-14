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
L’historique reste visible en mode Ne pas déranger. Les notifications sont regroupées par application, repliées initialement avec le dernier aperçu. Dépliez un groupe puis sélectionnez un titre pour lire le texte complet. Effacez un groupe ou tout l’historique. Les actualisations conservent les groupes ouverts. Les fenêtres mesurent 200–340 px de large et jusqu’à 100 px de haut, avec une hauteur dynamique ; deux notifications peuvent accompagner l’indicateur de dépassement. Le rechargement du thème reste différé en mode Ne pas déranger.
