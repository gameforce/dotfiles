<?
  /*

  CHImageGuard (PHP version) 1.01
  Copyright 2000-2003 by Christopher Heng. All rights reserved.

  Visit http://www.thesitewizard.com/ for the latest version
  of this script. You can also contact me through the online
  form on the website.


  I. LICENCE TERMS

  1. You may use this script on your website, with or
  without modifications, free of charge.

  2. You may NOT redistribute this script, whether modified
  or not. The script is meant for your personal use on your
  website, and can only be distributed by the author,
  Christopher Heng.

  3. THE SCRIPT AND ITS DOCUMENTATION ARE PROVIDED
  "AS IS", WITHOUT WARRANTY OF ANY KIND, NOT EVEN THE
  IMPLIED WARRANTY OF MECHANTABILITY OR FITNESS FOR A
  PARTICULAR PURPOSE. YOU AGREE TO BEAR ALL RISKS AND
  LIABILITIES ARISING FROM THE USE OF THE SCRIPT,
  ITS DOCUMENTATION AND THE INFORMATION PROVIDED BY THE
  SCRIPTS AND THE DOCUMENTATION.

  If you cannot agree to any of the above conditions, you
  may not use the script. 

  Although it is NOT required, I would be most grateful
  if you could also link to us at:

    http://www.thesitewizard.com/


  II. INSTALLATION AND CONFIGURATION INSTRUCTIONS

  Instructions for installing and configuring the
  script can be found at:

    http://www.thesitewizard.com/

  Look for the article "How to Protect Your Images
  from Bandwidth Thieves".


  III. SUPPORT

  There is none. You got it without paying a cent, remember?

  If you beg very politely, I may answer :-) - but there's no
  guarantee of that. Officially, there's no support. You're
  better off trying to read the article and following its
  instructions. It's much faster.


  IV. CONTACTING THE AUTHOR (BUG REPORTS, LICENSING QUESTIONS)

  Please use the feedback form on the website:

    http://www.thesitewizard.com/feedback.php


  V. WANT MORE SCRIPTS AND OTHER USEFUL WEBMASTER INFORMATION?

  Sign up for thesitewizard newsletter. It's free. To
  subscribe, send an email (blank or otherwise) to:
    subscribe@thesitewizard.com
  Or use the online form at:
    http://www.thesitewizard.com/

  Note that the above email address is attached to a
  mailing list program, which will process your subscription
  request automatically. Do not send any email to me there -
  there are no humans at that email address and your message
  will not reach me. Use the feedback form at the site instead.

  */

  // ---------------- CONFIGURABLE SECTION -----------------

  // Please modify the following or it will not work on
  // your website.

  // Where did you actually put your images?
  // Make sure that the path you put below ends with
  // a directory slash ("/"). The script below assumes it.
  $imagedir = "/home/darf/gameforce/images/web/" ;

  // What are the websites (hostnames) that can use this
  // image?
  // If your site can be accessed with or without the
  // "www" prefix, make sure you put both here. Do not put
  // any trailing slashes ("/") nor any "http://" prefixes.
  // Follow the example below.
  $validprefixes = array (
    "reaver",
    "192.168.0.20",
    "gameforce.ca",
    "www.gameforce.ca"
  ) ;

  // What is the main page of your website? Visitors will
  // be directed here if they type
  //   "http://www.yourdomain.com/chimage.php"
  // in their browser.
  $homepage = "http://www.gameforce.ca/" ;

  // What is your email address?
  // If you want to be informed when someone tries to use
  // this script to access an image illegitimately, you
  // must uncomment (remove the "//" prefix) the following
  // line and change it to point to your email address.
  $email = "darf@gameforce.ca" ;

  // ------------ END OF CONFIGURABLE SECTION ------------


  // --- YOU NEED NOT MODIFY ANYTHING AFTER THIS LINE ---

  function isreferrerokay ( $referrer, $validprefixes )
  {
    $validreferrer = 0 ;
    $authreferrer  = current( $validprefixes );
    while ($authreferrer) {
      if (eregi( "^https?://$authreferrer/", $referrer )) {
        $validreferrer = 1 ;
        break ;
      }
      $authreferrer = next( $validprefixes );
    }
    return $validreferrer ;
  }

  //----------------------- main program -----------------------

  $image = $_GET['image'] ;
  $referrer = getenv( "HTTP_REFERER" );

  if (isset($_GET['image'])) {

    if (empty($referrer) ||
      isreferrerokay( $referrer, $validprefixes )) {

      $imagepath = $imagedir . $image ;

      $imageinfo = getimagesize( $imagepath );
      if ($imageinfo[2] == 1) {
        $imagetype = "gif" ;
      }
      elseif ($imageinfo[2] == 2) {
        $imagetype = "jpeg" ;
      }
      elseif ($imageinfo[2] == 3) {
        $imagetype = "png" ;
      }
      else {
        header( "HTTP/1.0 404 Not Found" );
        exit ;
      }

      header( "Content-type: image/$imagetype" );
      @readfile( $imagepath );

    }
    else {

      if (isset($email)) {
        mail( $email, "Bandwidth Theft Alert",
           "WARNING:\n\n$referrer\ntried to access\n$image\n",
           "From: CHImageGuard <$email>" );
      }
      header( "HTTP/1.0 404 Not Found" );
    }
  }
  else {
    header( "Location: $homepage" );
  }

?>
