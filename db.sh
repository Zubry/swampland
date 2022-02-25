#!/bin/bash

docker network create phx-swampland-network
docker run --network phx-swampland-network -p 5432:5432 --name db -e POSTGRES_PASSWORD=postgres -d postgres
