#!/bin/bash

# Define variables
DB_ROOT_PASSWORD="KENAI@2025"

echo "Pulling Docker images for WordPress and MySQL..."
docker pull wordpress:latest
docker pull mysql:5.7

echo "Running MySQL container..."
# Run MySQL container
docker run -d \
--name wordpressdb \
-e MYSQL_ROOT_PASSWORD=${DB_ROOT_PASSWORD} \
-e MYSQL_DATABASE=wordpress \
-p 3306:3306 \
mysql:5.7

echo "Waiting for MySQL to start..."
sleep 20 # Wait a bit for the database to initialize

echo "Running WordPress container..."
# Run WordPress container and link to DB
docker run -d \
--name wordpress \
--link wordpressdb:mysql \
-e WORDPRESS_DB_HOST=wordpressdb:3306 \
-e WORDPRESS_DB_USER=root \
-e WORDPRESS_DB_PASSWORD=${DB_ROOT_PASSWORD} \
-e WORDPRESS_DB_NAME=wordpress \
-p 80:80 \
wordpress:latest

echo "Complete. Access WordPress at your EC2 Public IPv4 address."
