#!/bin/bash
echo "*** Building Mongodb..."
sudo docker build -t veereshvalakonda/mongodb mongod
echo "*** Building Mongos..."
sudo docker build -t veereshvalakonda/mongos mongos
