#!/bin/bash 
mkdir DESHAKE
FFMPEG_PATH="/home/nico/bin/ffmpeg/ffmpeg"
VIDEOS_TO_CONVERT=`find HD/ -type f -iname "*.avi"`

for i in $VIDEOS_TO_CONVERT;
do
  NEW_FILE_NAME=`basename $i`;
  FILENAME=$NEW_FILE_NAME;
  NEW_PATH=`echo $i | sed 's/HD/DESHAKE/' `;
  NEW_PATH=`dirname $NEW_PATH`;
  
  echo FOR $i
  echo NEW_FILE_NAME=$NEW_FILE_NAME;
  echo NEW_PATH=$NEW_PATH;
  TARGET_FULL_PATH="$NEW_PATH/$NEW_FILE_NAME";

  FILENAME_DETECT_MOVEMENT_FROM=$i;
  TARGET_PATH_MJPEG_DESHAKE=$i;

  mkdir -p "$NEW_PATH";
  

	if [ -s "$TARGET_F" ] ; then 
		echo "$FILENAME > Unshake process skipped. Deshaked version already exists";
	else
		echo "$FILENAME > Detecting shake movement from $FILENAME_DETECT_MOVEMENT_FROM";
		COMMAND="$FFMPEG_PATH -i \"${FILENAME_DETECT_MOVEMENT_FROM}\" -vf vidstabdetect=shakiness=10:accuracy=15:result=\"${TARGET_PATH_MJPEG_DESHAKE}.TRF\" -y /tmp/tmp.mov"
		eval $COMMAND;

		echo "$FILENAME > Fixing shake movement from $F";
		COMMAND="$FFMPEG_PATH -i \"${FILENAME_DETECT_MOVEMENT_FROM}\" -vf vidstabtransform=zoom=3:input=\"${TARGET_PATH_MJPEG_DESHAKE}.TRF\",unsharp=5:5:0.8:3:3:0.4 -vcodec mjpeg -q:vscale 1 -c:a copy -n \"${TARGET_FULL_PATH}\""
		echo $COMMAND;

	fi;

done
