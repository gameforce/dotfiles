# List test
 74 ${LFTP} -u ${USERNAME},${PASSWORD} -p${PORT} -e "LS; QUIT" ${HOSTNAME} &> /dev/null
 lftp -u sandboxname1,ftptest -p21 -e "LS; QUIT"
 
 75 result=$?
 76 if [ ${result} != 0 ]; then
 77     f_cri "FTP check failed when trying to list the contents of a directory."
 78 fi
 79 
 80 # Put test
 81 ${LFTP} -u ${USERNAME},${PASSWORD} -p${PORT} -e "PUT ${FILEPATH}; QUIT" ${HOSTNAME} &> /dev/null
 82 result=$?
 83 if [ ${result} != 0 ]; then
 84     f_cri "FTP check failed when trying to put a file into a directory."
 85 fi
 86 
 87 # Get test
 88 ${LFTP} -u ${USERNAME},${PASSWORD} -p${PORT} -e "LCD ${FILEDIR}; GET ${FILENAME}; quit" ${HOSTNAME} &> /dev/null
 89 result=$?
 90 if [ ${result} != 0 ]; then
 91     f_cri "FTP check failed when trying to get a file from a directory."
 92 fi
 93 
 94 # Get test
 95 ${LFTP} -u ${USERNAME},${PASSWORD} -p${PORT} -e "RM -f ${FILENAME}; QUIT" ${HOSTNAME} &> /dev/null
 96 result=$?
 97 if [ ${result} != 0 ]; then
 98     f_cri "FTP check failed when trying to delete a file from a directory."
 99 fi
 
 ftpcheck.sh sandboxname1 ftptest 21 gfs-node1
`head -c 24k /dev/urandom` > .fspftpcheck.$(/bin/date +s%)

