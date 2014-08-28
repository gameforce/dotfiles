#include <stdio.h>
#include <stdlib.h>
#include <ldap.h>

#define AUTH_METHOD LDAP_AUTH_SIMPLE
int requested_version = LDAP_VERSION3;

int authCheck( char *host, char *port, char* bind_dn, char* bind_pw, char* base);
int main(int argc, char **argv);

main(int argc, char **argv)
{
char oldPassword[128];

    if( argc != 5 )
    {
        printf( "Wrong number of arguments!\n" );
        printf( "Usage:   p4authenticate [IP]     [Port] [Domain]                    [user]\n");
        printf( "Example: p4authenticate  1.2.3.4  389    DC=test,DC=perforce,DC=com  bob  \n");
        exit( -1 );
    }

    if(strlen(argv[4]) == 0)
    {
      printf("Error:  NULL user names are not allowed.\n");
      exit (-1);
    }

    /* read the password from <stdin> and truncate the newline */

    if( fgets( oldPassword, 128, stdin ) == NULL )
    {
        printf( "Didn't receive old password!\n" );
        exit( -1 );
    }

    oldPassword[ strlen(oldPassword) - 1 ] = '\0';


    return( authCheck( argv[1], argv[2], argv[4], oldPassword, argv[3]) );
}

int 
authCheck( char *host, char *port, char* bind_dn, char* bind_pw, char* base)
{
LDAP *ld;
int rc;
int portnumber = atoi( port );

    /* Get a handle to an LDAP connection. */

    if( ( ld = ldap_init( host, portnumber ) ) == NULL ) 
    {
        printf( "Can't initialize connection to %s : %d\n" , host, portnumber );
        return( -1 );
    }

    ldap_set_option( ld, LDAP_OPT_PROTOCOL_VERSION, &requested_version );

    /* bind */

    rc = ldap_bind_s( ld, bind_dn, bind_pw, AUTH_METHOD );

    /* check result, report errors */

    if ( rc != LDAP_SUCCESS ) 
    { 

           if (strcasecmp("Invalid credentials", ldap_err2string(rc)) == 0)
           {    printf( "Error:  Password incorrect (%s).\n", ldap_err2string(rc) ); }
           else
           {   printf("Error:  %s.\n",ldap_err2string(rc)); }

        return( -1 );
    }

   LDAPMessage *results, *entry;
   char  search[1024];
   search[0] = '\0';
   struct timeval timeout = {10, 0};

   strcat(search, "(logonName=");
   strcat(search, bind_dn);
   strcat(search, ")\0");

   rc = ldap_search_ext_s (ld, 
                           base, 
                           LDAP_SCOPE_SUBTREE,
                           search,
                           NULL,
                           0,
                           NULL,
                           NULL,
                          &timeout,
                           LDAP_NO_LIMIT,
                          &results
                          ); 

   if(rc != LDAP_SUCCESS)
   {
     printf( "Error:       Invalid password or no password entered.  You must enter a password.\n");
     printf( "Error code: (%s).\n", ldap_err2string(rc) );
     return -1;
   }

   printf("Success:  Password verified.\n");

    ldap_unbind( ld );
    return( 0 );
}

