#!/bin/bash 
mkdir HD

VIDEOS_TO_CONVERT=`find originals/ -type f -iname "*.MP4"`

for i in $VIDEOS_TO_CONVERT;
do
  NEW_FILE_NAME=`basename $i | sed 's/.MP4//i' | sed 's/.MOV//i'`;
  NEW_FILE_NAME=$NEW_FILE_NAME.avi;
  NEW_PATH=`echo $i | sed 's/originals/HD/' `;
  NEW_PATH=`dirname $NEW_PATH`;
  
  echo FOR $i
  echo NEW_FILE_NAME=$NEW_FILE_NAME;
  echo NEW_PATH=$NEW_PATH;
  TARGET_FULL_PATH="$NEW_PATH/$NEW_FILE_NAME";

  mkdir -p "$NEW_PATH";
  
  ffmpeg -i $i -vcodec mjpeg -q:v 1 -acodec pcm_s16le "$TARGET_FULL_PATH";
done