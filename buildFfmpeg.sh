#!/bin/bash

## FROM https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu

sudo aptitude update
sudo aptitude -y --force-yes install autoconf automake build-essential libass-dev libfreetype6-dev \
  libsdl1.2-dev libtheora-dev libtool libva-dev libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
  libxcb-xfixes0-dev pkg-config texinfo zlib1g-dev yasm libx264-dev libmp3lame-dev libopus-dev;

SOURCES_PATH=~/bin/ffmpeg/sources; 
BUILD_PATH=~/bin/ffmpeg/build;
mkdir -p $SOURCES_PATH;
cd $SOURCES_PATH;


wget -O fdk-aac.tar.gz https://github.com/mstorsjo/fdk-aac/tarball/master
tar xzvf fdk-aac.tar.gz
cd mstorsjo-fdk-aac*
autoreconf -fiv
./configure --prefix="$BUILD_PATH" --disable-shared
make
make install
make distclean



## Final parameters
--enable-gpl --enable-libx264 \
--enable-libfdk-aac \
--enable-nonfree --enable-gpl \
--enable-libmp3lame --enable-libopus --enable-libvpx 





