# 🚀 DevOps Documentation for this Project

# 1. Project Overview 🌐
This is a Laravel blog application deployed with modern DevOps practices using Docker, Ansible, and Jenkins CI/CD.

**Servers:**
- Web Server: `WEB_SERVER_IP`
- Database Server: `DB_SERVER_IP`

**Purpose:**
- Isolated services using Docker
- Automated deployments via Ansible
- Continuous Integration/Deployment with Jenkins
- Secure database connectivity

# 2. Architecture 🏗️
**Services Overview:**

| Service | Container/Image      | Port | Purpose             |
|---------|----------------------|------|---------------------|
| Web     | Nginx (laravel_blog_web) | 8000 | Serve Laravel front-end |
| App     | PHP-FPM (laravel_blog_app) | 9000 | Laravel back-end |
| DB      | MySQL (external)     | 3306 | Laravel database    |

**Networking:** Docker bridge network `blog` for container communication.

**Diagram:**
```
[Web Server: WEB_SERVER_IP] 
   |-- Docker: Nginx (8000) --> PHP-FPM (9000)
   |
   v
[DB Server: DB_SERVER_IP] MySQL (3306)
```

# 3. Docker Setup 🐳

## 3.1 Nginx Dockerfile
```dockerfile
FROM nginx:latest
WORKDIR /var/www/html/blog
COPY . .
RUN rm -rf /etc/nginx/conf.d/default.conf
EXPOSE 8000
```

## 3.2 PHP-FPM Dockerfile
```dockerfile
FROM php:8.0-fpm
WORKDIR /var/www/html/blog
RUN apt-get update && apt-get install -y libzip-dev unzip curl && docker-php-ext-install zip pdo pdo_mysql
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
COPY . .
RUN composer install && cp .env.example .env && chmod 644 .env
RUN chmod -R 755 storage bootstrap/cache
RUN chown -R www-data:www-data storage bootstrap/cache
RUN php artisan config:clear && php artisan cache:clear && php artisan route:clear && php artisan view:clear
EXPOSE 9000
```

## 3.3 Docker Compose
- Connects web and app containers on `blog` network
- Maps ports for web access
- Starts Laravel initialization commands

# 4. Laravel Configuration (.env) ⚙️
```ini
DB_CONNECTION=mysql
DB_HOST=DB_SERVER_IP
DB_PORT=3306
DB_DATABASE=laravel_blog
DB_USERNAME=laravel_user
DB_PASSWORD=DB_PASSWORD
APP_URL=http://WEB_SERVER_IP
```

# 5. Ansible Deployment 📦

## 5.1 Inventory
```ini
[web]
WEB_SERVER_USER@WEB_SERVER_IP

[db]
DB_SERVER_USER@DB_SERVER_IP
```

## 5.2 DB Role
- Installs MySQL & Python client
- Creates database `laravel_blog` and user `laravel_user`
- Configures firewall to allow web server connection

## 5.3 Web Role
- Stops/removes old Docker containers & images
- Installs Nginx, Docker, Docker Compose
- Copies project files from Jenkins workspace
- Starts Docker Compose containers & reloads Nginx

# 6. Jenkins Pipeline CI/CD 🤖
```groovy
pipeline {
    agent any
    stages {
        stage("Remove old project") {
            steps { sh 'rm -rf laravel-blog-project-for-devops-deployment-project' }
        }
        stage("Clone project") {
            steps { sh 'git clone <GITHUB_REPO_URL>' }
        }
        stage("Run Ansible") {
            steps {
                sh '''
                cd laravel-blog-project-for-devops-deployment-project
                ansible-playbook -i inventory.ini service.yml
                '''
            }
        }
    }
}
```

# 7. Ports & Networking 🌐

| Service | Host Port | Container Port | Network |
|---------|-----------|----------------|---------|
| Web     | 8000      | 80             | blog    |
| App     | N/A       | 9000           | blog    |
| DB      | 3306      | 3306           | external |

- Only web server can access DB
- Docker bridge isolates containers

# 8. Security & Permissions 🔒
- `.env` file: `644`
- `storage` & `bootstrap/cache`: `755`
- MySQL user restricted to web server IP
- Nginx denies `.ht` files

# 9. Recommended Commands (Optional) 💡
```bash
docker-compose build
docker-compose up -d
docker ps
docker exec -it laravel_blog_app php artisan migrate
ansible-playbook -i inventory.ini service.yml
ansible-playbook -i inventory.ini web.yml
```

