# Minecraft Java Server

Minecraft-сервер в Docker на базе
[`itzg/minecraft-server`](https://github.com/itzg/docker-minecraft-server).

## Содержимое

```text
mods/          # .jar-моды
compose.yaml   # Docker Compose
.env           # настройки сервера
deploy.sh      # загрузка файлов на VPS
command.sh     # разовая команда Minecraft на VPS
uninstall.sh   # удаление сервера на VPS
```

## Настройка

Измените `.env`:

```env
SERVER_TYPE=FORGE
MINECRAFT_VERSION=1.20.1
MEMORY=6G
MINECRAFT_PORT=25565
```

Поддерживаемые загрузчики: `FORGE`, `NEOFORGE`, `FABRIC`, `QUILT`.
Все моды в `mods/` должны соответствовать выбранным версии Minecraft и
загрузчику.

Чтобы закрепить версию загрузчика, укажите переменную для выбранного типа:

```env
FORGE_VERSION=47.4.10
# NEOFORGE_VERSION=21.1.250
# FABRIC_LOADER_VERSION=0.16.14
# FABRIC_LAUNCHER_VERSION=1.0.1
# QUILT_LOADER_VERSION=0.28.1
# QUILT_INSTALLER_VERSION=0.11.0
```

Если версию загрузчика не указывать, образ выберет совместимую рекомендуемую
версию. Полный список параметров: [документация образа](https://docker-minecraft-server.readthedocs.io/en/latest/variables/).

## Деплой на VPS

На компьютере:

```bash
./deploy.sh user@SERVER_IP
```

Скрипт загрузит `compose.yaml`, `.env`, `mods/`, `command.sh` и `uninstall.sh`
в `~/minecraft-server` на VPS. Для другой директории:

```bash
REMOTE_DIR=/srv/minecraft ./deploy.sh user@SERVER_IP
```

На VPS:

```bash
ssh user@SERVER_IP
cd ~/minecraft-server
docker compose up -d
docker compose logs -f
```

## Управление на VPS

```bash
cd ~/minecraft-server
docker compose ps                  # статус контейнера
docker compose logs -f             # логи в реальном времени
docker compose stop                # корректно остановить сервер
docker compose up -d               # запустить сервер в фоне
docker compose exec minecraft bash # войти в shell контейнера
```

## Консоль Minecraft

```bash
cd ~/minecraft-server
docker compose attach minecraft
```

Команды в этой консоли вводятся без `/`:

```text
say Проверка команд
list
op PlayerName
```

Отключиться от консоли без остановки сервера: `Ctrl+P`, затем `Ctrl+Q`.

## Одна команда без консоли

На VPS:

```bash
cd ~/minecraft-server
./command.sh whitelist add PlayerName
./command.sh say Server restart in 5 minutes
```

## Изменение конфигурации

Настройки можно менять локально в `.env` с последующим `deploy.sh`, либо прямо
на VPS:

```bash
cd ~/minecraft-server
nano .env
docker compose up -d
```

Стандартные настройки Minecraft, которых нет в `.env`, находятся в
`data/server.properties`:

```bash
cd ~/minecraft-server
docker compose stop
nano data/server.properties
docker compose up -d
```

Настройки модов находятся в `data/config/`.

## Полное удаление

На VPS:

```bash
cd ~/minecraft-server
./uninstall.sh
```

Скрипт удаляет контейнер и всю директорию сервера без подтверждения.
