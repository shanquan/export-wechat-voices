# export-wechat-voices

## Description
This repo is mostly based on [silk-v3-decoder](https://github.com/kn007/silk-v3-decoder), it supports exporting your wechat silk voice files to timestamp named mp3 files.

This repo only works on Linux/Unix, not for windows(you can use wsl instead).

My family used to send lots of voice messages on wechat, Then I've found it's hard to save and play them outside of wechat. That's why I write this script.

## Requirement

* gcc
* ffmpeg

## How To Use
1. copy voice Directory from your phone to PC.
    The directory locations are as below for now:
    - For Android:/storage/emulated/0/tencent/MicroMsg/c5bxxx/voice2/../xxx.amr
2. `git clone https://github.com/shanquan/export-wechat-voices & cd export-wechat-voices`
3. `sh convert.sh pathToVoiceDir`

After the upper command, you will see your mp3 voice files in the `output` directory. 

## 中文说明
本项目基于[silk-v3-decoder](https://github.com/kn007/silk-v3-decoder)开发，以支持将微信里的所有语音文件按时间顺序导出mp3格式。

我们家人经常在微信中发送语音消息，我很希望能够保存这些语音（关于家人的数字记忆），但是却发现导出并播放这些语音文件有点麻烦，于是写了这个脚本。

## 依赖组件

* gcc
* ffmpeg

## 如何使用
1. 复制手机里的微信语音文件存放路径至电脑。
   - Android手机目录voice2：/storage/emulated/0/tencent/MicroMsg/c5bxxx/voice2/../xxx.amr
2. `git clone https://github.com/shanquan/export-wechat-voices & cd export-wechat-voices`
3. `sh convert.sh pathToVoiceDir`

脚本命令执行完毕后，可以在`output`文件夹下查看mp3格式的语音文件。
