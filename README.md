# tamil-tts-install

This is a script to install the Tamil text to Speech System provided by IIT Madras and SSN Engineering College at
https://www.iitm.ac.in/donlab/tts/voices.php

System requirements:
Ubuntu 16.04

How to execute:

git clone https://github.com/tshrinivasan/tamil-tts-install.git

cd tamil-tts-install

Edit the file, install-tamil-tts.sh

Fill the following details.

DOWNLOAD_PATH=/home/ubuntu/tts/packages  #to download the required packages
COMPILE_PATH=/home/ubuntu/tts/compiled   # to place the compiled files and folders


Register here http://htk.eng.cam.ac.uk/download.shtml and get a username and password

HTKUSER=htkuserchennai
HTKPASSWORD=sgqY=t=M


Then, execute the file as

bash install-tamil-tts.sh



How to convert a text to audio?


export FESTDIR=/usr


cd COMPLIE_PATH
ssn_hts_demo/scripts/complete “தமிழ் வாழ்க” linux

This will convert the text and store as wav in

ssn_hts_demo/wav/1.wav

you can play it with any audio player.


The full details of what is on the compile process is explained here.
https://goinggnu.wordpress.com/2017/09/20/how-to-compile-tamil-tts-engine-from-source/

To hear a demo on how the tamil TTS system sounds, click here
https://soundcloud.com/shrinivasan/tamil-tts-demo
