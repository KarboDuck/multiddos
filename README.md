# **Multiddos - скрипт объединяющий в себе несколько утилит для ddos**

![multiddos](https://user-images.githubusercontent.com/53382906/161972523-a1197762-a166-45f2-9b68-6e13cc940d99.gif)

### **Особености**:
* Объединяет в себе несколько утилит для ддоса, и для мониторинга (gotop, vnstat)
* Полностью автоматизирован. Автоматическое обновление программ, автоматическая настройка, автоматический запуск, автоматическая смена целей.
* Запуск одной простой командой.
* Наличие нескольких режимов работы (с помощью дополнительных ключей)
* При закрытии терминала или разрыве ssh сессии программы не вылетают, а продолжают работать в фоне. В любой момент multiddos можно снова вывести на экран.
* Работает с несколькими базами на тысячи сайтов/адресов.

### **На данный момент скрипт поддерживает:**
* [Multiddos](https://github.com/KarboDuck/multiddos), ранее известный как auto_mhddos (обвертка для mhddos_proxy) от Украинского Жнеца ([канал](https://t.me/ukrainian_reaper_ddos), [чат](https://t.me/+azRzzKp-STpkMjNi))
* ~~[db1000n ](https://github.com/Arriven/db1000n) от IT ARMY of Ukraine ([канал](https://t.me/itarmyofukraine2022), чат)~~ временно отключено

* Базу сайтов [IT ARMY of Ukraine](https://t.me/itarmyofukraine2022)
* Базу сайтов [DDOS по країні СЕПАРІВ (Кібер-Козаки)](https://t.me/ddos_separ)

### **Пояснение к выбору конкретных утилит**
<details>
<summary>развернуть</summary>
 
Мы хотели собрать утилиты, которые:
* Можно полностью автоматизировать
* Имеют хорошую эффективность и поддерживаются разработчиками
* Умеют работать через прокси

Полностью данным требованиям соответствует только mhddos_proxy. DB1000N не умеет работать через прокси. Поэтому на данном этапе по умолчанию используется только mhddos_proxy.
 
</details>

---
# **Multiddos в docker. Рекомендуется.** (Win, Mac, Linux)

### **Запуск**

1. Скачать и установить [Docker](https://docs.docker.com/get-docker/)

Или быстрые команды для установки:

* Windows 10/11: `winget install -e --id Docker.DockerDesktop`
* MacOS: `brew install docker docker-machine`
* LInux: `sudo apt install docker.io`

2. Запустить multiddos в docker:
```
docker run -it --rm --log-driver none --name multidd --pull always karboduck/multidd
```

* Запуск docker c ключами. <details> Docker версия поддерживает те же ключи, что и bash версия. Прописывайте их точно так же в конце команды. `docker run -it --rm --log-driver none --name multidd --pull always karboduck/multidd --lang en` Подробнее про ключи читайте ниже в разделе **Опции запуска**.

### **Остановка**
1. Нажать в окне несколько раз подряд `Ctrl + C`
2. В другом терминале запустить команду `docker stop multidd`
3. Перезагрузить операционную систему

### **Подключиться обратно, если скрипт работает в фоне**
```
docker attach multidd
```

---
# **Multiddos в bash** (Linux, WSL2)

### **Запуск**

```
curl -LO tiny.one/multiddos && bash multiddos
```

или прямая ссылка, на случай если сокращенная не работает

```
curl -O https://raw.githubusercontent.com/KarboDuck/multiddos/main/multiddos.sh && bash multiddos.sh
```

</details>

### **Остановка**:
1. Нажать в окне несколько раз подряд `Ctrl + C`
2. В другом терминале запустить команду `pkill tmux; pkill node; pkill -f start.py; pkill -f runner.py`
3. Перезагрузить операционную систему

### **Подключиться обратно, если скрипт работает в фоне**
```
tmux a
```
---

## **Опции запуска**

<details>
  <summary>развернуть</summary>
  
Multiddos запускается по умолчанию с gotop и multiddos. Это стандартная конфигурация. Из этой конфигурации можно убрать gotop. Или добавить в нее утилиты: db1000n, vnstat.

Для того, чтобы убрать утилиту используется ключ со знаком "-":

`-g` убрать gotop

Для того, чтобы добавить утилиту используется ключ со знаком "+":

`+d` добавить db1000n

`+v` добавить vnstat -l (мониторинг трафика)

`-p 2000` или `--proxy-threads 2000` Использование этого ключа подключает proxy_finder и задает количество потоков для поиска. Чем выше значение, тем быстрее происходит сканирование и поиск новых прокси, но тем и выше нагрузка на CPU и сеть. Поэтому при больших значениях может падать скорость атак. 

`-t 500` или `--threads 500` задать количество потоков для mhddos_proxy

**Режимы нагрузки в порядке возрастания:**

`--XS` Самый легкий режим работы. Низкая нагрузка на процессор и сеть. Рекомендуется, если компьютер сильно тормозит, а Интернет пропадет. Атакует 1000 целей 1 процессом в 1000 потоков.

`--S` Атакует 1000 целей 1 процессом в 2000 потоков.

`--M` Атакует все цели в базе 2 процессами по 2000 потоков каждый.

`--L` Атакует все цели в базе 2 процессами по 4000 потоков каждый. Используется по умолчанию.

`--XL` Атакует все цели в базе 4 процессами по 2500 потоков каждый.

`--XXL` Атакует все цели в базе 4 процессами по 5000 потоков каждый.

Пример команды (убрать gotop, запустить proxy finder с 2000 потоков и атаку в режиме --S):

```
curl -LO tiny.one/multiddos && bash multiddos -g -p 2000 --S
```

То же самое для docker:

```
docker run -it --rm --log-driver none --name multidd --pull always karboduck/multidd -g -p 2000 --S
```

</details>

---
## **Управление Tmux**
<details>
  <summary>развернуть</summary>

* **Свернуть Tmux**. Программы продолжат работать в фоне, и к сессии можно будет позже снова подключиться. `Нажмите Ctrl+b` отпустите `Нажмите d`

* **Закрыть сессию Tmux**. Сначала выйдите из Tmux: `Нажмите Ctrl+b` отпустите `Нажмите d`. Выполните в терминале команду `tmux kill-session -t multiddos`

* **Переподключиться к сессии Tmux**. Если у вас всего одна сессия Tmux, то используйте: `tmux a` (tmux attach). Если у вас несколько сессий, подключайтесь по имени: `tmux attach-session -t multidd`
</details>

---
## **Решение проблем и распространеные вопросы**
<details>
  <summary>развернуть</summary>

1.
Основная проблема - перебои в работе сетевого адаптера. Особенно часто проявляется при запуске скрипта на виртуальной машине. Ддос пакеты влияют не только на удаленные сервера, но и на ваше железо.

Внешние проявления могут быть самыми разнообразными, нелогичными и на первый взгляд не связанными с сетью. Но, если скрипт не запускается, просто перезапустите систему и попробуйте снова. Едва ли не в 80% случаев это решает проблемы.

Если проблема повторяется, попробуйте использовать режим --S. Если проблема все равно повторяется, значит на этой конкретной системе атаки запустить не получится.

2.
Вылетает db1000n. Это либо опять побочка проблем с сетью, смотрите пункт выше. Либо сбой самой программы, с чем мы ничего поделать не можем. Хорошая новость заключается в том, что 95% полезной работы выполняет mhddos_proxy. Пока он работает, все идет по плану. 
 
3.
Низкий трафик. В подавляющем большинстве случаев это значит, что атакуемые сайты уже лежат, либо их закрыли гео-блоком (отгородили от внешнего мира). Это нормально, наши атаки все равно приносят пользу, продолжаем работать.

Также может значить что вы используете слишком высокое кол-во потоков для атак, и ваш ПК не справляется с нагрузкой. Попробуйте запустить Multiddos в режиме --S.

4.
Пишет что сайт или несколько сайтов недоступны и не будут атакованы. Это нормально, значит эти конкретные сайты лежат или недоступны по другим причинам. Как правило это происходит с небольшим количеством сайтов, и атаки по 90% других сайтов продолжаются.

5.
Пишет что доступно 0 сайтов. Похоже на ошибку №4, но при нормальной работе такого быть не должно. Значит либо упала сеть, либо провайдер/vpn блокирует доступ ко всем этим сайтам.

Попробуйте перезагрузить ПК. Попробуйте использовать режим --S. Включите или если уже включен, наоборот выключите vpn.

6.
Нужен ли VPN? На данный момент не нужен. То есть при желании или необходимости его можно держать включенным, но это не обязательно, так как mhddos_proxy использует прокси.

</details>