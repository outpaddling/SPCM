
##########################################################################
#   Copy this to /etc/profile.d and modify to taste or source it (or
#   a modified copy) from /etc/csh.login or /etc/csh.cshrc.
##########################################################################

# Set prompt to show more than just "login" for a host like
# login.avi.hpc.uwm.edu
set first_two=`hostname|awk -F '.' ' { printf("%s.%s",$1,$2); }'`
set prompt="[%n@$first_two %c] %h: "

# Useful shortcuts
alias f finger
alias dir 'ls -als'

if ( $?prompt2 ) then
    cluster-pw-check
endif
