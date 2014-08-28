#!/usr/bin/env python
import httplib
import urllib
import socket

# Test with HTTPlib
conn = httplib.HTTPConnection("yoostar2.bucket.int.s3.amazonaws.com")
#conn.request("GET", "/UserMediaQ/User.9/PERFORMANCE/ParentMedia.1/20100816_0913_1.ogg_perf_out.ogg")
#r1 = conn.getresponse()
#print r1.status, r1.reason

# Test with URLlib
#response = urllib.urlopen("http://yoostar2.bucket.int.s3.amazonaws.com/UserMediaQ/User.9/PERFORMANCE/ParentMedia.1/20100816_0913_1.ogg_perf_out.ogg")
#print 'URL     :', response.geturl()

res = socket.getaddrinfo("yoostar2.bucket.int.s3.amazonaws.com", 80)
print res
