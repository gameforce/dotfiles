#! /usr/bin/env python

# Config
RTMPDUMP_PATH = "rtmpdump"
MPLAYER_PATH = "mplayer"
# End of config

import os, sys
from subprocess import *

# Check for -install flag
if "-install" == sys.argv[1]:
    if 0 != os.geteuid():
        print "Installer need to be run as root!"
        sys.exit()

    print "Installing MPlayer and Build-Essential..."
    call( "apt-get install mplayer build-essential libssl-dev", shell = True )
    print "Downloading rtmpdump source..."
    call( "wget -O rtmpdump.tar.gz http://rtmpdump.mplayerhq.hu/download/rtmpdump-2.1c.tar.gz", shell = True )
    command = """mkdir rtmpdump
cd rtmpdump/
tar -xf ../rtmpdump.tar.gz
make linux
mv rtmpdump /usr/bin/
cd ../
rm -Rf rtmpdump/
rm -f rtmpdump.tar.gz"""
    call( command, shell = True )
    print "Finished installation."
    sys.exit()

import urllib, re, xml.dom.minidom

def domGetText( nodeList ):
    nodeList = nodeList.childNodes
    rc = ""
    for node in nodeList:
        if node.nodeType == node.TEXT_NODE:
            rc = rc + node.data
    return rc

class MySpaceTrack:
    def __init__( self, profile, id, name ):
        self.id = int( float( id ) )
        self.title = name

    def getRtmpUrl( self ):
        xmlData = urllib.urlopen( "http://www.myspace.com/Modules/MusicServices/Services/MusicPlayerService.ashx?songId=" + \
            str( self.id ) + "&action=getSong&ptype=4" ).read()

        xmlData = xml.dom.minidom.parseString( xmlData )
        rtmpUrl = domGetText( xmlData.getElementsByTagName('rtmp')[0] ).replace( "rtmp://", "" )
        xmlData.unlink()

        return rtmpUrl

class MySpacePlaylist:
    def __init__( self, profile, id ):
        self._profile = profile
        self.id = int( float( id ) )

    def getTracks( self ):
        xmlData = urllib.urlopen( "http://www.myspace.com/Modules/MusicServices/Services/MusicPlayerService.ashx?artistId=" + \
            self._profile.artistId + "&action=getArtistPlaylist&artistUserId=" + \
            self._profile.friendId + "&playlistId=" + str( self.id ) ).read()

        xmlData = xml.dom.minidom.parseString( xmlData )
        trackElements = xmlData.getElementsByTagName("track")
        tracks = []

        for track in trackElements:
            tracks.append( MySpaceTrack( self._profile, track.getElementsByTagName("song")[0].getAttribute("songId"), \
                domGetText( track.getElementsByTagName("title")[0] ) ) )
            print "Found track", tracks[-1].title, "(" + str( tracks[-1].id ) + ")"

        xmlData.unlink()
        return tracks

class MySpaceProfile:
    def __init__( self, name, profile_link ):
        self.name = name
        self.profile_link = profile_link
        self._html = urllib.urlopen( self.profile_link ).read()

        self.friendId = self._reFriendId.search( self._html )
        if None != self.friendId:
            self.friendId = self.friendId.group(1)

        self.artistId = self._reArtistId.search( self._html )
        if None != self.artistId:
            self.artistId = self.artistId.group(1)

    _reArtistId = re.compile('artid=(\d+)&')
    _reFriendId = re.compile('"DisplayFriendId":(\d+),')

    def isMusicArtist( self ):
        if None != self.artistId:
            return True
        return False

    def getTracks( self ):
        playlists = self.getPlaylists()
        tracks = []

        for playlist in playlists:
            tracks.extend( playlist.getTracks() )

        return tracks

    def getPlaylists( self ):
        xmlData = urllib.urlopen( "http://musicservices.myspace.com/Modules/MusicServices/Services/MusicPlayerService.ashx?friendId=" + \
            self.friendId + "&action=getPlaylists" ).read()

        xmlData = xml.dom.minidom.parseString( xmlData )

        playlists = []
        playlistsElements = xmlData.getElementsByTagName("playlist")

        for playlist in playlistsElements:
            playlists.append( MySpacePlaylist( self, playlist.getAttribute("playlistId") ) )

        xmlData.unlink()
        return playlists

# Store profile information
profiles = []
for profile in sys.argv[1:]:
    profile = MySpaceProfile( profile, "http://www.myspace.com/" + profile )

    # Make sure we are a band page
    if True == profile.isMusicArtist():
        print "Profile", profile.name, "loaded."
        profiles.append( profile )
    else:
        print "Profile", profile.name, "is not a band profile."

print ""
# Get tracks
tracks = []
for profile in profiles:
    print "Loading tracks for", profile.name
    tracks.extend( profile.getTracks() )
    print ""

# Download tracks with rtmpdump
print "Downloading", len( tracks ), "tracks"
for track in tracks:
    print "Downloading", track.title + "..."
    Popen( [ RTMPDUMP_PATH, "-r", "rtmpe://" + track.getRtmpUrl(), "-o", track.title + ".flv" ], stdout = PIPE ).communicate()
    print "\nConverting", track.title + "..."
    Popen( [ MPLAYER_PATH, "-dumpaudio", "-dumpfile", track.title + ".mp3", track.title + ".flv" ], stdout = PIPE ).communicate()
    Popen( [ "rm", "-f", track.title + ".flv" ], stdout = PIPE ).communicate()
    print "Done.\n"

print "\nFinished."