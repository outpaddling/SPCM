#!/bin/sh -e

if [ -z $PREFIX ]; then
    PREFIX=/usr/local
fi

case `uname` in
    FreeBSD)
	os='FreeBSD'
	;;

    Linux)
	#
	if [ -e /etc/redhat-release ]; then
	    os='CentOS'
	else
	    printf "Only RHEL-based Linux is supported.\n"
	    exit 1
	fi
	;;

    *)
	printf "Unsupported OS: `uname`\n"
	exit 1
esac

mkdir -p ${DESTDIR}${DATADIR}/profile.d
cp Common/profile.d/* ${DESTDIR}${DATADIR}/profile.d

for dir in bin sbin libexec; do
    mkdir -p ${DESTDIR}${PREFIX}/$dir
done

rm -f ${DESTDIR}${PREFIX}/sbin/cluster-*
rm -f ${DESTDIR}${PREFIX}/bin/cluster-*

cp $os/Sys-scripts/* ${DESTDIR}${PREFIX}/sbin
cp Common/Sys-scripts/* ${DESTDIR}${PREFIX}/sbin
cp Common/User-scripts/* ${DESTDIR}${PREFIX}/bin

chmod 550 ${DESTDIR}${PREFIX}/sbin/*
chmod 555 ${DESTDIR}${PREFIX}/bin/*

cp cluster-passwd ${DESTDIR}${PREFIX}/bin
chmod 6555 ${DESTDIR}${PREFIX}/bin/cluster-passwd

# FIXME: Create and install man pages

mkdir -p ${DESTDIR}${DATADIR}/WWW
cp Common/Share/* ${DESTDIR}${DATADIR}
if [ -e $os/Share ]; then
    cp $os/Share/* ${DESTDIR}${DATADIR}
fi
cp Common/WWW/* $os/WWW/* ${DESTDIR}${DATADIR}/WWW

cp Common/*.awk ${DESTDIR}${PREFIX}/libexec
sed -e "s|add-gecos.awk|${PREFIX}/libexec/add-gecos.awk|g" \
    Common/Sys-scripts/slurm-usage-report \
    > ${DESTDIR}${PREFIX}/sbin/slurm-usage-report

mkdir -p ${PREFIX}/etc/spcm
sed -e "s|cluster-admin.conf|${PREFIX}/etc/spcm/cluster-admin.conf|g" \
    Common/Sys-scripts/cluster-lowest-uid \
    > ${DESTDIR}${PREFIX}/sbin/cluster-lowest-uid
sed -e "s|cluster-admin.conf|${PREFIX}/etc/spcm/cluster-admin.conf|g" \
    Common/Sys-scripts/cluster-highest-uid \
    > ${DESTDIR}${PREFIX}/sbin/cluster-highest-uid

src_prefix=$(dirname $(dirname $(dirname $(dirname $(pwd)))))
printf "src_prefix = $src_prefix\n"
for script in `fgrep -l '%%PREFIX%%' \
	$os/Sys-scripts/* \
	Common/Sys-scripts/* \
	$os/User-scripts/* \
	Common/User-scripts/*`; do
    sed -e "s|prefix=%%PREFIX%%|prefix=${PREFIX}|g" \
	-e "s|prefix=%%SRC_PREFIX%%|prefix=$src_prefix|g" $script \
    > ${DESTDIR}${PREFIX}/sbin/`basename $script`
done
