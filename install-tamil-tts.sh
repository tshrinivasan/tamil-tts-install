#!/bin/bash
DOWNLOAD_PATH=/home/ubuntu/tts/packages
COMPILE_PATH=/home/ubuntu/tts/compiled


#Register here http://htk.eng.cam.ac.uk/download.shtml and get a username and password

HTKUSER=htkuserchennai
HTKPASSWORD=sgqY=t=M


sudo apt-get install  wget festival libx11-dev perl  build-essential g++-4.7 csh gawk bc sox tcsh default-jre lame   -y


mkdir -p $DOWNLOAD_PATH
mkdir -p $COMPILE_PATH

cd $DOWNLOAD_PATH
wget https://www.iitm.ac.in/donlab/tts/downloads/voices/hts23/ssn_hts_demo_Tamil_male.tgz

gunzip ssn_hts_demo_Tamil_male.tgz
tar xvf ssn_hts_demo_Tamil_male.tar



cd $DOWNLOAD_PATH
wget https://nchc.dl.sourceforge.net/project/sp-tk/SPTK/SPTK-3.10/SPTK-3.10.tar.gz
tar xvzf SPTK-3.10.tar.gz
cd SPTK-3.10
./configure --prefix=$COMPILE_PATH/sptk
make
make install


cd $DOWNLOAD_PATH
mkdir hts-htk
cd hts-htk
wget http://hts.sp.nitech.ac.jp/archives/2.3/HTS-2.3_for_HTK-3.4.1.tar.bz2
tar xvjf HTS-2.3_for_HTK-3.4.1.tar.bz2

cd $DOWNLOAD_PATH
wget http://htk.eng.cam.ac.uk/ftp/software/HTK-3.4.1.tar.gz --user=$HTKUSER --password=$HTKPASSWORD
wget http://htk.eng.cam.ac.uk/ftp/software/hdecode/HDecode-3.4.1.tar.gz --user=$HTKUSER --password=$HTKPASSWORD

tar -zxvf HTK-3.4.1.tar.gz
tar -zxvf HDecode-3.4.1.tar.gz

cd htk
patch -p1 -d . < ../hts-htk/HTS-2.3_for_HTK-3.4.1.patch
export CC=gcc-4.7 CXX=g++-4.7
./configure  CFLAGS="-DARCH=linux"  --prefix=$COMPILE_PATH/htk
make
make install



cd $DOWNLOAD_PATH

wget https://nchc.dl.sourceforge.net/project/hts-engine/hts_engine%20API/hts_engine_API-1.10/hts_engine_API-1.10.tar.gz

tar xvzf hts_engine_API-1.10.tar.gz
cd hts_engine_API-1.10

./configure --prefix=$COMPILE_PATH/hts_engine_api
make
make install


cd /usr/share/doc/festival/examples/
sudo  gunzip dumpfeats.gz

sudo gunzip dumpfeats.sh.gz
sudo chmod a+rx /usr/share/doc/festival/examples/dumpfeats


cd $DOWNLOAD_PATH
cd ssn_hts_demo

./configure --with-fest-search-path=/usr/share/doc/festival/examples --with-sptk-search-path=$COMPILE_PATH/sptk/bin/ --with-hts-search-path=$COMPILE_PATH/htk/bin/ --with-hts-engine-search-path=$COMPILE_PATH/hts_engine_api/bin/

sudo mv /usr/share/festival/radio_phones.scm /usr/share/festival/radio_phones.scm-old

sudo cp $DOWNLOAD_PATH/ssn_hts_demo/radio_phones.scm /usr/share/festival/

sudo cp $DOWNLOAD_PATH/ssn_hts_demo/Slurp.pm /usr/share/perl5/File/

gcc scripts/tamil_trans.c -o scripts/tamil_trans

#echo "FESTDIR=/usr" >> $HOME/.profile
#source $HOME/.profile


#comment the play audio file line on the complete script
sed -e '/play/ s/^#*/#/'  -i  $DOWNLOAD_PATH/ssn_hts_demo/scripts/complete 

#replace $FESTDIR to /usr as festival's path in ubuntu is /usr/bin/festival
perl -i -pe 's/\$FESTDIR/\/usr/g' $DOWNLOAD_PATH/ssn_hts_demo/scripts/complete
