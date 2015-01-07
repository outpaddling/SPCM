$1 != "Total"    {
	user = $1;
	total_cpu_time = $2;
	printf("%-10s %12.4f  ", user, total_cpu_time);
	cmd = "awk -F : -v user=XXX '$1 == user { print $5 }' /etc/passwd";
	gsub("XXX", user, cmd);
	system(cmd);
	#print cmd;
    }

