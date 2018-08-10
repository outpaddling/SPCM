set first_two=`hostname|awk -F '.' ' { printf("%s.%s",$1,$2); }'`
set prompt="[%n@$first_two %c] %h: "
alias f finger
alias dir 'ls -als'
