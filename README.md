# Tamil-TTS-install-script

Author : T Shrinivasan <tshrinivasan@gmail.com>


This is a script to install the Tamil text to Speech System provided by IIT Madras and SSN College of Engineering at
https://www.iitm.ac.in/donlab/tts/voices.php

## System requirements:
Ubuntu 16.04

## Will it work on Windows?

No. 


## How to execute:


```
git clone https://github.com/tshrinivasan/tamil-tts-install.git

cd tamil-tts-install

```

Edit the file, install-tamil-tts.sh

Fill the following details.

DOWNLOAD_PATH=/home/ubuntu/tts/packages  #to download the required packages

COMPILE_PATH=/home/ubuntu/tts/compiled   # to place the compiled files and folders


Register here http://htk.eng.cam.ac.uk/download.shtml and get a username and password

HTKUSER=htkuserchennai

HTKPASSWORD=sgqY=t=M


Then, execute the file as

bash install-tamil-tts.sh



## How to convert a text to audio?

```
export FESTDIR=/usr


cd COMPILE_PATH
ssn_hts_demo/scripts/complete “தமிழ் வாழ்க” linux

```


This will convert the text and store as wav in

ssn_hts_demo/wav/1.wav

you can play it with any audio player.


The full details of what is on the compile process is explained here.
https://goinggnu.wordpress.com/2017/09/20/how-to-compile-tamil-tts-engine-from-source/

To hear a demo on how the tamil TTS system sounds, click here
https://soundcloud.com/shrinivasan/tamil-tts-demo




## How to convert a full text file to audio?

Prepare the tamil text content as a text file. Save it as ".txt" extension.

open the file convert-file-to-audio.py, with any text editor and replace the following two parapeters with suitable folders.

ssn_demo_path = "/home/shrini/Downloads/ssn_hts_demo"

mp3_out_path = "/home/shrini/test"


Then execute the below command

```
python convert-file-to-audio.py <filename.txt>
```

This will make mp3 file and store in the folder mp3_out_path/filename-timestamp
