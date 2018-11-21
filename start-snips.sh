#!/bin/bash
set -e

#start own mqtt service. !!ONLY FOR TEST PURPOSES!!

#start the snips audio server without microphone and
exec snips-audio-server --disable-playback --no-mike --hijack localhost:64321
