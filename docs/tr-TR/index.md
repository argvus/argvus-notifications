---
title: Bildirimler
description: Bildirim ve rahatsız etme modunu kontrol etmek için kullanın.
---

`argvus-notifications` bildirim komutunu ve Dunst yapılandırmasını sağlar. Genel arayüzü şunları içerir:

```sh
argvus notifications status
argvus notifications dnd status
argvus notifications dnd on
argvus notifications dnd off
argvus notifications dnd toggle
```

Bildirim servisi `argvus-session` tarafından başlatılır; Kontrol Paneli bildirim durumunu ve kontrolleri gösterir. Rahatsız Etmeyin modu etkinken, Dunst gelen bildirimleri daha sonra göstermek üzere saklar ve ARGVUS ekranda zaten açık olan herhangi bir açılır pencereyi kapatır. Kontrol Paneli, Rahatsız Etmeyin kapatılana kadar bildirim listesini gizler. Tema değişiklikleri, Rahatsız Etmeyin kapatılana kadar Dunst yeniden yüklemesini erteler, böylece temaları değiştirmek bunu devre dışı bırakmaz.
