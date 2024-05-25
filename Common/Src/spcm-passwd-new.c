/***************************************************************************
 *  Description:
 *      Securely set the same password on multiple machines in a cluster.
 *      Assumes passwordless ssh login to all target nodes.
 *      Avoid placing raw password in command-line arguments for any cmd.
 *
 *  Arguments:
 *
 *  Returns:
 *
 *  History: 
 *  Date        Name        Modification
 *  2018-12-12  Jason Bacon Begin
 ***************************************************************************/

#include <stdio.h>
#include <sysexits.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <pwd.h>
#include <termios.h>

#define PW_LEN      128

/*
 *  Use absolute pathnames to prevent malicious users from running their
 *  own programs as root.
 */

#define PIPE_PW "/home/bacon/piped-passwd"

int     main(int argc,char *argv[])

{
    uid_t   uid, euid;
    char    *user_name,
	    pw[PW_LEN+1],
	    pw2[PW_LEN+1];
    struct passwd   *pw_ent;
    FILE    *pipe;
    struct termios  term;
    tcflag_t        save_lflag;
    
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

    /* Input password with no echo */
    tcgetattr(fileno(stdout), &term);
    save_lflag = term.c_lflag;
    term.c_lflag &= ~ECHO;
    term.c_lflag |= ECHONL;
    tcsetattr(fileno(stdout), TCSANOW, &term);

    /* FIXME: Don't allow redirecting stdin: Get tty stream. */
    printf("New Password: ");
    fgets(pw, PW_LEN, stdin);
    
    printf("Retype New Password: ");
    fgets(pw2, PW_LEN, stdin);
    
    term.c_lflag = save_lflag;
    tcsetattr(fileno(stdout), TCSANOW, &term);
    
    /* Feed password to piped-passwd via stdin to avoid showing in CLI args */
    pipe = popen(PIPE_PW, "w");
    if ( pipe == NULL )
    {
	fprintf(stderr, "Error opening pipe to %s\n", PIPE_PW);
	return EX_UNAVAILABLE;
    }
    
    fprintf(pipe, "%s\n%s\n", user_name, pw);
    pclose(pipe);
    
    return EX_OK;
}
