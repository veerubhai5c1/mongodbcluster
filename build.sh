#!/bin/bash
echo "*** Building Mongodb..."
sudo docker build -t veeresh/mongodb mongod
echo "*** Building Mongos..."
sudo docker build -t veeresh/mongos mongos
