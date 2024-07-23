#!/bin/bash
###
 # @Author: bgcode
 # @Date: 2024-07-18 19:27:51
 # @LastEditors: bgcode
 # @LastEditTime: 2024-07-22 15:36:01
 # @Description: 一个脚本用于配制本机相应环境
 # @FilePath: /commod/box.sh
### 

# 定义一个彩色输出的通用函数，通过参数传递颜色代码和文本内容
function print_colored(){
    # 参数校验：确保至少有一个参数
    if [ $# -lt 1 ]; then
        echo "Error: No text to print."
        return 1
    fi

    # 输出彩色文本
    echo -e "\033[$1m\033[01m$2 \033[0m"
}
function print_2colored(){
    # 参数校验：确保至少有一个参数
    if [ $# -lt 3 ]; then
        echo "Error: No text to print."
        return 1
    fi

    # 输出彩色文本
    echo -e "\033[$1m\033[01m$2 \033[0m\033[$3m\033[01m$4 \033[0m"
}
# 以下为各种颜色的文本输出函数
# 使用通用彩色输出函数，传入颜色代码和文本
function black(){
    print_colored 30 "$1"   # 黑色
}
function red(){
    print_colored 31 "$1"   # 红色
}
function green(){
    print_colored 32 "$1"   # 绿色
}
function yellow(){
    print_colored 33 "$1"   # 黄色
}
function blue(){
    print_colored 34 "$1"   # 蓝色
}
function purple(){
    print_colored 35 "$1"   # 紫色
}
function cyan(){
    print_colored 36 "$1"  # 青色
}
function white(){
    print_colored 37 "$1"   # 白色
}

# 特殊的彩色组合输出函数
function xuanzhe(){
    # 由于需要不同的颜色组合，此处仍然保持直接编码，但添加了注释说明
    echo -e "\033[30m\033[01m$1\033[0m" "\033[35m\033[01m$2 \033[0m"  # 黑色和紫色组合
}

function jianjie(){
    # 使用注释说明颜色
    echo -e "\033[30m\033[01m$1\033[0m" "\033[34m\033[01m$2 \033[0m"  # 黑色和蓝色组合
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
    read -p "用户名" name
    read -p "密码" password 
    ./alist $name set $password
    clear
    echo "安装完成"
    echo "请打开浏览器访问 http://localhost:5244"
    echo "账号为:$name"
    echo "密码为:$password"
}

uninstall_alist(){
    cd ~/.bgcode
    rm -rf alist
    cd ~/Library/LaunchAgents
    rm -rf ci.nn.alist.plist
    echo "alist have been uninstall"
}

function installhomebrew(){
    clear
    green "开始安装homebrew"
    /bin/zsh -c "$(curl -fsSL  https://cdn.jsdelivr.net/gh/Codebglh/command@0.0.3/Mac/Homebrew.sh)"
    green "安装homebrew完成"
    purple "退出请按q 键"
    purple "回到菜单请按任意键"
    read -p "请输入：" quit
    case $quit  in
        q )
           exit 1
	    ;;
        * )
            clear
            choice
        ;;
    esac
    choice
}


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
           installhomebrew
	    ;;
        2 )
           ohmyzsh
	    ;;
        3 )
           test
	    ;;
         4 )
           test
	    ;;
         5 )
           install_alist
	    ;;
         6 )
           uninstall_alist
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
choice