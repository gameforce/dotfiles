#!/usr/bin/python

import time
import subprocess

FIVE_MINUTES = 5*60
DEFAULT_FILE_SIZE = 1024
DEFAULT_USER = 'sandboxname1'
DEFAULT_PASSWORD = 'ftptest'
DEFAULT_HOST = 'gfs-node1'
DEFAULT_PORT = '21'
                    
def StartFTPTestClient(ftpCredentials, fileSize):
    
    COMMANDLINE = './testftp.sh %(user)s %(password)s %(port)s %(host)s %(fileSize)s'
    
    arguments = dict(ftpCredentials.items())
    arguments['fileSize'] = fileSize
    
    subprocess.Popen(COMMANDLINE % arguments, shell=True)

def GetFTPTestClientCount():
    p = subprocess.Popen('grep testftp.sh', 
                         stdin=subprocess.Popen('ps ax', 
                                                shell=True, 
                                                stdout=subprocess.PIPE).stdout, 
                         stdout=subprocess.PIPE, 
                         shell=True)
    
    stdout = p.communicate()[0]
    lines = stdout.split('\n')
    return len(lines)-1

def RunTest(maxClients, testDuration, fileSize, ftpCredentials):
    start = time.time()
    
    try:
        while time.time() < start + testDuration:
            currCleints = GetFTPTestClientCount()
            if currCleints < maxClients:
                missingClients = maxClients - currCleints
                newCleints = max(min(missingClients, 50), 5) # 5 <= newClents = missingClients <= 50
                for i in xrange(newCleints):
                    StartFTPTestClient(ftpCredentials, fileSize)
            time.sleep(0.5)
            print "Number of test processes in progress:", GetFTPTestClientCount()
    
        while GetFTPTestClientCount() > 1:
            print "Number of test processes in progress:", GetFTPTestClientCount()
            time.sleep(0.5)
    
    except KeyboardInterrupt:
         subprocess.Popen('/usr/bin/killall ./testftp.sh',stdout=subprocess.PIPE, shell=True)
         subprocess.Popen('/usr/bin/killall lftp', shell=True, stdout=subprocess.PIPE)
    print "Exiting loopFtp.py"

def Main():
    import optparse
    import sys
    
    option_list = [
        optparse.make_option('--max',
                    dest='maxClients',
                    help="the maximum number of test clients to run at once",
                    default=False,
                    ),
        optparse.make_option('--duration',
                    dest='duration',
                    help="the amount of time to run the tests",
                    default=FIVE_MINUTES,
                    ),
        optparse.make_option('--filesize',
                    dest='fileSize',
                    help="the amount of data to transfer in each file in the tests",
                    default=DEFAULT_FILE_SIZE,
                    ),
        optparse.make_option('--host',
                    dest='host',
                    help="the ftp host to test",
                    default=DEFAULT_HOST,
                    ),
        optparse.make_option('--port',
                    dest='port',
                    help="the port of the test ftp server",
                    default=DEFAULT_PORT,
                    ),
        optparse.make_option('--user',
                    dest='user',
                    help="the user used to connect to the test ftp server",
                    default=DEFAULT_USER,
                    ),
        optparse.make_option('--password',
                    dest='password',
                    help="the password used to connect to the test ftp server",
                    default=DEFAULT_PASSWORD,
                    ),
                ]

    parser = optparse.OptionParser()
    group = optparse.OptionGroup(parser, "Main Options")
    group.add_options(option_list)
    parser.add_option_group(group)
    options, args = parser.parse_args(list(sys.argv))

    for option in option_list:
        if not getattr(options, option.dest):
            parser.print_help()
            print "Not all arguments were passed... %s %s" % (option.dest, options)
            sys.exit(-1)
    
    ftpCredentials = {
              'host': options.host,
              'port': options.port,
              'user': options.user,
              'password': options.password,
          }
    
    RunTest(int(options.maxClients), int(options.duration), int(options.fileSize), ftpCredentials)
    
if __name__ == '__main__':
    Main()
