/***************************************************************************
 *  Description:
 *  
 *  Arguments:
 *
 *  Returns:
 *
 *  History: 
 *  Date        Name        Modification
 *  2016-05-19  Jason Bacon Begin
 ***************************************************************************/

#include <stdio.h>
#include <sysexits.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <pwd.h>

#define CMD_LEN     128

/*
 *  Use absolute pathnames to prevent malicious users from running their
 *  own programs as root.
 */

#define SYNC_CMD    "/usr/local/sbin/cluster-sync-pw %s"

int     main(int argc,char *argv[])

{
    uid_t   uid, euid;
    char    *user_name,
	    cmd[CMD_LEN+1];
    struct passwd   *pw_ent;
    int     status = 0;
    
    uid = getuid();
    euid = geteuid();
    if ( uid == 0 )
    {
	if ( argc == 2 )
	{
	    user_name = argv[1];
	}
	else
	{
	    fputs("A user name must be specified when running as root.\n", stderr);
	    return EX_USAGE;
	}
    }
    else
    {
	if ( (pw_ent = getpwuid(uid)) == NULL )
	{
	    fprintf(stderr, "Error: Unable to read password entry for %u.\n", uid);
	    return EX_NOUSER;
	}
	user_name = pw_ent->pw_name;
    }

    if ( uid == 0 )
	snprintf(cmd, CMD_LEN, "passwd %s", user_name);
    else
	snprintf(cmd, CMD_LEN, "passwd");
    
    /* Keep trying until user gets it right */
    while ( system(cmd) != 0 )
	;
    
    setuid(0);
    /*
     *  Make sure everything run from here on is owned by root!
     *  Use absolute pathnames for cluster-sync-pw and restrict PATH
     *  in cluster-sync-pw and all scripts eventually run from it.
     */
    snprintf(cmd, CMD_LEN, SYNC_CMD, user_name);
    system(cmd);
    return EX_OK;
}

