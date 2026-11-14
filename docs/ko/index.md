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
방해 금지 중에도 알림 기록을 표시합니다. 앱별로 묶어 기본적으로 접고 최신 미리보기를 표시합니다. 그룹을 펼친 뒤 제목을 선택하면 전체 내용을 읽을 수 있습니다. 그룹 또는 전체 기록을 지울 수 있습니다. 갱신해도 펼친 그룹을 유지합니다. 팝업 너비는 200–340 px이며 높이는 내용에 따라 최대 100 px입니다. 초과 알림 표시와 함께 최대 두 알림을 표시합니다. 방해 금지 중에는 테마 재적용을 계속 미룹니다.
