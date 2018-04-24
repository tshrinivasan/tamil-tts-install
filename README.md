# Tamil-TTS-install-script

Author : T Shrinivasan <tshrinivasan@gmail.com>

This is a script to install the Tamil text to Speech System provided by IIT Madras and SSN College of Engineering at
https://www.iitm.ac.in/donlab/tts/voices.php

## System requirements:
Ubuntu 16.04
Ubuntu 18.04

## Will it work on Windows?
No. 

## How to Install
```
git clone https://github.com/tshrinivasan/tamil-tts-install.git
cd tamil-tts-install
./tamil-tts.sh --clean --setup

```

## How to convert tamil text to .wav
```
cd tamil-tts-install
./tamil-tts.sh --run --source tamil-text.txt
```
This will generate 'tamil-text.wav' file

## How to convert tamil text to .mp3
```
cd tamil-tts-install
./tamil-tts.sh --run --gen-mp3 --source tamil-text.txt
```
This will generate 'tamil-text.mp3' file

## howto set your own HTKUSER and HTKPASSWORD in tamil-tts.sh
Register here http://htk.eng.cam.ac.uk/download.shtml and get a username and password, replace your
own username and passward in HTKUSER and HTKPASSWORD
