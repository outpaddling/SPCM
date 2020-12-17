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

umask 022

mkdir -p ${DESTDIR}${DATADIR}/profile.d
install -c Common/profile.d/* ${DESTDIR}${DATADIR}/profile.d

for dir in bin sbin libexec; do
    mkdir -p ${DESTDIR}${PREFIX}/$dir
done

# FIXME: What's this for?  Does it predate the use of DESTDIR?
rm -f ${DESTDIR}${PREFIX}/sbin/cluster-*
rm -f ${DESTDIR}${PREFIX}/bin/cluster-*

install -c Common/Sys-scripts/* ${DESTDIR}${PREFIX}/sbin
install -c Common/User-scripts/* ${DESTDIR}${PREFIX}/bin

# Overwrite Common scripts from above with OS-specific scripts if both exist.
# Most scripts should be in Common, but a few such as cluster-setup are so
# OS-specific that it doesn't make sense to unify them.
install -c $os/Sys-scripts/* ${DESTDIR}${PREFIX}/sbin

chmod o-rwx ${DESTDIR}${PREFIX}/sbin/*

install -c cluster-passwd ${DESTDIR}${PREFIX}/bin
chmod 6555 ${DESTDIR}${PREFIX}/bin/cluster-passwd

# FIXME: Create and install man pages

mkdir -p ${DESTDIR}${DATADIR}/WWW
install -c Common/Share/* ${DESTDIR}${DATADIR}
if [ -e $os/Share ]; then
    install -c $os/Share/* ${DESTDIR}${DATADIR}
fi
install -c Common/WWW/* $os/WWW/* ${DESTDIR}${DATADIR}/WWW

install -c Common/*.awk ${DESTDIR}${PREFIX}/libexec
sed -e "s|add-gecos.awk|${PREFIX}/libexec/add-gecos.awk|g" \
    Common/Sys-scripts/slurm-usage-report \
    > ${DESTDIR}${PREFIX}/sbin/slurm-usage-report

sed -e "s|cluster-admin.conf|${PREFIX}/etc/spcm/cluster-admin.conf|g" \
    Common/Sys-scripts/cluster-lowest-uid \
    > ${DESTDIR}${PREFIX}/sbin/cluster-lowest-uid
sed -e "s|cluster-admin.conf|${PREFIX}/etc/spcm/cluster-admin.conf|g" \
    Common/Sys-scripts/cluster-highest-uid \
    > ${DESTDIR}${PREFIX}/sbin/cluster-highest-uid

src_prefix=$(dirname $(dirname $(dirname $(dirname $(pwd)))))
printf "src_prefix = $src_prefix\n"
for script in `fgrep -l 'prefix=%%PREFIX%%' \
	$os/Sys-scripts/* \
	Common/Sys-scripts/*`; do
    sed -e "s|prefix=%%PREFIX%%|prefix=${PREFIX}|g" \
	-e "s|prefix=%%SRC_PREFIX%%|prefix=$src_prefix|g" $script \
    > ${DESTDIR}${PREFIX}/sbin/`basename $script`
done
for script in `fgrep -l 'prefix=%%PREFIX%%' \
	$os/User-scripts/* \
	Common/User-scripts/*`; do
    sed -e "s|prefix=%%PREFIX%%|prefix=${PREFIX}|g" \
	-e "s|prefix=%%SRC_PREFIX%%|prefix=$src_prefix|g" $script \
    > ${DESTDIR}${PREFIX}/bin/`basename $script`
done
