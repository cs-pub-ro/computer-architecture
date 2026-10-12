#!/bin/sh
# Shared by vpl_run.sh and vpl_evaluate.sh so that "Run" and "Evaluate" always
# show/grade the exact same personalized task.
# Requires ./vpl_environment.sh to have been sourced (provides MOODLE_USER_ID).

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