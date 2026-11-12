---
title: Thông báo
description: Sử dụng thông báo và các điều khiển không làm phiền.
---

`argvus-notifications` cung cấp lệnh thông báo và cấu hình Dunst. Giao diện công khai của nó bao gồm:

```sh
argvus notifications status
argvus notifications dnd status
argvus notifications dnd on
argvus notifications dnd off
argvus notifications dnd toggle
```

Dịch vụ thông báo được khởi động bởi `argvus-session`; Bảng Điều khiển hiển thị trạng thái thông báo và các điều khiển. Khi chế độ Không Làm Phiền đang hoạt động, Dunst giữ các thông báo đến để xử lý sau và ARGVUS đóng bất kỳ cửa sổ pop-up nào đã xuất hiện trên màn hình. Bảng Điều khiển ẩn danh sách thông báo của nó cho đến khi chế độ Không Làm Phiền được tắt. Thay đổi giao diện trì hoãn việc tải lại Dunst cho đến khi chế độ Không Làm Phiền được tắt, vì vậy việc thay đổi giao diện không vô hiệu hóa nó.
