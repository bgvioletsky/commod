#!/bin/bash
###
 # @Author: bgcode
 # @Date: 2024-07-18 21:56:04
 # @LastEditors: bgcode
 # @LastEditTime: 2024-07-19 01:08:07
 # @Description: 
 # @FilePath: /commod/test.sh
### 
work_folder=$(pwd)
# mkdir ~/kk
# open ~/kk
rm -rf ~/kk
loacl=$(pwd)
cd $work_folder
pwd
echo $loacl

bg='<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
     <dict>
         <key>Label</key>
         <string>ci.nn.alist</string>
         <key>KeepAlive</key>
         <true/>
         <key>ProcessType</key>
         <string>Background</string>
         <key>RunAtLoad</key>
         <true/>
         <key>WorkingDirectory</key>
         <string>/Users/bgcode/.alist/bin</string>
         <key>ProgramArguments</key>
         <array>
             <string>/Users/bgcode/.alist/bin/alist</string>
             <string>server</string>
         </array>
     </dict>
</plist>
'
echo $bg > ~/Library/LaunchAgents/ci.nn.alist.plist
launchctl load ~/Library/LaunchAgents/ci.nn.alist.plist