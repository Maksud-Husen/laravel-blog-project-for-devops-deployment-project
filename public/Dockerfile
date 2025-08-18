FROM nginx:latest

WORKDIR /var/www/html/blog

COPY . .

RUN rm -rf /etc/nginx/conf.d/default.conf

EXPOSE 8000