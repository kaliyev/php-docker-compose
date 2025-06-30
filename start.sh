#!/bin/bash

read -p "Введите имя проекта: " project_name

echo "Выберите версию PHP:"
select php_version in "8.1" "8.2" "8.3" "8.4"; do
  if [[ -n "$php_version" ]]; then
    break
  fi
done

echo "🔧 Имя проекта: $project_name"
echo "🔧 PHP версия: $php_version"

FILES=(
  ".env.example"
  "docker-compose.yml.example"
  "server/nginx/conf.d/app.conf.example"
  "server/php/php-${php_version}-local.ini.example"
  "server/php/php-${php_version}-local-cli.ini.example"
)

for template in "${FILES[@]}"; do
  find . -type f -path "./$template" | while read -r file; do
    target="${file%.example}"

    if [ -f "$target" ]; then
      echo "⚠️  Файл уже существует: $target (пропущен)"
    else
      mv "$file" "$target"
      echo "✅ Переименован: $file -> $target"
    fi
  done
done

if [ -f ".env" ]; then
  sed -i.bak "s/^COMPOSE_PROJECT_NAME=.*/COMPOSE_PROJECT_NAME=${project_name}/" .env
  sed -i.bak "s/^PHP_VERSION=.*/PHP_VERSION=${php_version}/" .env
  rm .env.bak
  echo "🛠️  Обновлены переменные в .env"
else
  echo "⚠️  .env файл не найден, переменные не обновлены"
fi