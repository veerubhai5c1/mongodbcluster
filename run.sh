export MONGO_PORT=27017
export HOST_IP=$1
echo "Starting mongodb shard server1 for replica set1..."
sudo docker run  --name rs1_srv1 -P -i -d -e OPTIONS="d --replSet rs1 --noprealloc --smallfiles" veeresh/mongodb
echo "Starting mongodb shard server2 for replica set1..."
sudo docker run  --name rs1_srv2 -P -i -d -e OPTIONS="d --replSet rs1 --noprealloc --smallfiles" veeresh/mongodb
echo "Starting mongodb shard server3 for replica set1..."
sudo docker run  --name rs1_srv3 -P -i -d -e OPTIONS="d --replSet rs1 --noprealloc --smallfiles" veeresh/mongodb
sleep 10
sudo docker run -P -i -t -e  OPTIONS=" ${HOST_IP}:$(sudo docker port rs1_srv1 ${MONGO_PORT}|cut -d ":" -f2) /initiate.js" veeresh/mongodb
# Get port of first server in rs1
export RS1_SRV1_PORT=$(sudo docker port rs1_srv1 ${MONGO_PORT}|cut -d : -f2)
# Get ips rs1
export RS1_SRV1_IP=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' rs1_srv1)
export RS1_SRV2_IP=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' rs1_srv2)
export RS1_SRV3_IP=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' rs1_srv3)
sleep 15
#configuring replica set1
sudo docker run -P -i -t -e  OPTIONS=" ${HOST_IP}:$(sudo docker port rs1_srv1 ${MONGO_PORT}|cut -d ":" -f2) --eval rs.add('${RS1_SRV2_IP}:${MONGO_PORT}');rs.add('${RS1_SRV3_IP}:${MONGO_PORT}');cfg=rs.conf();cfg.members[0].host='${RS1_SRV1_IP}:${MONGO_PORT}';rs.reconfig(cfg)"  veeresh/mongodb
echo "Starting mongodb shard server1 for replica set2..."
sudo docker run  --name rs2_srv1 -P -i -d -e OPTIONS="d --replSet rs2 --noprealloc --smallfiles" veeresh/mongodb
echo "Starting mongodb shard server2 for replica set2..."
sudo docker run  --name rs2_srv2 -P -i -d -e OPTIONS="d --replSet rs2 --noprealloc --smallfiles" veeresh/mongodb
echo "Starting mongodb shard server3 for replica set2..."
sudo docker run  --name rs2_srv3 -P -i -d -e OPTIONS="d --replSet rs2 --noprealloc --smallfiles" veeresh/mongodb
sleep 10
# Get port of first server in rs2
export RS2_SRV1_PORT=$(sudo docker port rs2_srv1 ${MONGO_PORT}|cut -d : -f2)
# Get ips in rs2
export RS2_SRV1_IP=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' rs2_srv1)
export RS2_SRV2_IP=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' rs2_srv2)
export RS2_SRV3_IP=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' rs2_srv3)
sudo docker run -P -i -t -e  OPTIONS=" ${HOST_IP}:${RS2_SRV1_PORT} /initiate.js" veeresh/mongodb
sleep 15
sudo docker run -P -i -t -e  OPTIONS=" ${HOST_IP}:${RS2_SRV1_PORT} --eval printjson(rs.add('${RS2_SRV2_IP}:${MONGO_PORT}'));rs.add('${RS2_SRV3_IP}:${MONGO_PORT}');cfg=rs.conf();cfg.members[0].host='${RS2_SRV1_IP}:${MONGO_PORT}';rs.reconfig(cfg)" veeresh/mongodb
sleep 10
echo "Starting mongodb config server1..."
sudo docker run  --name cfg1 -P -i -d -e OPTIONS="d --noprealloc --smallfiles --configsvr --dbpath /data/db --port ${MONGO_PORT}" veeresh/mongodb
echo "Starting mongodb config server2..."
sudo docker run  --name cfg2 -P -i -d -e OPTIONS="d --noprealloc --smallfiles --configsvr --dbpath /data/db --port ${MONGO_PORT}" veeresh/mongodb
echo "Starting mongodb config server3..."
sudo docker run  --name cfg3 -P -i -d -e OPTIONS="d --noprealloc --smallfiles --configsvr --dbpath /data/db --port ${MONGO_PORT}" veeresh/mongodb
sleep 10
# Get Ip address of config serveres
ip1=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' cfg1)
ip2=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' cfg2)
ip3=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' cfg3)
echo "Starting mongodb query router..."
sudo docker run -P --name mongos1 -d veeresh/mongos --port ${MONGO_PORT} --configdb ${ip1}:${MONGO_PORT},${ip2}:${MONGO_PORT},${ip3}:${MONGO_PORT}
# Get monogs1 port 
export MONGOS_PORT=$(sudo docker port mongos1 ${MONGO_PORT}|cut -d : -f2)
sleep 5
sudo docker run -P -i -t -e OPTIONS=" ${HOST_IP}:${MONGOS_PORT} --eval sh.addShard('rs1/${RS1_SRV1_IP}:${MONGO_PORT}');sh.addShard('rs2/${RS2_SRV1_IP}:${MONGO_PORT}')" veeresh/mongodb
