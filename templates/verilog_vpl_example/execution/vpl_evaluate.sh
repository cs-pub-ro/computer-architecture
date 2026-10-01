#!/bin/sh
# Used to load MOODLE_USER_ID and everything else. Quit if not VPL environment
# Do not run this script in circumstances other than VPL or ./evaluate.sh (in parent), since we overwrite execution files
# If you decided to bypass this protection, reset the execution files to their original state manually!
. ./vpl_environment.sh || exit 1

# To be changed right before assignment is sent
SECRET=0

generate_date() {
    variation=$(date +"%d%H")
    # make sure variation is a number
    variation=$(expr $variation + 0)
    # variation will be the same for 2 consecutive hours
    variation=$(expr $variation / 2 \* 2)
    echo $variation
}

concat_variation_variables() {
    date_variation=$(generate_date) # Toggle every 2 hours
    # date_variation=0                # Disable time based changes
    STUDENT_ID=$MOODLE_USER_ID      # Enable student id variation
    # STUDENT_ID=0                    # Disable student id variation
    echo "$MOODLE_USER_ID:$SECRET:$date_variation"
}
# Prefer to use hash because if variation accidentally leaks in checker output, it should be hard to reverse SECRET
generate_variation() {
    echo "$(concat_variation_variables)" | sha256sum | awk '{print $1}'
}

# In case variation is leaked, use another value to extract checker output
generate_checker_unique_out() {
    echo "$(concat_variation_variables):CHECKER" | sha256sum | awk '{print $1}'
}
variation=$(generate_variation)
task="$(python3 task.py $variation)"
flags="$(python3 gen_flags.py $variation)"
checker=$(generate_checker_unique_out)
# Prevent students from interfering with the $display calls from the checker
sed -i -e "s/\[CHECKER\]/[CHECKER: $checker]/g" top.v

echo "$task"

iverilog -Wall -Winfloop top.v lut.v -o top.vvp
iverilog -Wall -Winfloop $flags top.v lut_sol.v -o top_sol.vvp

# Do not let students find out [CHECKER: <hash>] prefix from just a simple grep on top.v, let them work harder for it
rm top.v

if [ $? -ne 0 ]; then
    echo "Error: iverilog failed" >&2
    exit 1
fi

vvp top.vvp | grep "^\[CHECKER: $checker\]" | sed -e "s/^\[CHECKER: $checker\]//g" > evaluate.out
vvp top_sol.vvp | grep "^\[CHECKER: $checker\]" | sed -e "s/^\[CHECKER: $checker\]//g" > sol.out

grade=$(python3 grade.py $variation)
echo "echo 'Grade :=>> $grade'" > vpl_execution
chmod +x ./vpl_execution
