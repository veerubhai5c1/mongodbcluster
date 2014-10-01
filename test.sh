sleep 5
mongo --port ${RS1_SRV1_PORT} --eval "rs.initiate()"
sleep 15
mongo --port ${RS1_SRV1_PORT} --eval "printjson(rs.add('${RS1_SRV2_IP}:${MONGO_PORT}'))"
mongo --port ${RS1_SRV1_PORT} --eval "printjson(rs.add('${RS1_SRV3_IP}:${MONGO_PORT}'))"
mongo --port ${RS1_SRV1_PORT} --eval "cfg=rs.conf();cfg.members[0].host='${RS1_SRV1_IP}:${MONGO_PORT}';printjson(rs.reconfig(cfg))"
sleep 10
mongo --port ${RS2_SRV1_PORT} --eval "rs.initiate()"
sleep 15
mongo --port ${RS2_SRV1_PORT} --eval "rs.add('${RS2_SRV2_IP}:${MONGO_PORT}')"
mongo --port ${RS2_SRV1_PORT} --eval "rs.add('${RS2_SRV3_IP}:${MONGO_PORT}')"
mongo --port ${RS2_SRV1_PORT} --eval "cfg=rs.conf();cfg.members[0].host='${RS2_SRV1_IP}:${MONGO_PORT}';rs.reconfig(cfg)"
sleep 10
mongo --port ${MONGOS_PORT} --eval "sh.addShard('rs1/${RS1_SRV1_IP}:${MONGO_PORT}')"
sleep 5
mongo --port ${MONGOS_PORT} --eval "sh.addShard('rs2/${RS2_SRV1_IP}:${MONGO_PORT}')"
sleep 10
mongo --port ${MONGOS_PORT} --eval "sh.status()"
