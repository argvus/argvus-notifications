---
title: Notifications
description: Use notification and do-not-disturb controls.
---

`argvus-notifications` provides the notification command and Dunst configuration. Its public interface includes:

```sh
argvus-notifications status
argvus-notifications dnd status
argvus-notifications dnd on
argvus-notifications dnd off
argvus-notifications dnd toggle
```

The notification service is started by `argvus-session`; the Control Panel exposes notification state and controls.
