sudo docker run --name test -P -d veeresh/mongodb --replSet r1 --noprealloc --smallfiles
sudo docker run -P -i -t -e OPTIONS=" 192.168.123.85:$(sudo docker port test 27017|cut -d : -f2) /initiate.js" veeresh/mongodb
