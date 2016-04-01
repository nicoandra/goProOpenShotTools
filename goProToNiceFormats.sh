#!/bin/bash

# Update settings


FFMPEG_PATH="ffmpeg -loglevel error -hide_banner -threads 1";
GO_PRO_VIDEOS_PATH=$1
TARGET_PATH=$2


## Detected settings

TARGET_PATH_LO_RES="$TARGET_PATH/lo-res/"
TARGET_PATH_HI_RES="$TARGET_PATH/hi-res/"
TARGET_PATH_LO_RES_DESHAKE="$TARGET_PATH/lo-res-deshake/"
TARGET_PATH_HI_RES_DESHAKE="$TARGET_PATH/hi-res-deshake/"

mkdir "$TARGET_PATH_LO_RES" -p;
mkdir "$TARGET_PATH_HI_RES" -p;
mkdir "$TARGET_PATH_LO_RES_DESHAKE" -p;
mkdir "$TARGET_PATH_HI_RES_DESHAKE" -p;


### DO NOT CHANGE ANYTHING BELOW THIS LINE

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

for F in `find "${GO_PRO_VIDEOS_PATH}"/GOP*.MP4`; do

	FILENAME=`echo $F | sed "s|${GO_PRO_VIDEOS_PATH}||" | sed 's|\.MP4|.MOV|'`  ;
	echo "$FILENAME > Generating Hi-Res file from $F";

	HI_RES_FILENAME="$TARGET_PATH_HI_RES$FILENAME";
	LO_RES_FILENAME="$TARGET_PATH_LO_RES$FILENAME";

	COMMAND="$FFMPEG_PATH -i \"${F}\" -c:v libx264 -crf 15 -c:a copy -n \"${HI_RES_FILENAME}\""
	eval $COMMAND;

	echo "$FILENAME > Generating Lo-Res file from $HI_RES_FILENAME";
	COMMAND="$FFMPEG_PATH -i \"${HI_RES_FILENAME}\" -vf scale=320:-1 -c:v libx264 -preset ultrafast -tune fastdecode -crf 27 -c:a copy -n \"${LO_RES_FILENAME}\""
	eval $COMMAND;

done;


for F in `ls "${GO_PRO_VIDEOS_PATH}"/GOP*.MP4`; do
	FILENAME=`echo $F | sed "s|${GO_PRO_VIDEOS_PATH}||" | sed 's|\.MP4|.MOV|'`  ;



	FILENAME_DETECT_MOVEMENT_FROM=$TARGET_PATH_HI_RES$FILENAME;

	FILENAME_ENCODE_FROM=$F;
	FILENAME_ENCODE_FROM=$FILENAME_DETECT_MOVEMENT_FROM;

	TARGET_F=$TARGET_PATH_HI_RES_DESHAKE$FILENAME;

	if [ -s "$TARGET_F" ] ; then 
		echo "$FILENAME > Unshake process skipped. Deshaked version already exists";
	else
		echo "$FILENAME > Detecting shake movement from $FILENAME_DETECT_MOVEMENT_FROM";
		COMMAND="$FFMPEG_PATH -i \"${FILENAME_DETECT_MOVEMENT_FROM}\" -vf vidstabdetect=shakiness=10:accuracy=15:result=\"${TARGET_PATH_HI_RES_DESHAKE}${FILENAME}.TRF\" -y /tmp/tmp.mov"
		eval $COMMAND;


		echo "$FILENAME > Fixing shake movement from $F";
		COMMAND="$FFMPEG_PATH -i \"${F}\" -vf vidstabtransform=zoom=3:input=\"${TARGET_PATH_HI_RES_DESHAKE}${FILENAME}.TRF\",unsharp=5:5:0.8:3:3:0.4 -c:v libx264 -crf 15 -c:a copy -n \"${TARGET_F}\""

		eval $COMMAND;
	fi;

done;



for F in `ls "${TARGET_PATH_HI_RES_DESHAKE}"/GOP*.MOV`; do

	FILENAME=`echo $F | sed "s|${TARGET_PATH_HI_RES_DESHAKE}||"`  ;
	echo "$FILENAME > Generating Lo-Res de-shaked from $F";

	TARGET_F="${TARGET_PATH_LO_RES_DESHAKE}${FILENAME}";
	echo $F GOES TO $TARGET_F;
	COMMAND="$FFMPEG_PATH -i \"${F}\" -vf scale=320:-1 -c:v libx264 -preset ultrafast -tune fastdecode -crf 27 -c:a copy -n \"${TARGET_F}\""
	eval $COMMAND;

done;
