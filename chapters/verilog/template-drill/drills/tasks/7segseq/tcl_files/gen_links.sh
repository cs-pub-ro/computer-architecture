#!/bin/bash
# Generate hard links to the Verilog files in the root of the task directory
for file in $(ls | grep '\.v\|\.xdc'); do 
    filename=$(basename "$file")
    proj_name=$(find build_project -name $filename)
    rm -f $proj_name
    ln $file $proj_name
done
    



