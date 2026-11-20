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
El historial permanece visible con No molestar. Las notificaciones se agrupan por aplicación, contraídas inicialmente con la vista previa más reciente. Expanda un grupo y seleccione un título para leer el texto completo. Puede borrar un grupo o todo el historial. Las actualizaciones conservan los grupos abiertos. Los avisos tienen 200–340 px de ancho y altura dinámica hasta 100 px; pueden aparecer dos junto al indicador de avisos adicionales. La recarga del tema sigue aplazada con No molestar.

```ini
dmenu = /usr/bin/argvus notification-action-picker
```
