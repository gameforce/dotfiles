#  
#  (c) Copyright 1998-2008, Quazal Technologies Inc.
#  ALL RIGHTS RESERVED
#  
#  Net-Z, Eterna, Rendez-Vous, Duplicated Object and Duplication Space 
#  are trademarks of Quazal.
#  
#  Use of this software indicates acceptance of the End User licence
#  Agreement for this product. A copy of the EULA is available from
#  www.quazal.com.
#    

import SystemConfiguration
import quazal
#import Spark
#import SonyNP
#import XboxLSP
#XboxLSP.SetGamerTagSync_XBoxLiveWebServicesEnvironment_Testing()
#import Cache
#import DBI

## XMlRPC https setup (these files are on samba share)
#SSL_SERVER_KEYFILE = "../../../../rvcertificates/key-xmlrpc-sandbox_name.pem"
#SSL_SERVER_CERTFILE = "../../../../rvcertificates/xmlrpc-sandbox_name.pem"
#SSL_SERVER_KEYFILE_PASSWORD = "XXXXXXXXXXXXXXXXXXXXXXXX"
#import QXMLRPCServer
#protocol = QXMLRPCServer.XMLRPCServerProtocol()
#protocol.EnableSSL(SSL_SERVER_KEYFILE, SSL_SERVER_CERTFILE, SSL_SERVER_KEYFILE_PASSWORD)

## Content Sharing setup 
#import ContentSharing
#ContentSharing.GetInstance().SetFTPInfo(address='lftp1.quazal.net', port=21, user='ftp_username', password='XXXXXXXXXXXXX')  # XLSP
#ContentSharing.GetInstance().SetFTPInfo(address='lftp1.quazal.net', port=22, user='ftp_username', password='XXXXXXXXXXXXX')  # PS3 or PC

##
# Site-specific system configuration module for Rendez-Vous sandbox daemon(s)
#
class SiteConfiguration(SystemConfiguration.SystemConfiguration):

#    def ConfigurePackages(self):
#	SonyNP.GetInstance().SetCipherFilePath('./Scripts/Admin/CYPHER_FILE.HERE')

    def ConfigureDatabase(self):
	# WARNING: base class implementation MUST be called FIRST.
	SystemConfiguration.SystemConfiguration.ConfigureDatabase(self)
	self.logger.info('SiteConfiguration.ConfigureDatabase() BEGIN')
	self.logger.info('SiteConfiguration.ConfigureDatabase() END')

    def ConfigureSandboxNode(self):
	# WARNING: base class implementation MUST be called FIRST.
	SystemConfiguration.SystemConfiguration.ConfigureSandboxNode(self)
	self.logger.info('SiteConfiguration.ConfigureSandboxNode() BEGIN')
	self.ConfigureSanityCheck()
	quazal.ServiceHost.GetInstance().GetSecureStreamManager().SetNbThreads(2)
	quazal.CallProfiler().GetInstance().SetSlowCallThreshold(500)
	quazal.ServiceHost.GetInstance().EnableRotatingLogDeviceBySize('rv.log', 1000, 10)
#	quazal.Network.UseCompressionAlgorithm(quazal.Network.LZoComp)
	self.ConfigureLogLevel()

	# Memcached conf
#	Cache.Cache.PerfCounter = (quazal.PerfCounter)
#	Cache.RemoteCache.SetServers(["memcached1:11211","memcached2:11211"])
	# Test that the RemoteCache is online
#	mc = Cache.RemoteCache("QuazalTestCache")
#	mc.Set("MyKey", 123)
#	try:
#	    newval = mc.Get("MyKey")
#	    if newval == 123:
#	         self.logger.info("RemoteCache is working")
#	    else:
#	         self.logger.info("RemoteCache is not working correctly, it returned a bad value")
#	except Cache.Cache.CacheMiss:
#	    self.logger.info("RemoteCache is not responding!")
	# end of memcache configuration

	self.logger.info('SiteConfiguration.ConfigureSandboxNode() END')

    def ConfigureLogLevel(self):
	import logging
	#self.logger.setLevel(logging.WARNING) #For LIVE
	self.logger.setLevel(logging.DEBUG) #For DEV or debug

    def ConfigureSanityCheck(self):
	import SanityCheck
	SanityCheck.controller.SetFixableStatus(SanityCheck.Bootstrap,[SanityCheck.StatusWarning, SanityCheck.StatusError])
