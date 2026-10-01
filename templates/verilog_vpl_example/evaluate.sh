#/bin/sh
## VPL evaluation environment simulation script
## There are 3 stages that vpl goes through:
## 2. the running of the vpl_evaluate.sh script, which is supposed to generate an executable ./vpl_execution script
## 3. the ./vpl_execution script will be executed if 
# Public directory is ep
test -d submission/ || cp -r required submission/

TMP_DIR=$(mktemp -d)

cp submission/* $TMP_DIR/
cp execution/* $TMP_DIR/
cp ASSIGNMENT.md $TMP_DIR/
cd $TMP_DIR

echo "export MOODLE_USER_ID=${STUDENT_ID:-0}" > $TMP_DIR/vpl_environment.sh

echo "========= DESCRIPTION ========="
cat ASSIGNMENT.md
echo "========= COMPILATION ========="

./vpl_evaluate.sh

if [  $? -ne 0 ]; then
	echo "========== FAILED =========="
	cd /tmp
	if [ "$1" != "KEEP_TMP" ]; then rm -rf $TMP_DIR; else echo $TMP_DIR; fi
	exit 1
fi

echo "========= EXECUTION ========="

output=$(./vpl_execution 2>&1)
echo "$output" | grep -v "^Grade :=>> "

grade=$(echo "$output" | grep "Grade" | tail -n 1 | awk '{print $3}')

if [ -z $grade ]; then
	echo "========== FAILED =========="
else
	echo "======== Grade received: $grade ========"
fi
cd /tmp
if [ "$1" != "KEEP_TMP" ]; then rm -rf $TMP_DIR; else echo $TMP_DIR; fi
