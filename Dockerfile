FROM ubuntu:trusty
MAINTAINER Jeff Lindsay <progrium@gmail.com>

RUN apt-get update && apt-get install -y iptables curl unzip

ADD https://dl.bintray.com/mitchellh/consul/0.3.0_linux_amd64.zip /tmp/consul.zip
RUN cd /bin && unzip /tmp/consul.zip && chmod +x /bin/consul && rm /tmp/consul.zip

ADD https://dl.bintray.com/mitchellh/consul/0.3.0_web_ui.zip /tmp/webui.zip
RUN cd /tmp && unzip /tmp/webui.zip && mv dist /ui && rm /tmp/webui.zip

ADD https://github.com/progrium/ambassadord/releases/download/v0.0.1/ambassadord_0.0.1_linux_x86_64.tgz /tmp/ambassadord.tgz
RUN cd /bin && tar -zxf /tmp/ambassadord.tgz && rm /tmp/ambassadord.tgz

ADD https://github.com/progrium/docksul/releases/download/v0.1.0/docksul_0.1.0_linux_x86_64.tgz /tmp/docksul.tgz
RUN cd /bin && tar -zxf /tmp/docksul.tgz && rm /tmp/docksul.tgz

ADD ./config /config/
ADD ./start /bin/start

ENV SERVICE_53_NAME consul-dns
ENV SERVICE_18500_NAME consul-http
ENV SERVICE_18400_NAME consul-rpc
ENV SERVICE_18300_NAME consul-server
ENV SERVICE_18301_NAME serf-lan
ENV SERVICE_18302_NAME serf-wan
ENV DOCKER_HOST unix:///tmp/docker.sock

EXPOSE 8300 8301 8301/udp 8302 8302/udp 8400 8500 53/udp
VOLUME ["/data"]

ENTRYPOINT ["/bin/start"]
CMD []
