---
title: Pemberitahuan
description: Gunakan kontrol notifikasi dan jangan ganggu.
---

`argvus-notifications` menyediakan perintah notifikasi dan konfigurasi Dunst. Antarmuka publiknya meliputi:

```sh
argvus notifications status
argvus notifications dnd status
argvus notifications dnd on
argvus notifications dnd off
argvus notifications dnd toggle
```

Layanan notifikasi dijalankan oleh `argvus-session`; Panel Kontrol menampilkan status notifikasi dan kontrolnya. Saat Mode Jangan Ganggu aktif, Dunst menahan notifikasi masuk untuk nanti dan ARGVUS menutup semua pop-up yang sudah muncul di layar. Panel Kontrol menyembunyikan daftar notifikasinya hingga Mode Jangan Ganggu dimatikan. Perubahan tema menunda pemuatan ulang Dunst hingga Mode Jangan Ganggu dimatikan, sehingga mengubah tema tidak menonaktifkannya.
