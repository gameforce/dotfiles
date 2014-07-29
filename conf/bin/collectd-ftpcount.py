#!/usr/bin/python

import os
import optparse
import sys
import subprocess
import re
import time
    
def PrintFtpCount(host, instanceId, scoreCardFile, interval):
    userCount = -1
    cmd = 'ftpcount -f %s' % scoreCardFile
    
    p = subprocess.Popen(cmd, shell = True, stdout = subprocess.PIPE)
    p.wait()
    stdout, stderr = p.communicate()
    
    userCountMatch = re.search('(\d+) users', stdout)
    
    if userCountMatch:
        userCount = int(userCountMatch.group(1))
    
    if instanceId:
        instanceId = "-" + instanceId
    else:
        instanceId = ""
    
    print "PUTVAL %s/ftpUserCount%s/gauge-FtpUsers interval=%s %d:%s.0" % (host, instanceId, interval, time.time(), userCount)
    sys.stdout.flush()


def main():
    optional_option_list = [
        optparse.make_option('--host',
                    dest='host',
                    help="the host's name",
                    default='localhost',
                    ),
        optparse.make_option('--instanceId',
                    dest='instanceId',
                    help="the name of this ftp user count",
                    default=False,
                    ),
        optparse.make_option('--interval',
                    dest='interval',
                    help="the interval (in seconds) between taking ftp user counts",
                    default=10,
                    ),
        ]

    mandatory_option_list = [
        optparse.make_option('--scoreCardFile',
                    dest='scoreCardFile',
                    help="the path to the ftp scrorecard file",
                    default=False,
                    ),
        ]
    
    parser = optparse.OptionParser()
    
    group = optparse.OptionGroup(parser, "Mandatory Arguments")
    group.add_options(mandatory_option_list)
    parser.add_option_group(group)
    
    group = optparse.OptionGroup(parser, "Optional Arguments")
    group.add_options(optional_option_list)
    parser.add_option_group(group)
    
    options, args = parser.parse_args(list(sys.argv))
    
    ########

    for option in mandatory_option_list:
        if not getattr(options, option.dest):
            raise Exception("Not all arguments were passed... %s %s" % (options, option.dest))

    interval = int(options.interval)

    while True:
        now = startTime = time.time()
        while now < startTime + interval:
            time.sleep((startTime + interval) - now)
            now = time.time()
            
        PrintFtpCount(options.host, options.instanceId, options.scoreCardFile, interval)
            

    
if __name__ == '__main__':
    main()
