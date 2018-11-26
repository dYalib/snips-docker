# WIP snips-docker
Snips platform running in docker! 

Official Website about snips: https://snips.ai/

The motivation for build this container is to run "Snips Voice Assistant" with satellite configuration. This container provides only a server instance without any direct sound input / output.  That mean a "sattelite device" is absolutely necessary! <br>
Read more about this: https://snips.gitbook.io/documentation/installing-snips/multi-device-setup-satellites 


### Build ###

- clone this repo with `git clone`
- `cd` into the cloned folder
- To build for amd64

```
# Replace <image-name> with your prefered image name
docker build -f Dockerfile.amd64 -t <image-name> .

# For example
docker build -f Dockerfile.amd64 -t snips-docker .
```

- To build for arm32v6 (Raspberry PI)

```
# Replace <image-name> with your prefered image name
docker build -f Dockerfile.arm32v6 -t <image-name> .

# For example
docker build -f Dockerfile.arm32v6 -t snips-docker-image .
```

### Usage ###
- Keep in mind, access rights are system depend! Make sure that you and the docker daemon are granted to access (RW) the folder with the persistent snips data. In the following, I assume that the full access rights exist
- On Docker Host, create a folder where the snips persistent data (assistant, config, logs) should be. <br>
e.g. `mkdir /home/user/snips`
- Create your assistant at https://console.snips.ai
- Download your assistant
- Unzip your new assistant in the folder that you have been created <br>
e.g. `unzip assistant_proj_Xr3k725M86V1 -d /home/user/snips`
- copy your snips.toml configuration file (or the default one from cloned git repo) to the folder, that you habe been created.
- start the container
 - `<container name>` Choose a name for the container
 - `<log path>` <b>optionally</b>, path on docker host where the snips logs will be stored
 - `<path to snips.toml>` Path to your snips.toml file
 - `<path to snips assistant>` Path to your assistant
 - `<image-name>` Name of the docker image that you have create with docker build

```
docker run --name <container name> \
	-v <log path>/:/var/log:Z \
	-v <path to snips.toml>:/etc/snips.toml \
	-v <path to snips assistant>:/usr/share/snips \
	-p 1883:1883 \
	  <image-name>

# For example
docker run \
		--name snips-server \
		-v /home/user/snips/log/:/var/log \
		-v /home/user/snips/:/usr/share/snips \
		-p 1883:1883 \
		snips-docker-image
		
		
# On hosts with enabled SELinux (e.g. Fedora), you have to add a ":Z" at the end of all paths.
# For example
docker run \
		--name snips-server \
		-v /home/david/snips/log/:/var/log:Z \
		-v /home/david/snips/:/usr/share/snips:Z \
		-p 1883:1883 \
		snips-docker-image		

```


## Limitations ##

- Since it's not a good idea to run a ssh daemon in a docker container, it's not possible to use `SAM` for assistant deploying.
- Without SAM, you have to manually edit the Skills configurations

## TODO ##

- [ ] write the Dockerfile for arm32v6 architecture (RPI)
- [X] reduce the image size
- [ ] start only the services, thats really required. Thats dependig on configuration method A or B. Or if you use a external MQTT Server
