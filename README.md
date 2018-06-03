# laravel_ambiente
Ambiente Laravel Docker

Ambiente Laravel com Docker

Este ambiente contem:

Ubuntu 16.04
Composer
Node 
NPM
Vim
Alguns pacotes linux para o mínimo de acesso em produção.

Para uso basta:

1) Criar um diretório com o nome do projeto
2) Criar uma pasta de nome html e dentro edela ainda uma pasta de nome app
3) Criar seu projeto Laravel dentro dela.
4) Subir o Docker e apontar o nome do seu projeto para 127.0.0.1 no seu arquivo hosts




Ex. de docker-compose.yml

version: '2'

networks:
    internal:
        driver: bridge

services:

    mysql:
        image: mysql:5.7
        container_name: sandbox-mysql
        volumes:
            - $PWD/database:/var/lib/mysql
        ports:
            - "3306:3306"    
        environment:
            - MYSQL_ROOT_PASSWORD=sandbox
            - MYSQL_DATABASE=sandbox
            - MYSQL_USER=sandbox
            - MYSQL_PASSWORD=sandbox
        mem_limit: 1024m
        networks:
            - internal   

    # Redis
    cache:
        image: redis:alpine
        container_name: sandbox-redis
        networks:
             - internal

    # Aplicação
    app:
        image: fcati/laravel_ambiente:0.5
        container_name: sandbox-app
        volumes:
            - $PWD/html:/var/www/html
        networks:
            - internal
        ports:
            - "2208:22"
            - "80:80"
        # If you use reverse-proxy (nginx) enable lines below
        environment:
            - 'LETSENCRYPT_EMAIL=webmaster@yourdomain.com'
            - 'LETSENCRYPT_HOST=yourdomain.com'
            - 'VIRTUAL_HOST=yourdomaincom'
        ## Finished reverse-proxy    
        restart: on-failure
        links:
            - mysql
            - cache
        mem_limit: 1024m
