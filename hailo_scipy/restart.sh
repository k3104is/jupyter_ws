#!/bin/bash

NAME='hailo_scipy'

docker compose down
docker rmi i_$NAME
docker compose up -d
docker exec -it c_$NAME /bin/bash