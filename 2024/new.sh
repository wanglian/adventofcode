#!/bin/bash
day=$1
sed -e "s/{day}/$day/g" ./skeleton.rb > ./day$day.rb
touch ./input/day$day.txt
git add .
