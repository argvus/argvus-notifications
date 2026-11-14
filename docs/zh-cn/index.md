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
勿扰模式下历史记录仍然可见。通知按应用分组，默认折叠并显示最新预览。展开分组后选择标题即可阅读完整内容。可以清除单个分组或全部历史。更新保留已展开的分组。弹窗宽度为 200–340 px，高度动态调整至最多 100 px；最多两条通知与溢出提示同时显示。勿扰期间仍推迟重新加载主题。
