# Используем официальный образ Ruby как базовый
FROM ruby:3.2.2

# Устанавливаем зависимости
RUN apt-get update -qq && apt-get install -y postgresql-client

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем Gemfile и Gemfile.lock и устанавливаем гемы
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Копируем все файлы приложения в контейнер
COPY . .

# Открываем порт, на котором будет работать приложение
EXPOSE 4000
