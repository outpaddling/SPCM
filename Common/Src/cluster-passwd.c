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
#include <time.h>
#include <limits.h>

#define CMD_LEN     128

/*
 *  Use absolute pathnames to prevent malicious users from running their
 *  own programs as root.
 */

#define SYNC_CMD    "/usr/local/sbin/cluster-sync-pw %s"

int     main(int argc,char *argv[])

{
    uid_t   uid, euid;
    unsigned int    max_pw_age, last_pw_change;
    char    *user_name,
	    cmd[CMD_LEN+1],
	    pw_age_file[PATH_MAX+1];
    FILE    *fp;
    struct passwd   *pw_ent;
    time_t  now;
    
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
	sleep(2);
    
    setuid(0);
    /*
     *  Make sure everything run from here on is owned by root!
     *  Use absolute pathnames for cluster-sync-pw and restrict PATH
     *  in cluster-sync-pw and all scripts eventually run from it.
     */
    snprintf(cmd, CMD_LEN, SYNC_CMD, user_name);
    system(cmd);
    
    /*
     *  Record password change time
     */
    now = time(NULL) / 3600 / 24;
    snprintf(pw_age_file, PATH_MAX, "/usr/local/cluster/pw-age/%s", user_name);
    fp = fopen(pw_age_file, "r+");
    if ( fp == NULL )
    {
	fprintf(stderr, "%s: Cannot open %s.\n", argv[0], pw_age_file);
	return EX_UNAVAILABLE;
    }
    if ( fscanf(fp, "%u %u", &max_pw_age, &last_pw_change) != 2 )
    {
	fprintf(stderr, "%s: Error reading %s.\n", argv[0], pw_age_file);
	fclose(fp);
	return EX_DATAERR;
    }
    // printf("%u %u %lu\n", max_pw_age, last_pw_change, now);
    rewind(fp);
    if ( fprintf(fp, "%u %lu\n", max_pw_age, now) < 0 )
    {
	fprintf(stderr, "%s: Error writing %s.\n", argv[0], pw_age_file);
	fclose(fp);
	return EX_DATAERR;
    }
    fclose(fp);
    return EX_OK;
}
