#!/bin/bash
# File: convert.sh
# Date: April 3rd, 2020
# Time: 16:07 +0800
# Author: sq <2495742347@qq.com>
# Usage: 
# 1. copy /storage/emulated/0/tencent/MicroMsg/c5bxxx/voice2/ to your PC.
# 2. git clone https://github.com/shanquan/export-wechat-voices
# 4. sh convert.sh pathTovoice2
# Requirement: gcc ffmpeg

# Colors
RED="$(tput setaf 1 2>/dev/null || echo '\e[0;31m')"
GREEN="$(tput setaf 2 2>/dev/null || echo '\e[0;32m')"
YELLOW="$(tput setaf 3 2>/dev/null || echo '\e[0;33m')"
WHITE="$(tput setaf 7 2>/dev/null || echo '\e[0;37m')"
RESET="$(tput sgr 0 2>/dev/null || echo '\e[0m')"

function convert(){
[ ! -d "$1" ]&&echo -e "${RED}[Error]${RESET} Input folder not found, please check it."&&exit
for file in `find $1 -name "*.amr" -o -name "*.silk"`
do
 if [ -d $1"/"$file ]
 then
 read_dir $1"/"$file
 else
 # full path
 #echo `pwd`"/"$file
 # last modify timestamp
 LAST_MODIFY_TIMESTAMP=`stat -c %Y  $file`
 formart_date=`date '+%Y-%m-%d-%H%M%S' -d @$LAST_MODIFY_TIMESTAMP`
 # append to log file
 # see ref: https://www.cnblogs.com/hurryup/articles/10241601.html
 FILE_NAME=${file##*/}
 if [ ${FILE_NAME:0:5} != "msg__" ];then
   #echo "$formart_date,$FILE_NAME" >> output/data.log
   #cp $file "output/$formart_date.amr"
	 i=0
	 while [ -f "output/$formart_date.$i.mp3" ]; do i=$[$i+1] ;done
	 transform $file "$formart_date.$i"
 fi
 fi
done
}

function clear_output(){
  if [ -d "output" ];then
  rm -rf output
  fi
  mkdir output
}

function transform(){
  [[ ! -z "$(pidof ffmpeg)" ]]&&echo -e "${RED}[Error]${RESET} ffmpeg is occupied by another application, please check it."&&exit
  let CURRENT+=1
		$cur_dir/silk/decoder $1 "output/$2.pcm" > /dev/null 2>&1
		if [ ! -f "output/$2.pcm" ]; then
			ffmpeg -y -i "$1" "output/$2.mp3" > /dev/null 2>&1 &
			ffmpeg_pid=$!
			while kill -0 "$ffmpeg_pid"; do sleep 1; done > /dev/null 2>&1
			[ -f "output/$2.mp3" ]&&echo -e "[$CURRENT]${GREEN}[OK]${RESET} Convert $1 to output/$2.mp3 success, ${YELLOW}but not a silk v3 encoded file.${RESET}"&&continue
			echo -e "[$CURRENT]${YELLOW}[Warning]${RESET} Convert $1 false, maybe not a silk v3 encoded file."&&continue
		fi
		ffmpeg -y -f s16le -ar 24000 -ac 1 -i "output/$2.pcm" "output/$2.mp3" > /dev/null 2>&1 &
		ffmpeg_pid=$!
		while kill -0 "$ffmpeg_pid"; do sleep 1; done > /dev/null 2>&1
		rm "output/$2.pcm"
		[ ! -f "output/$2.mp3" ]&&echo -e "[$CURRENT]${YELLOW}[Warning]${RESET} Convert $1 false, maybe ffmpeg no format handler for $3."&&continue
		echo -e "[$CURRENT]${GREEN}[OK]${RESET} Convert $1 To output/$2.mp3 Finish."
}

# test on wsl ubuntu 18.04
# Main
cur_dir=$(cd `dirname $0`; pwd)
CURRENT=0

if [ ! -r "$cur_dir/silk/decoder" ]; then
	echo -e "${WHITE}[Notice]${RESET} Silk v3 Decoder is not found, compile it."
	cd $cur_dir/silk
	make && make decoder
	[ ! -r "$cur_dir/silk/decoder" ]&&echo -e "${RED}[Error]${RESET} Silk v3 Decoder Compile False, Please Check Your System For GCC."&&exit
	echo -e "${WHITE}========= Silk v3 Decoder Compile Finish =========${RESET}"
fi

cd $cur_dir
clear_output
convert $1
