# Запуск проекта

## Запуск в Docker-контейнере

1. Скопировать `.env.example` в `.env`
2. Сбилдить проект при помощи команды `docker compose --build -d`
3. Зайти в терминал контейнера `docker compose exec web bash`
4. Создать базу данных `rails db:create`
5. Запустить миграции `rails db:migrate`

## Запуcк серверов rails

### rails
В терминале докер контейнера запустить команду

```
rails s -b 0.0.0.0
```

Приложение окроется на `localhost:3000`
