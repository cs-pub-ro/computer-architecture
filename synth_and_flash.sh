#!/bin/bash
filename=$(basename -- "$1")
TOP="${filename%.*}"
CWD=$(dirname -- "$1")
cd $CWD
docker run -it -v .:/work openfpgatoolchain $TOP
openFPGALoader -b arty_a7_100t $TOP.bit