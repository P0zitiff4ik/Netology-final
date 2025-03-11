# Используем официальный образ nginx
FROM nginx:1.21.6

# Устанавливаем рабочую директорию
WORKDIR /etc/nginx

# Копируем конфигурационный файл nginx
COPY --chown=nginx:nginx ./nginx.conf /etc/nginx/nginx.conf

# Копируем статические файлы в директорию, указанную в конфиге nginx
COPY --chown=nginx:nginx ./html/ /var/www/html

# Очищаем ненужные файлы (если есть)
RUN rm -rf /var/lib/apt/lists/*

# Экспонируем порт
EXPOSE 80

# Запускаем nginx
CMD ["nginx", "-g", "daemon off;"]
