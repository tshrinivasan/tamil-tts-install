#!/bin/bash
ROOT=$(git rev-parse --show-toplevel)
ROOT="${ROOT:-$(pwd)}"
BUILD="${ROOT}/build"
DOWNLOAD_PATH="${BUILD}"/packages
COMPILE_PATH="${BUILD}"/compiled
RUNDIR="${DOWNLOAD_PATH}"/ssn_hts_demo

tamil_tts_setup() {
    CURRENTDIR=$(pwd)
    #Register here http://htk.eng.cam.ac.uk/download.shtml and get a username and password
    HTKUSER=htkuserchennai
    HTKPASSWORD=sgqY=t=M

    sudo apt-get install -y wget festival libx11-dev perl build-essential g++ csh gawk bc sox tcsh default-jre lame

    mkdir -p "${DOWNLOAD_PATH}"
    mkdir -p "${COMPILE_PATH}"

    cd "${DOWNLOAD_PATH}"
    if [[ ! -d ssn_hts_demo ]]; then
	wget --no-check-certificate https://www.iitm.ac.in/donlab/tts/downloads/voices/hts23/ssn_hts_demo_Tamil_male.tgz
	tar xvzf ssn_hts_demo_Tamil_male.tgz
    fi

    cd "${DOWNLOAD_PATH}"
    if [[ ! -d SPTK-3.10 ]]; then
	wget --no-check-certificate https://nchc.dl.sourceforge.net/project/sp-tk/SPTK/SPTK-3.10/SPTK-3.10.tar.gz
	tar xvzf SPTK-3.10.tar.gz
    fi
    cd SPTK-3.10
    ./configure --prefix="${COMPILE_PATH}"/sptk
    make
    make install

    cd "${DOWNLOAD_PATH}"
    if [[ ! -d hts-htk ]]; then
	mkdir hts-htk
    fi
    cd hts-htk
    if [[ ! -f HTS-2.3_for_HTK-3.4.1.patch ]]; then
	wget --no-check-certificate http://hts.sp.nitech.ac.jp/archives/2.3/HTS-2.3_for_HTK-3.4.1.tar.bz2
	tar xvjf HTS-2.3_for_HTK-3.4.1.tar.bz2
    fi

    cd "${DOWNLOAD_PATH}"
    if [[ ! -d htk ]]; then
	wget --no-check-certificate  http://htk.eng.cam.ac.uk/ftp/software/HTK-3.4.1.tar.gz --user="${HTKUSER}" --password="${HTKPASSWORD}"
	tar -zxvf HTK-3.4.1.tar.gz
    fi

    if [[ ! -f htk/HTKLVRec/HLVRec.c ]]; then
	wget --no-check-certificate http://htk.eng.cam.ac.uk/ftp/software/hdecode/HDecode-3.4.1.tar.gz --user="${HTKUSER}" --password="${HTKPASSWORD}"
	tar -zxvf HDecode-3.4.1.tar.gz
    fi
    cd htk
    patch --dry-run -s -N -p1 -d . < ../hts-htk/HTS-2.3_for_HTK-3.4.1.patch
    if [[ "${?}" -eq 0 ]]; then
	patch -s -N -p1 -d . < ../hts-htk/HTS-2.3_for_HTK-3.4.1.patch
    fi
    ./configure  CFLAGS="-DARCH=linux"  --prefix="${COMPILE_PATH}"/htk
    make
    make install

    cd "${DOWNLOAD_PATH}"
    if [[ ! -d hts_engine_API-1.10 ]]; then
	wget --no-check-certificate https://nchc.dl.sourceforge.net/project/hts-engine/hts_engine%20API/hts_engine_API-1.10/hts_engine_API-1.10.tar.gz
	tar xvzf hts_engine_API-1.10.tar.gz
    fi
    cd hts_engine_API-1.10
    ./configure --prefix="${COMPILE_PATH}"/hts_engine_api
    make
    make install

    cd /usr/share/doc/festival/examples/
    if [[ ! -f dumpfeats ]]; then
	sudo  gunzip dumpfeats.gz
    fi
    if [[ ! -f dumpfeats.sh ]]; then
	sudo gunzip dumpfeats.sh.gz
    fi
    sudo chmod a+rx /usr/share/doc/festival/examples/dumpfeats

    cd "${DOWNLOAD_PATH}"
    cd ssn_hts_demo
    if [[ ! -f /usr/share/festival/radio_phones.scm-old ]]; then
	sudo mv /usr/share/festival/radio_phones.scm /usr/share/festival/radio_phones.scm-old
	sudo cp "${DOWNLOAD_PATH}"/ssn_hts_demo/radio_phones.scm /usr/share/festival/
    fi

    if [[ ! -f /usr/share/perl5/File/Slurp.pm ]]; then
	mkdir -p /usr/share/perl5/File
	sudo cp "${DOWNLOAD_PATH}"/ssn_hts_demo/Slurp.pm /usr/share/perl5/File/
    fi
    gcc scripts/tamil_trans.c -o scripts/tamil_trans

    #comment the play audio file line on the complete script
    sed -i -e '/play/ s/^/#/' "${DOWNLOAD_PATH}"/ssn_hts_demo/scripts/complete

    #replace $FESTDIR to /usr as festival's path in ubuntu is /usr/bin/festival
    sed -i -e 's:\$FESTDIR:/usr:g' "${DOWNLOAD_PATH}"/ssn_hts_demo/scripts/complete

    #make temp2 to point to input file
    sed -i -e 's:^echo.*temp2$:cp $1 temp2:g' "${DOWNLOAD_PATH}"/ssn_hts_demo/scripts/complete

    cd "${CURRENTDIR}"
    echo "installation completed"
}

tamil_tts_run() {
    if [[ -z "${SOURCE}" ]]; then
	echo "${USAGE}"
	exit 1
    fi

    if [[ -z "${OUTPUT}" ]]; then
	OUTPUT="${SOURCE%.*}.wav"
    fi

    SOURCE=$(readlink -f "${SOURCE}")
    OUTPUT=$(readlink -f "${OUTPUT}")
    MP3OUTPUT="${OUTPUT%.*}.mp3"
    CURRENTDIR=$(pwd)

    rm -f "${OUTPUT}" "${MP3OUTPUT}"
    cp -fra "${RUNDIR}" "${RUNDIR}_${RUNID}"
    RUNDIR="${RUNDIR}_${RUNID}"
    cd "${RUNDIR}"
    ./configure --with-fest-search-path=/usr/share/doc/festival/examples --with-sptk-search-path="${COMPILE_PATH}"/sptk/bin/ --with-hts-search-path="${COMPILE_PATH}"/htk/bin/ --with-hts-engine-search-path="${COMPILE_PATH}"/hts_engine_api/bin/
    ./scripts/complete "${SOURCE}" linux
    cd "${CURRENTDIR}"
    if [[ $(stat -c '%s' "${RUNDIR}"/wav/1.wav) -eq 0 ]]; then
	echo "output file genertion failed" 1>&2
	rm -fr "${RUNDIR}"
	exit 1
    fi

    cp "${RUNDIR}"/wav/1.wav "${OUTPUT}"
    rm -fr "${RUNDIR}"

    if [[ "${MP3}" -eq 1 ]]; then
	lame "${OUTPUT}" "${MP3OUTPUT}"
	rm -f "${OUTPUT}"
    fi
}

tamil_tts_clean() {
    rm -fr "${BUILD}"
}

USAGE="[usage]
	${0} --clean
	${0} --setup
	${0} --run [--runid id] [--gen-mp3] [--output outputfile ] --source sourcefile
	${0} -h|--help
"

ARGS=$(getopt -o h -l clean,setup,run,gen-mp3,runid:,source:,output:,help -n "${0}" -- "${@}")
if [[ ! "${?}" -eq 0 ]]; then
    echo "failed parse options" 1>&2
    exit 1
fi

eval set -- "${ARGS}"
CLEAN=0
SETUP=0
RUN=0
MP3=0
RUNID="${$}"
SOURCE=""
OUTPUT=""

while true; do
    case "${1}" in
	--clean) CLEAN=1; shift;;
	--setup) SETUP=1; shift;;
	--run) RUN=1; shift;;
	--gen-mp3) MP3=1; shift;;
	--runid) RUNID="${2}"; shift 2;;
	--source) SOURCE="${2}"; shift 2;;
	--output) OUTPUT="${2}"; shift 2;;
	--) shift; break;;
	*) echo "${USAGE}"; exit 1;;
    esac
done

if [[ "${CLEAN}" -eq 1 ]]; then
    tamil_tts_clean
fi

if [[ "${SETUP}" -eq 1 ]]; then
    tamil_tts_setup
fi

if [[ "${RUN}" -eq 1 ]]; then
    tamil_tts_run
fi
