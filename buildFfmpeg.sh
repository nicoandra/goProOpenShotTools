#!/bin/bash

SOURCES_PATH=~/bin/ffmpeg/sources; 
BUILD_PATH=~/bin/ffmpeg/build;

## FROM https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu

function updateDeb {
	sudo aptitude update
}

function installDependencies {
	sudo aptitude install autoconf automake build-essential libass-dev libfreetype6-dev \
	  frei0r-plugins-dev libsdl1.2-dev libtheora-dev libtool libva-dev \
	  libvdpau-dev libvorbis-dev libxcb1-dev libxcb-shm0-dev \
	  libxcb-xfixes0-dev pkg-config texinfo zlib1g-dev yasm \
	  libx264-dev libmp3lame-dev libopus-dev mercurial cmake  \
	  libgnutls-dev libopenjpeg-dev librtmp-dev libxvidcore-dev libwavpack-dev libtwolame-dev
}


function buildPaths {
	mkdir -p $SOURCES_PATH;
}



function compileVidStab {
	cd $SOURCES_PATH
	git clone https://github.com/georgmartius/vid.stab.git
	cd $SOURCES_PATH/vid.stab
	cmake . -DCMAKE_INSTALL_PREFIX="$BUILD_PATH"
	make
	make install

}

function compileX265 {
	cd $SOURCES_PATH
	hg clone https://bitbucket.org/multicoreware/x265
	cd $SOURCES_PATH/x265/build/linux
	PATH="$HOME/bin:$PATH" cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX="$BUILD_PATH" -DENABLE_SHARED:bool=off ../../source
	make
	make install
	make distclean
}


function compileAac {
	cd $SOURCES_PATH;
	wget -O fdk-aac.tar.gz https://github.com/mstorsjo/fdk-aac/tarball/master
	tar xzvf fdk-aac.tar.gz
	cd mstorsjo-fdk-aac*
	autoreconf -fiv
	./configure --prefix="$BUILD_PATH" --disable-shared
	make
	make install
	make distclean
}

function compileVpx {
	cd $SOURCES_PATH;
	wget http://storage.googleapis.com/downloads.webmproject.org/releases/webm/libvpx-1.5.0.tar.bz2
	tar xjvf libvpx-1.5.0.tar.bz2
	cd libvpx-1.5.0
	PATH="$HOME/bin:$PATH" ./configure --prefix="$BUILD_PATH" --disable-examples --disable-unit-tests
	PATH="$HOME/bin:$PATH" make
	make install
	make clean
}


function compileFfmpeg {
	cd $SOURCES_PATH;
	## wget http://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2
	## tar xjvf ffmpeg-snapshot.tar.bz2
	cd ffmpeg
	PATH="$HOME/bin:$PATH" PKG_CONFIG_PATH="$BUILD_PATH/lib/pkgconfig" ./configure \
	  --prefix="$BUILD_PATH" \
	  --pkg-config-flags="--static" \
	  --extra-cflags="-I$BUILD_PATH/include" \
	  --extra-ldflags="-L$BUILD_PATH/lib" \
	  --bindir="$HOME/bin" \
	  --enable-gpl \
	  --enable-libass \
	  --enable-libfdk-aac \
	  --enable-libfreetype \
	  --enable-libmp3lame \
	  --enable-libopus \
	  --enable-libtheora \
	  --enable-libvorbis \
	  --enable-libvpx \
	  --enable-libx264 \
	  --enable-libx265 \
	  --enable-nonfree \
	--enable-gpl \
	--enable-libfdk-aac \
	--enable-nonfree --enable-gpl \
	--enable-libmp3lame --enable-libopus --enable-libvpx  \
	--enable-shared \
	--disable-stripping \
	--enable-avresample  \
	--enable-avisynth  \
	--enable-libass  \
	--enable-libcaca  \
	--enable-libfontconfig  \
	--enable-libfribidi \
	--enable-libopenjpeg \
	--enable-libopus  \
	--enable-libxvid  \
	--enable-opengl \
	--enable-libfdk-aac \
	--enable-x11grab \
	--enable-libdc1394  \
	--enable-libiec61883 \
	--enable-libwavpack \
	--enable-libtwolame \
	--enable-libvidstab

## --enable-libzvbi \
##	--enable-libzmq  \
## --enable-libwebp
##	 \
## 	--enable-libpulse \
##	--enable-libspeex \	
##  --enable-libssh
##	--enable-libsoxr
## 	--enable-libshine
##	--enable-libcdio  \
##	--enable-openal \
	## --enable-gnutls --extra-libs='-lnettle -lhogweed -lgmp' \
	## --enable-frei0r  \
	## --enable-ladspa  \
	## --enable-libbluray  \
	## --enable-libbs2b  \
	## --enable-libflite  \
	## --enable-libgme  \
	## --enable-libgsm \
	## --enable-libmodplug \
	## --enable-libopencv
	## --enable-librtmp
	## --enable-libschroedinger


	PATH="$HOME/bin:$PATH" make

	make install
	make distclean
	hash -r
}


cd $SOURCES_PATH;

# updateDeb;
## installDependencies ;
## buildPaths ;
## compileX265 ;
## compileAac ;
## compileVpx ;
## compileVidStab ;
compileFfmpeg ;
