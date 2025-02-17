#!/bin/bash
docker stop backend_crawler_1
docker stop backend_postgres_1
docker stop backend_graphql-engine_1
docker stop backend_verificator-api_1
docker stop backend_verificator_1

docker rm backend_crawler_1
docker rm backend_postgres_1
docker rm backend_graphql-engine_1
docker rm backend_verificator-api_1
docker rm backend_verificator_1

docker rmi crawler:latest
docker rmi verificator-api:latest
docker rmi verificator:latest

docker volume rm backend_db-data

