#!/bin/bash

if [ $# -ne 1 ]; then
    echo "Usage: $0 <last_digits_of_IP>"
    exit 1
fi

last_digits=$1
destination="192.168.8.$last_digits"

rsync -avz --recursive --progress --exclude '*/build/*' --exclude '*.git' --exclude '*/devel/*' --exclude '*.bag' ~/voxl2_home/ root@$destination:/home/root/kumarRobotics/
