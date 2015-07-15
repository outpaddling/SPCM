#!/bin/sh -e

case `uname` in
    FreeBSD)
	os='FreeBSD'

	if [ -z $PREFIX ]; then
	    PREFIX=/usr/local/cluster-admin
	fi
	;;
    Linux)
	#
	if [ -e /etc/redhat-release ]; then
	    os='CentOS'
	else
	    printf "Only RHEL-based Linux is supported.\n"
	    exit 1
	fi

	if [ -z $PREFIX ]; then
	    PREFIX=/usr/local
	fi
	DATADIR=$PREFIX/share/cluster-admin
	mkdir -p $DATADIR
	cp CentOS/WWW/* $DATADIR
	;;
    *)
	printf "Unsupported OS: `uname`\n"
	exit 1
esac

set -x
for dir in bin sbin libexec; do
    mkdir -p ${DESTDIR}${PREFIX}/$dir
done
rm -f ${DESTDIR}${PREFIX}/sbin/cluster-*
rm -f ${DESTDIR}${PREFIX}/bin/cluster-*
cp $os/Sys-scripts/* ${DESTDIR}${PREFIX}/sbin
cp $os/User-scripts/* ${DESTDIR}${PREFIX}/bin
cp Common/Sys-scripts/* ${DESTDIR}${PREFIX}/sbin
cp Common/User-scripts/* ${DESTDIR}${PREFIX}/bin
chmod 750 ${DESTDIR}${PREFIX}/sbin/*
chmod 755 ${DESTDIR}${PREFIX}/bin/*

cp Common/*.awk ${DESTDIR}${PREFIX}/libexec

# FIXME: Create and install man pages

mkdir -p ${DESTDIR}${DATADIR}/WWW
cp Common/Share/* ${DESTDIR}${DATADIR}/WWW
cp $os/Share/* ${DESTDIR}${DATADIR}/WWW
cp $os/WWW/* ${DESTDIR}${DATADIR}/WWW

sed -e "s|add-gecos.awk|${PREFIX}/libexec/add-gecos.awk|g" \
    Common/Sys-scripts/slurm-usage-report \
    > ${DESTDIR}${PREFIX}/sbin/slurm-usage-report
sed -e "s|%%DATADIR%%|${DATADIR}|g" \
    Common/Sys-scripts/slurm-update-idle-nodes \
    > ${DESTDIR}${PREFIX}/sbin/slurm-upate-idle-nodes
sed -e "s|cluster-admin.conf|${PREFIX}/etc/cluster-admin.conf|g" \
    Common/Sys-scripts/cluster-lowest-uid \
    > ${DESTDIR}${PREFIX}/sbin/cluster-lowest-uid

