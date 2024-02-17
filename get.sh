#!/bin/bash

file_folder=$(date "+%Y-%m-%d")
# file_folder="2024-01-1"
threshold=20
if [ ! -d "$file_folder" ]; then
  mkdir "$file_folder"
else 
  rm -rf  "$file_folder"
  mkdir "$file_folder"
fi
if [ ! -d img_name.txt ]; then
  touch img_name.txt
fi
main(){
    url="https://www.dmoe.cc/random.php?return=json"
    links=()
    counter=1
    while [ $counter -le $threshold ]
    do
        response=$(curl -s "$url")
        link=$(echo "$response" | jq -r '.imgurl')
        file_name=$(basename "$link")
        # 检查 img_name.txt 中是否存在相同的文件名，如果不存在则添加链接
        if ! grep -q "$file_name" img_name.txt; then
            links+=("$link")
            wget -q --show-progress -P "$file_folder" -O "$file_folder/$file_name" -c "$link"
            echo "$file_name" >> img_name.txt  # 添加新的文件名到 img_name.txt 文件
        fi
        ((counter++))
    done
}

main

