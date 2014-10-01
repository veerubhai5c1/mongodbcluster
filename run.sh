export MONGO_PORT=27017
echo "Starting mongodb shard server1 for replica set1..."
sudo docker run -P --name rs1_srv1 -d veeresh/mongodb --replSet rs1 --noprealloc --smallfiles
echo "Starting mongodb shard server2 for replica set1..."
sudo docker run -P --name rs1_srv2 -d veeresh/mongodb --replSet rs1 --noprealloc --smallfiles
echo "Starting mongodb shard server3 for replica set1..."
sudo docker run -P --name rs1_srv3 -d veeresh/mongodb --replSet rs1 --noprealloc --smallfiles
echo "Starting mongodb shard server1 for replica set2..."
sudo docker run -P --name rs2_srv1 -d veeresh/mongodb --replSet rs2 --noprealloc --smallfiles
echo "Starting mongodb shard server2 for replica set2..."
sudo docker run -P --name rs2_srv2 -d veeresh/mongodb --replSet rs2 --noprealloc --smallfiles
echo "Starting mongodb shard server3 for replica set2..."
sudo docker run -P --name rs2_srv3 -d veeresh/mongodb --replSet rs2 --noprealloc --smallfiles
sleep 10
# Get port of first server in rs1
rs1_srv1_port=$(sudo docker port rs1_srv1 ${MONGO_PORT}|cut -d : -f2)
# Get ips rs1
rs1_srv1_ip=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' rs1_srv1)
rs1_srv2_ip=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' rs1_srv2)
rs1_srv3_ip=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' rs1_srv3)
# Get port of first server in rs2
rs2_srv1_port=$(sudo docker port rs2_srv1 ${MONGO_PORT}|cut -d : -f2)
# Get ips in rs2
rs2_srv1_ip=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' rs2_srv1)
rs2_srv2_ip=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' rs2_srv2)
rs2_srv3_ip=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' rs2_srv3)
# export these variables
export RS1_SRV1_PORT=${rs1_srv1_port}
export RS1_SRV1_IP=${rs1_srv1_ip}
export RS1_SRV2_IP=${rs1_srv2_ip}
export RS1_SRV3_IP=${rs1_srv3_ip}
export RS2_SRV1_PORT=${rs2_srv1_port}
export RS2_SRV1_IP=${rs2_srv1_ip}
export RS2_SRV2_IP=${rs2_srv2_ip}
export RS2_SRV3_IP=${rs2_srv3_ip}
echo "Starting mongodb config server1..."
sudo docker run -P --name cfg1 -d veeresh/mongodb --noprealloc --smallfiles --configsvr --dbpath /data/db --port ${MONGO_PORT}
echo "Starting mongodb config server2..."
sudo docker run -P --name cfg2 -d veeresh/mongodb --noprealloc --smallfiles --configsvr --dbpath /data/db --port ${MONGO_PORT}
echo "Starting mongodb config server3..."
sudo docker run -P --name cfg3 -d veeresh/mongodb --noprealloc --smallfiles --configsvr --dbpath /data/db --port ${MONGO_PORT}
sleep 10
# Get Ip address of config serveres
ip1=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' cfg1)
ip2=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' cfg2)
ip3=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' cfg3)
echo "Starting mongodb query router..."
sudo docker run -P  --name mongos1 -d veeresh/mongos --port ${MONGO_PORT} --configdb ${ip1}:${MONGO_PORT},${ip2}:${MONGO_PORT},${ip3}:${MONGO_PORT}
sleep 10
# Get monogs1 port 
mongos1_port=$(sudo docker port mongos1 ${MONGO_PORT}|cut -d : -f2)
export MONGOS_PORT=${mongos1_port}
./test.sh
