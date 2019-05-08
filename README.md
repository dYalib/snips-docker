# WIP snips-docker
Snips platform running in docker! 

Official Website about snips: https://snips.ai/

The motivation for build this container is to run "Snips Voice Assistant" with satellite configuration. This container provides only a server instance without any direct sound input / output.  That means a "sattelite device" is absolutely necessary! <br>
Read more about this: https://snips.gitbook.io/documentation/installing-snips/multi-device-setup-satellites 


### Build ###

- clone this repo with `git clone`
- `cd` into the cloned folder
- change the time zone in the Dockerfile to your current time zone.
- To build for amd64

```
# Replace <image-name> with your prefered image name
docker build -f Dockerfile.amd64 -t <image-name> .

# For example
docker build -f Dockerfile.amd64 -t snips-docker-image .
```

- To build for arm32v7 (Raspberry PI)

```
# Replace <image-name> with your prefered image name
docker build -f Dockerfile.arm32v7 -t <image-name> .

# For example
docker build -f Dockerfile.arm32v7 -t snips-docker-image .
```

### Usage ###
- Keep in mind, access rights are system depended! Make sure that you and the docker daemon are granted to access (RW) the folder with the persistent snips data. In the following, I assume that the full access rights exist.
- On Docker Host, create a folder where the snips persistent data (assistant, config, logs) should be. <br>
e.g. `mkdir /home/user/snips`
- Create your assistant at https://console.snips.ai
- Download your assistant
- Unzip your new assistant in the folder that you have been created <br>
e.g. `unzip assistant_proj_Xr3k725M86V1 -d /home/user/snips`
- copy your snips.toml configuration file (or the default one from cloned git repo) to the folder, that you have been created.
- start the container
  - `<container name>` Choose a name for the container
  - `<log path>` <b>optionally</b>, path on docker host where the snips logs will be stored
  - `<path to snips.toml>` Path to your snips.toml file
  - `<path to snips assistant>` Path to your assistant
  - `<image-name>` Name of the docker image that you have create with docker build
  - `ENABLE_MQTT=<yes/no>` `yes (or not set)` = start a mqtt serve inside the conatiner. `no` = you have to set up a separate mqtt server
  - `ENABLE_HOTWORD_SERVICE=<yes/no>` `yes (or not set)` = start the hotword recognition service (required for satellite configuration methode A). `no` = no hotword recognition (make sense for satellite configuration methode B)

```
docker run --name <container name> \
	-v <log path>/:/var/log:Z \
	-v <path to snips.toml>:/etc/snips.toml \
	-v <path to snips assistant>:/usr/share/snips \
	-e ENABLE_MQTT=<yes/no> \
	-e ENABLE_HOTWORD_SERVICE=<yes/no> \
	-p 1883:1883 \
	  <image-name>

# For example, run with all services
docker run \
		--name snips-server \
		-v /home/user/snips/log/:/var/log \
		-v /home/user/snips/snips.toml:/etc/snips.toml
		-v /home/user/snips/:/usr/share/snips \
		-p 1883:1883 \
		snips-docker-image
		

# For example, run without mqtt and snips-hotword
docker run \
		--name snips-server \
		-v /home/user/snips/log/:/var/log \
		-v /home/user/snips/snips.toml:/etc/snips.toml
		-v /home/user/snips/:/usr/share/snips \
		-e ENABLE_MQTT=no \
		-e ENABLE_HOTWORD_SERVICE=no \
		-p 1883:1883 \
		snips-docker-image		
		
		
# On hosts with enabled SELinux (e.g. Fedora), you have to add a ":Z" at the end of all paths.
# For example
docker run \
		--name snips-server \
		-v /home/david/snips/log/:/var/log:Z \
		-v /home/user/snips/snips.toml:/etc/snips.toml:Z
		-v /home/david/snips/:/usr/share/snips:Z \
		-p 1883:1883 \
		snips-docker-image		

```


## Limitations ##

- Since it's not a good idea to run a ssh daemon in a docker container, it's not possible to use `SAM` for assistant deploying.
- Without SAM, you have to manually edit the Skills configurations

## Known Problems ##

2019-05-08 Thanks @dchansel the problem below is fixed now!

Problem: Sometimes the key server will not respond. You got the following message at the build process
```
+ apt-key adv --keyserver pgp.mit.edu --recv-keys D4F50CDCA10A2849
Executing: gpg --ignore-time-conflict --no-options --no-default-keyring --homedir /tmp/tmp.l4IOylh0iu --no-auto-check-trustdb --trust-model always --keyring /etc/apt/trusted.gpg --primary-keyring /etc/apt/trusted.gpg --keyserver pgp.mit.edu --recv-keys D4F50CDCA10A2849
gpg: requesting key A10A2849 from hkp server pgp.mit.edu
gpgkeys: key D4F50CDCA10A2849 can't be retrieved
gpg: no valid OpenPGP data found.
gpg: Total number processed: 0
```
Solution: At the moment, i have only a workaround. -> Start the build process again and again and again... After some try it works. Yes, thats a really bad workaround...


## TODO ##

- [X] write the Dockerfile for arm32v7 architecture (RPI)
- [X] reduce the image size
- [X] start only the services, thats really required. Thats dependig on configuration method A or B. Or if you use a external MQTT Server
