---
title: 通知
description: 通知とおやすみモードのコントロールを使用してください。
---
`argvus-notifications` は通知コマンドと Dunst の設定を提供します。その公開インターフェースには以下が含まれます:

```sh
argvus notifications status
argvus notifications dnd status
argvus notifications dnd on
argvus notifications dnd off
argvus notifications dnd toggle
```
通知サービスは`argvus-session`によって起動されます。コントロールパネルは通知の状態とコントロールを表示します。おやすみモードが有効な間、Dunstは着信通知を後で表示するために保持し、ARGVUSはすでに画面に表示されているポップアップを閉じます。コントロールパネルはおやすみモードがオフになるまで通知リストを非表示にします。テーマの変更はDunstのリロードをおやすみモードがオフになるまで延期するため、テーマを変更してもおやすみモードは無効になりません。
