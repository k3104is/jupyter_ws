#!/bin/bash

NAME='jupyter_cuda'

docker compose down
docker rmi i_$NAME