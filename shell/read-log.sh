#!/bin/bash
filename=$1
while read -r line
do
    name=$line
    echo "Read log entry --> $name"
    echo $name | nc localhost 42424
    sleep 0.1
done < $filename
