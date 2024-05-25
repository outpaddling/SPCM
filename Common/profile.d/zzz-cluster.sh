#!/bin/sh -e

##########################################################################
#   Copy this to /etc/profile.d and modify to taste or source it (or
#   a modified copy) from /etc/profile or /etc/bashrc and similar scripts.
##########################################################################

LOCALBASE=$(spcm-localbase)

# Set prompt to show more than just "login" for a host like
# login.avi.hpc.uwm.edu
first_two=`hostname | awk -F '.' ' { printf("%s.%s",$1,$2); }'`
PS1="[\u@$first_two \W] \!: "

umask 027

# Useful shortcuts
alias f=finger
alias dir='ls -als'

if shopt -q login_shell && [ `hostname -s` = login ] && \
    [ -e $LOCALBASE/etc/spcm/check-local-password-age ]; then
    spcm-pw-check
fi
