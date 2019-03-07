#version: 20181208_rc1

FROM balenalib/rpi-raspbian:stretch

#Change the timezone to your current timezone!!
ENV TZ=Europe/Amsterdam

RUN set -x && \ 
	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone	
RUN set -x && \
	apt-get update && apt-get dist-upgrade -y
 
RUN set -x && \	
	apt-get install -y dirmngr apt-transport-https apt-utils

RUN set -x && \
	bash -c  'echo "deb https://raspbian.snips.ai/stretch stable main" > /etc/apt/sources.list.d/snips.list'

RUN set -x && \
	apt-key adv --keyserver  keyserver.ubuntu.com --recv-keys D4F50CDCA10A2849 
	
RUN set -x && \
	apt-get update 

#since recommended packets are NOT installed by default, we have to install them explicit
RUN set -x && \
	apt-get install -y alsa-utils snips-platform-voice snips-skill-server mosquitto snips-analytics snips-asr snips-audio-server snips-dialogue snips-hotword snips-nlu snips-tts curl unzip snips-template python-pip git

RUN set -x && \
	pip install virtualenv

#Is this really required? 
RUN set -x && \	
	usermod -aG snips-skills-admin root
	
COPY start-snips.sh start-snips.sh

EXPOSE 1883/tcp


CMD ["bash","/start-snips.sh"]
