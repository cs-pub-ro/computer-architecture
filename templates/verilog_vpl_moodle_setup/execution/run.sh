#!/bin/sh
## VPL "Run" simulation script (counterpart of evaluate.sh)
## Stages: vpl_run.sh builds ./vpl_execution, then ./vpl_execution is executed.
test -d submission/ || cp -r required submission/

TMP_DIR=$(mktemp -d)

cp submission/* $TMP_DIR/
cp execution/* $TMP_DIR/
cd $TMP_DIR

echo "export MOODLE_USER_ID=${STUDENT_ID:-0}" > $TMP_DIR/vpl_environment.sh

echo "========= COMPILATION ========="
./vpl_run.sh

if [ $? -ne 0 ]; then
	echo "========== FAILED =========="
	cd /tmp
	if [ "$1" != "KEEP_TMP" ]; then rm -rf $TMP_DIR; else echo $TMP_DIR; fi
	exit 1
fi

echo "========= EXECUTION ========="
./vpl_execution 2>&1

cd /tmp
if [ "$1" != "KEEP_TMP" ]; then rm -rf $TMP_DIR; else echo $TMP_DIR; fi