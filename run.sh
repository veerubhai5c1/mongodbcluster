#!/bin/bash
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

