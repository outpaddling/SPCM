#!/bin/sh -e

#SBATCH --exclusive --nodes=1

if [ -e /etc/redhat-release ]; then
    yum update -y
elif [ `uname` = FreeBSD ]; then
    freebsd-update fetch install
else
    printf "Error: Only FreeBSD and RHEL-compatible Linux are supported at this time.\n"
fi

touch update-done
shutdown -r now

