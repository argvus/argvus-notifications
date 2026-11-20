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

Geçmiş, Rahatsız Etmeyin açıkken de görünür. Bildirimler uygulamaya göre gruplanır ve başlangıçta son önizlemeyle daraltılır. Grubu genişletip başlığı seçerek tam metni okuyabilirsiniz. Bir grubu veya tüm geçmişi temizleyebilirsiniz. Güncellemeler açık grupları korur. Açılır bildirimler 200–340 px genişliğinde ve dinamik olarak en fazla 100 px yüksekliğindedir; taşma göstergesiyle iki bildirim görünebilir. Tema yeniden yüklemesi Rahatsız Etmeyin sırasında ertelenir.

```ini
dmenu = /usr/bin/argvus notification-action-picker
```
