#!bin/bash
sudo docker run -P -name rs1_srv1 -d veeresh/mongodb --replSet rs1 --noprealloc --smallfiles
sudo docker run -P -name rs1_srv2 -d veeresh/mongodb --replSet rs1 --noprealloc --smallfiles
sudo docker run -P -name rs1_srv3 -d veeresh/mongodb --replSet rs1 --noprealloc --smallfiles

sudo docker run -P -name rs2_srv1 -d veeresh/mongodb --replSet rs2 --noprealloc --smallfiles
sudo docker run -P -name rs2_srv2 -d veeresh/mongodb --replSet rs2 --noprealloc --smallfiles
sudo docker run -P -name rs2_srv3 -d veeresh/mongodb --replSet rs2 --noprealloc --smallfiles
