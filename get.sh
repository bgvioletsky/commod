#!/bin/bash

file_folder=$(date "+%Y-%m-%d")
threshold=$1
if [ ! -d "$file_folder" ]; then
  mkdir "$file_folder"
fi
if [ ! -d img_name.txt ]; then
  touch img_name.txt
fi
geturl(){
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
            echo "$file_name"
            echo "$file_name" >> img_name.txt  # 添加新的文件名到 img_name.txt 文件
        fi
        ((counter++))
    done
    echo "${links[@]}"
}
download(){
    wget -q --show-progress -P "$1" -O "$2" -c "$3"
}
creat(){
  cdn_prefix="https://cdn.jsdelivr.net/gh/bgvioletsky/testaction"
  find . -type f -iname "*.jpg" | awk 'length($0) >= 13' | jq --arg prefix "$cdn_prefix" -R -s  '[split("\n")[] | select(. != "") | sub("^\\."; "") | $prefix + .]' > img_url.json
}
main(){
  links=($(geturl))
  for link in "${links[@]}"
  do 
    file_name=$(basename "$link")
    download "$file_folder" "$file_folder/$file_name" "$link"
  done
  creat
}
main

