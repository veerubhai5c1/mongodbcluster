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
export RS1_SRV1_PORT=$(sudo docker port rs1_srv1 ${MONGO_PORT}|cut -d : -f2)
# Get ips rs1
export RS1_SRV1_IP=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' rs1_srv1)
export RS1_SRV2_IP=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' rs1_srv2)
export RS1_SRV3_IP=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' rs1_srv3)
# Get port of first server in rs2
export RS2_SRV1_PORT=$(sudo docker port rs2_srv1 ${MONGO_PORT}|cut -d : -f2)
# Get ips in rs2
export RS2_SRV1_IP=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' rs2_srv1)
export RS2_SRV2_IP=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' rs2_srv2)
export RS2_SRV3_IP=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' rs2_srv3)
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
export MONGOS_PORT=$(sudo docker port mongos1 ${MONGO_PORT}|cut -d : -f2)
./test.sh
