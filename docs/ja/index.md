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
通知履歴は通知抑制中も表示されます。アプリごとにまとめ、初期状態では折りたたんで最新のプレビューを表示します。グループを開き、タイトルを選ぶと全文を読めます。グループ単位または履歴全体を削除できます。更新時も展開状態を維持します。ポップアップの幅は 200–340 px、高さは内容に応じて最大 100 px です。通知は超過件数の表示とともに最大2件表示されます。通知抑制中はテーマの再読み込みを引き続き延期します。

```ini
dmenu = /usr/bin/argvus notification-action-picker
```
