#!/bin/bash
#
# vpl_run.sh script 

# github repository
HELPER_SCRIPTS_DIR=../../common
# vpl
# HELPER_SCRIPTS_DIR=.

# source helper functions (for VPL add the Makefile in the files keep during running)
MAKEFILE=${HELPER_SCRIPTS_DIR}/Makefile

# --- Set the variables for the assignment ---
TOP_MODULE=opregister
OTHER_SOURCES=

cat > vpl_execution <<EEOOFF
#!/bin/bash

#--- compile and run the code ---
MAKE_CMD="make -f ${MAKEFILE} run TOP_MODULE=${TOP_MODULE} OTHER_SOURCES=${OTHER_SOURCES}"
eval \$MAKE_CMD &> user.out
cat user.out
rm user.out

EEOOFF

chmod +x vpl_execution