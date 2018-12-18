
# Set prompt to show more than just "login" for a host like
# login.avi.hpc.uwm.edu
set first_two=`hostname|awk -F '.' ' { printf("%s.%s",$1,$2); }'`
set prompt="[%n@$first_two %c] %h: "

# Useful shortcuts
alias f finger
alias dir 'ls -als'
