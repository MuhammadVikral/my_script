#!/bin/bash

docker stop opteraone-db
docker rm opteraone-db
docker volume rm kerjaan_postgres_data
docker volume rm opteraone_backend_postgres_data
docker volume rm kerjaan_opteraone-net
docker-compose up -d postgres
