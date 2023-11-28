#!/bin/bash

read -p "원하는 별의 크기를 입력하세요: " n

height=$((3 * 2 ** n))
width=$(($height*2))
length=$(($width*$height))


arr=()

for ((i=0; i<length; i++)); do
  arr+=(' ')
done

for ((i=1; i<height; i++)); do
  index=$(( i*width - 1 ))
  arr[$index]='\n'
done


triangle() {
  local s=$1
  local x=$2
  local y=$3

  if [ $s -eq 3 ]; then
    local p=$((y * w + x))
    arr[$((x+y*width+2))]="*"
    arr[$((x+y*width+width+1))]="*"
    arr[$((x+y*width+width+3))]="*"
    arr[$((x+y*width+width*2+1))]="*"
    arr[$((x+y*width+width*2+2))]="*"
    arr[$((x+y*width+width*2+3))]="*"
    arr[$((x+y*width+width*2+4))]="*"
    arr[$((x+y*width+width*2))]="*"
    return
  fi

  local hS=$((s / 2))
  triangle $hS $((x + hS)) $y
  triangle $hS $x $((y + hS))
  triangle $hS $((x + s)) $((y + hS))
}

triangle $height 0 0



result=$(printf "%s" "${arr[@]}")

# 결과 출력
echo -e "$result"