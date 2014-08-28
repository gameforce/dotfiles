#!/bin/bash

# Expected parameters, in order:
# USERNAME: Username to use to log into the ftp server
# PASSWORD: Password that corresponds to the username to log into the server
# PORT: Port on which the ftp server is listening
# HOSTNAME: Machine on which the ftp server is running

# exit status will be:
# 0 if the ftp transactions work correctly
# 1 n/a
# 2 if the ftp transactions do not work correctly
# 3 if the number of arguments is incorrect or the executable cannot be found

FILEDIR="/tmp/"
DATE=`/bin/date +%s`
FILENAME=ftpcheck.$DATE
FILEPATH=${FILEDIR}${FILENAME}
	
function setup {
/usr/bin/head -c ${SIZE}k /dev/urandom > $FILEPATH
}

function teardown {
    /bin/rm -f ${FILEPATH}
}

function f_ok {
    teardown
    echo "OK: "${1}
    exit 0
}

function f_war {
    teardown
    echo "WARNING: "${1}
    exit 1
}

function f_cri {
    teardown
    echo "CRITICAL: "${1}
    exit 2
}

function f_unk {
    teardown
    echo "UNKNOWN: "${1}
    exit 3
}

EXP_ARGS=5

if [ ${#} -ne ${EXP_ARGS} ]; then
    f_unk "Expected ${EXP_ARGS} arguments, but received ${#}"
fi

LFTP="/usr/bin/lftp"

if ! [ -x ${LFTP} ]; then
    f_unk "Executable ${LFTP} is not accessible"
fi

USERNAME=${1}
PASSWORD=${2}
PORT=${3}
HOSTNAME=${4}
SIZE=${5}

# Initialize
setup

# List test
${LFTP} -u ${USERNAME},${PASSWORD} -p${PORT} -e "LS; QUIT" ${HOSTNAME} &> /dev/null
result=$?
if [ ${result} != 0 ]; then
    f_cri "FTP check failed when trying to list the contents of a directory."
fi

# Put test
${LFTP} -u ${USERNAME},${PASSWORD} -p${PORT} -e "PUT ${FILEPATH}; QUIT" ${HOSTNAME} &> /dev/null
result=$?
if [ ${result} != 0 ]; then
    f_cri "FTP check failed when trying to put a file into a directory."
fi

# Get test
${LFTP} -u ${USERNAME},${PASSWORD} -p${PORT} -e "LCD ${FILEDIR}; GET ${FILENAME}; quit" ${HOSTNAME} &> /dev/null
result=$?
if [ ${result} != 0 ]; then
    f_cri "FTP check failed when trying to get a file from a directory."
fi

# Get test
${LFTP} -u ${USERNAME},${PASSWORD} -p${PORT} -e "RM -f ${FILENAME}; QUIT" ${HOSTNAME} &> /dev/null
result=$?
if [ ${result} != 0 ]; then
    f_cri "FTP check failed when trying to delete a file from a directory."
fi

f_ok "FTP fully checked, all tests successful."


