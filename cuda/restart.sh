#!/bin/bash
# set -e

NAME='jupyter_cuda'

docker compose down
docker rmi i_$NAME
docker compose up -d
docker exec -it c_$NAME /bin/bash