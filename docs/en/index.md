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

Notification history remains visible during Do Not Disturb. Entries are grouped by application and collapsed initially, with the latest preview. Expand a group to browse its messages, then select a title to read the full text. Clear one group or the entire history. Updates preserve expanded groups. Pop-ups use a width of 200–340 px and dynamic height up to 100 px; two notifications can appear alongside the overflow indicator. Theme reload remains deferred during Do Not Disturb.
