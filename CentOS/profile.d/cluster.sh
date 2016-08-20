#!/bin/sh

first_two=$(hostname|awk -F '.' ' { printf("%s.%s",$1,$2); }')
PS1="[\u@$first_two \W] \!: "
alias f=finger
alias dir='ls -als'
