#!/bin/bash
set -e

NAME='hailo_scipy_gstreamer'

docker compose down
docker rmi i_$NAME
docker compose up -d
docker exec -it c_$NAME /bin/bash