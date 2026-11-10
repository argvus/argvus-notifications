---
title: 알림
description: 알림 및 방해 금지 제어를 사용하세요.
---
`argvus-notifications`는 알림 명령과 Dunst 구성을 제공합니다. 그 공개 인터페이스에는 다음이 포함됩니다:

```sh
argvus notifications status
argvus notifications dnd status
argvus notifications dnd on
argvus notifications dnd off
argvus notifications dnd toggle
```
알림 서비스는 `argvus-session`에 의해 시작됩니다; 제어판은 알림 상태와 제어 기능을 제공합니다. 방해 금지 모드가 활성화된 동안 Dunst는 들어오는 알림을 나중을 위해 보관하고 ARGVUS는 이미 화면에 있는 팝업을 닫습니다. 제어판은 방해 금지 모드가 해제될 때까지 알림 목록을 숨깁니다. 테마 변경은 방해 금지 모드가 해제될 때까지 Dunst 재로드를 연기하므로, 테마를 변경해도 방해 금지 모드가 비활성화되지는 않습니다.
