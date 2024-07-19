#!/bin/bash
###
 # @Author: bgcode
 # @Date: 2024-07-18 19:27:51
 # @LastEditors: bgcode
 # @LastEditTime: 2024-07-19 08:21:13
 # @Description: 
 # @FilePath: /commod/box.sh
### 

function black(){
       echo -e "\033[30m\033[01m$1 \033[0m"  #黑色
}
function red(){
       echo -e "\033[31m\033[01m$1 \033[0m"  #红色
}
function green(){
       echo -e "\033[32m\033[01m$1 \033[0m"  #绿色
}
function yellow(){
       echo -e "\033[33m\033[01m$1 \033[0m"  #黄色
}
function blue(){
       echo -e "\033[34m\033[01m$1 \033[0m"  #蓝色
}
function purple(){
       echo -e "\033[35m\033[01m$1 \033[0m"  #紫色
}
function cyan(){
       echo -e "\033[36m\033[01m$1 \033[0m"  #请色
}
function white(){
       echo -e "\033[37m\033[01m$1 \033[0m"  #白色
}
folder_name=".bgcode"
    
# 安装 alist          
install_alist(){
    cd ~
    local=$(pwd)
    mkdir -p "$folder_name"
    cd "$folder_name"  
    # 获取 alist 的最新版本号
    latest_version=$(curl -s https://api.github.com/repos/alist-org/alist/releases/latest | jq -r '.tag_name')
    # 获取 alist 的下载链接
    download_url="https://mirror.ghproxy.com/https://github.com/Xhofe/alist/releases/download/$latest_version/alist-darwin-amd64.tar.gz"
    wget  --show-progress $download_url
    tar -xzvf alist-darwin-amd64.tar.gz
    rm -rf alist-darwin-amd64.tar.gz
    mv alist  aaa
    mkdir alist
    mv aaa ./alist/alist
    working_dir_path="$local/.bgcode/alist"
    alist_path="$local/.bgcode/alist/alist"
    echo $alist_path
    # 定义plist文件内容，移除特殊字符并采用正确的XML格式
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
            <string>'$working_dir_path'</string>
            <key>ProgramArguments</key>
            <array>
                <string>'$alist_path'</string>
                <string>server</string>
            </array>
        </dict>
    </plist>'

    # 检查是否有写入~/Library/LaunchAgents目录的权限
    if ! test -w ~/Library/LaunchAgents; then
        echo "Error: Insufficient permissions to write to ~/Library/LaunchAgents directory."
        exit 1
    fi

    # 使用临时文件来提高文件操作的可靠性
    temp_file=$(mktemp)

    # 将plist内容写入临时文件
    echo "$bg" > "$temp_file"

    # 检查文件写入是否成功
    if test $? -ne 0; then
        echo "Error: Failed to write to the temporary file."
        rm "$temp_file"
        exit 1
    fi

    # 将临时文件移动到最终位置
    if mv "$temp_file" ~/Library/LaunchAgents/ci.nn.alist.plist; then
        echo "Successfully created ~/Library/LaunchAgents/ci.nn.alist.plist."
    else
        echo "Error: Failed to move the temporary file to the final location."
        rm "$temp_file"
        exit 1
    fi

    # 清理：在正常执行完毕后，无需保留临时文件
    rm "$temp_file"
    launchctl load ~/Library/LaunchAgents/ci.nn.alist.plist
    cd ~/.bgcode/alist
    chmod +x alist
    ./alist admin set bgcode
    clear
    echo "安装完成"
    echo "请打开浏览器访问 http://localhost:5244"
    echo "账号为:admin"
    echo "密码为:bgcode"
}

uninstall_alist(){
    cd ~/.bgcode
    rm -rf alist
    cd ~/Library/LaunchAgents
    rm -rf ci.nn.alist.plist
    echo "alist have been uninstall"
}


install_alist

function choice(){
    cyan " -----------------------------------------------------------------------"
    xuanzhe " 1." " 安装homebrew"
    xuanzhe " 2." " 卸载homebrewh"
    xuanzhe " 3." " 安装ohmyzsh"
    xuanzhe " 4." " 卸载ohmyzsh"
    xuanzhe " 5." " 安装alist"
    xuanzhe " 6." " 卸载alist"
    xuanzhe " 0." " 退出脚本"
    echo
    read -p "请输入一个数字：" number
    case $number  in
        1 )
           inhomebrew
	    ;;
        2 )
           ohmyzsh
	    ;;
        3 )
           test
	    ;;
        0 )
            exit 1
        ;;
        * )
            clear
            red "请输入正确数字 !"
            choice
        ;;
    esac
}