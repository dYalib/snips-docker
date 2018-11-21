#!/bin/bash
set -e

#start own mqtt service. !!ONLY FOR TEST PURPOSES!!
mosquitto -d
#mosquitto_pid=$!

#start Snips analytics
snips-analytics 2> /var/log/snips-analytics.log  &
snips_analytics_pid=$!

#start Snips' Automatic Speech Recognition service
snips-asr 2> /var/log/snips-asr.log &
snips_asr_pid=$!

#start Snips-dialogue service
snips-dialogue 2> /var/log/snips-dialogue.log  &
snips_dialogue_pid=$!

#start Snips hotword servie
#is this really required??
snips-hotword 2> /var/log/snips-hotword.log & 
snips_hotword_pid=$!

#start Snips Natural Language Understanding
snips-nlu 2> /var/log/snips-nlu.log &
snips_nlu_pid=$!

#start Snips Skill Server
snips-skill-server 2> /var/log/snips-skill-server &
snips_skill_server_pid=$!

#start Snips TTS Service
snips-tts 2> /var/log/snips-tts.log &
snips_tts_pid=$!

#start the snips audio server without playback and microphone
snips-audio-server --disable-playback --no-mike --hijack localhost:64321 2> /var/log/snips-audio-server.log &
snips_audio_server_pid=$!

wait "$snips_analytics_pid" "$snips_asr_pid" "$snips_dialogue_pid" "$snips_hotword_pid" "$snips_nlu_pid" "$snips_skill_server_pid" "$snips_audio_server_pid"

