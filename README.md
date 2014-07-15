```
these are currently just my notes and a demo script

TODO:
	vagrant tests

====
docker pull dockerfile/ubuntu
docker pull progrium/webapp
docker pull dockerfile/redis
docker pull progrium/consulate
docker pull progrium/nginx
---
docker version
docker images

PUBLIC_IP="$(ifconfig eth0 | awk -F ' *|:' '/inet addr/{print $4}')"

JOIN_IP=

$(docker run --rm progrium/consulate cmd:run $PUBLIC_IP -d)
$(docker run --rm progrium/consulate cmd:iptables)

# show consul ui

# go to https://github.com/progrium/sample-webapp

docker run --name webapp -d -P progrium/webapp

# connect locally to show app

docker run --rm -it --link consulate:consulate -e "BACKEND_9000=webapp.service.consul" dockerfile/ubuntu bash

docker run --name nginx -d -p 8000:80 -p 9000:9000 --link consulate:consulate -e "BACKEND_8080=webapp.service.consul" progrium/nginx

{"upstream": {"webapp": {"server": {"consulate:8080": null}}}, "server": [{"listen": 80, "location": {"/": {"proxy_pass": "http://webapp"}}}]}

# run 2 webapps to show balancing, then show counter

docker run --name webapp -d -P -e "REDIS=consulate" --link consulate:consulate -e "BACKEND_6379=redis.service.consul" progrium/webapp

docker run -d --name redis -P dockerfile/redis

# move redis

===

PRIVATE_IP="$(ifconfig eth1 | awk -F ' *|:' '/inet addr/{print $4}')"
docker run --rm -it -e "SERVICE_NAME=foobar" -p 8000 ubuntu bash -c "nc -l 8000"
docker run --rm -it --link consulate:consulate -e "BACKEND_9000=foobar.service.consul" ubuntu bash -c "nc consulate 9000"






$(docker run --rm progrium/consul cmd:run $PRIVATE_IP -it)
echo "DOCKER_OPTS='--dns $BRIDGE_IP --dns 8.8.8.8 --dns-search service.consul'" > /etc/default/docker
service restart docker

```
