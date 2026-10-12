#!/bin/sh
# Personalizare: valorile fiecărui student se derivă din MOODLE_USER_ID și SECRET (aceleași la Run și la Evaluate).
# Requires ./vpl_environment.sh to have been sourced (provides MOODLE_USER_ID).

# To be changed right before assignment is sent. Use the SAME value in all personalized activities.
SECRET=0

# Same student + same SECRET => same variation (no date involved)
generate_variation() {
    echo "$MOODLE_USER_ID:$SECRET" | sha256sum | awk '{print $1}'
}

# In case variation is leaked, use another value to extract checker output
generate_checker_unique_out() {
    echo "$(generate_variation):CHECKER:$(date +%d%H)" | sha256sum | awk '{print $1}'
}
