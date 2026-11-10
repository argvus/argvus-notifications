---
title: Notificaciones
description: Usa los controles de notificación y no molestar.
---
`argvus-notifications` proporciona el comando de notificación y la configuración de Dunst. Su interfaz pública incluye:

```sh
argvus notifications status
argvus notifications dnd status
argvus notifications dnd on
argvus notifications dnd off
argvus notifications dnd toggle
```
El servicio de notificaciones es iniciado por `argvus-session`; el Panel de Control expone el estado de las notificaciones y sus controles. Mientras No Molestar está activo, Dunst guarda las notificaciones entrantes para más tarde y ARGVUS cierra cualquier ventana emergente ya presente en la pantalla. El Panel de Control oculta su lista de notificaciones hasta que No Molestar se desactiva. Los cambios de tema difieren la recarga de Dunst hasta que No Molestar se apague, por lo que cambiar de tema no lo desactiva.
