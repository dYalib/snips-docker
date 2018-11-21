# snips-docker
Snips platform running in docker.

Official Website about snips: https://snips.ai/



### Usage ###
docker run --name snips-server \
	-v <log path>/:/var/log:Z \
	-v <path to snips.toml>:/etc/snips.toml \ 
	-v <path to snips assistant>:/usr/share/snips \
	-v <path to snips skills>:/var/lib/snips/skills \ 
	-p 1883:1883 \
	  snips-server
