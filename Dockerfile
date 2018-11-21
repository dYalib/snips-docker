#version: 20181121_alpha02

FROM debian:stretch-slim

	
RUN set -x && \
	sed -i "s#deb http://http.us.debian.org/debian jessie main contrib#deb http://http.us.debian.org/debian jessie main contrib non-free#g" /etc/apt/sources.list

RUN set -x && \
	apt-get update && apt-get dist-upgrade -y
 
RUN set -x && \	
	apt-get install -y dirmngr apt-transport-https

RUN set -x && \
	bash -c  'echo "deb https://debian.snips.ai/stretch stable main" > /etc/apt/sources.list.d/snips.list'

RUN set -x && \
	apt-key adv --keyserver pgp.mit.edu --recv-keys F727C778CCB0A455 
	
RUN set -x && \
	apt-get update 

RUN set -x && \
	 apt-get install -y alsa-utils snips-platform-voice snips-skill-server snips-watch curl unzip sudo snips-platform-demo

#Is this really required? 
RUN set -x && \	
	usermod -aG snips-skills-admin root

COPY start-snips.sh start-snips.sh

#!!ONLY FOR TEST PURPOSES!!
EXPOSE 1833/tcp


CMD ["bash","/start-snips.sh"]
