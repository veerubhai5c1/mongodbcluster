rs.add('RS1_SRV2_IP:27017');
rs.add('RS1_SRV3_IP:27017');
cfg=rs.conf();
cfg.members[0].host='RS1_SRV1_IP:27017';
rs.reconfig(cfg);
rs.status();
