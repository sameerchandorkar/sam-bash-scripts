#!/bin/bash

directory_name=$1
start_number=$2
end_number=$3

for (( i=start_number; i<=end_number; i++ ))
do
  dir_name="${directory_name}_${i}"
  mkdir "$dir_name"
done
