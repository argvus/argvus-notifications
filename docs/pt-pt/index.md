---
title: Notificações
description: Use notificações e não perturbe.
---

```sh
argvus notifications status
argvus notifications dnd status
argvus notifications dnd on
argvus notifications dnd off
argvus notifications dnd toggle
```

O histórico permanece visível durante o Não Perturbe. As notificações são agrupadas por aplicação, inicialmente recolhidas, com a pré-visualização mais recente. Expanda um grupo para consultar as mensagens e selecione um título para ler o texto completo. Limpe um grupo ou todo o histórico. As atualizações preservam os grupos abertos. Os avisos usam largura de 200–340 px e altura dinâmica até 100 px; duas notificações podem aparecer junto ao indicador de excedentes. A recarga do tema continua adiada durante o Não Perturbe.

```ini
dmenu = /usr/bin/argvus notification-action-picker
```
