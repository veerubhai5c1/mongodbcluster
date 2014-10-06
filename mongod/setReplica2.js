rs.add(RS2_SRV2_IP:27017);
rs.add(RS2_SRV2_IP:27017);
cfg=rs.conf();
cfg.members[0].host={RS2_SRV1_IP:27017};
rs.reconfig(cfg);
