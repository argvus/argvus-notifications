---
title: 通知
description: 使用通知和免打扰控制。
---
`argvus-notifications` 提供通知命令和 Dunst 配置。它的公共接口包括：

```sh
argvus notifications status
argvus notifications dnd status
argvus notifications dnd on
argvus notifications dnd off
argvus notifications dnd toggle
```
通知服务由 `argvus-session` 启动；控制面板显示通知状态和控制。当免打扰模式激活时，Dunst 会将收到的通知保留以便稍后处理，而 ARGVUS 会关闭屏幕上已经显示的任何弹出窗口。控制面板会隐藏其通知列表，直到免打扰模式被关闭。主题更改会推迟 Dunst 的重载，直到免打扰模式关闭，因此更改主题不会禁用它。
