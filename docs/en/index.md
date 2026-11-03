---
title: Notifications
description: Use notification and do-not-disturb controls.
---

`argvus-notifications` provides the notification command and Dunst configuration. Its public interface includes:

```sh
argvus notifications status
argvus notifications dnd status
argvus notifications dnd on
argvus notifications dnd off
argvus notifications dnd toggle
```

The notification service is started by `argvus-session`; the Control Panel exposes notification state and controls. While Do Not Disturb is active, Dunst keeps incoming notifications for later and ARGVUS closes any pop-ups already on screen. The Control Panel hides its notification list until Do Not Disturb is turned off. Theme changes defer the Dunst reload until Do Not Disturb is turned off, so changing themes does not disable it.
