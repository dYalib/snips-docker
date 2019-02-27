#version: 20181208_rc1

FROM debian:stretch-slim

#Change the timezone to your current timezone!!
ENV TZ=Europe/Amsterdam

RUN set -x && \ 
	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
	
RUN set -x && \
	sed -i "s#deb http://deb.debian.org/debian stretch main#deb http://deb.debian.org/debian stretch main non-free#g" /etc/apt/sources.list && \
	sed -i "s#deb http://security.debian.org/debian-security stretch/updates main#deb http://security.debian.org/debian-security stretch/updates main non-free#g" /etc/apt/sources.list && \
	sed -i "s#deb http://deb.debian.org/debian stretch-updates main#deb http://deb.debian.org/debian stretch-updates main non-free#g" /etc/apt/sources.list

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
	apt-get install -y alsa-utils snips-platform-voice snips-skill-server curl unzip snips-template python-pip git

RUN set -x && \
	pip install virtualenv

#Is this really required? 
RUN set -x && \	
	usermod -aG snips-skills-admin root
	
COPY start-snips.sh start-snips.sh

EXPOSE 1883/tcp


CMD ["bash","/start-snips.sh"]
