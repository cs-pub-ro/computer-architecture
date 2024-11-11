#!/bin/bash
variation=$(date +"%d%H")
# make sure variation is a number
variation=$(expr $variation + 0)
# variation will be the same for 2 consecutive hours
if [ $((variation % 2)) == 0 ]; then
    variation=variation
else
    variation=$(expr $variation - 1)
fi

echo $variation