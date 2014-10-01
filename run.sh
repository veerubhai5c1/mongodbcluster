#!/bin/bash

export MONGO_PORT = 27017

echo "Starting mongodb shard server1 for replica set1..."
sudo docker run -P -name rs1_srv1 -d veeresh/mongodb --replSet rs1 --noprealloc --smallfiles
echo "Starting mongodb shard server2 for replica set1..."
sudo docker run -P -name rs1_srv2 -d veeresh/mongodb --replSet rs1 --noprealloc --smallfiles
echo "Starting mongodb shard server3 for replica set1..."
sudo docker run -P -name rs1_srv3 -d veeresh/mongodb --replSet rs1 --noprealloc --smallfiles

echo "Starting mongodb shard server1 for replica set2..."
sudo docker run -P -name rs2_srv1 -d veeresh/mongodb --replSet rs2 --noprealloc --smallfiles
echo "Starting mongodb shard server2 for replica set2..."
sudo docker run -P -name rs2_srv2 -d veeresh/mongodb --replSet rs2 --noprealloc --smallfiles
echo "Starting mongodb shard server3 for replica set2..."
sudo docker run -P -name rs2_srv3 -d veeresh/mongodb --replSet rs2 --noprealloc --smallfiles

sleep 10

echo "Starting mongodb config server1..."
sudo docker run -P -name cfg1 -d veeresh/mongodb --noprealloc --smallfiles --configsvr --dbpath /data/db --port ${MONGO_PORT}
echo "Starting mongodb config server2..."
sudo docker run -P -name cfg2 -d veeresh/mongodb --noprealloc --smallfiles --configsvr --dbpath /data/db --port ${MONGO_PORT}
echo "Starting mongodb config server3..."
sudo docker run -P -name cfg3 -d veeresh/mongodb --noprealloc --smallfiles --configsvr --dbpath /data/db --port ${MONGO_PORT}
