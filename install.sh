#!/bin/sh -e

##########################################################################
#   Script description:
#       Install script to be called from Makefile install target
#       
#   History:
#   Date        Name        Modification
#   2020-12-31  Jason Bacon Begin
##########################################################################

##########################################################################
#   Main
##########################################################################

if [ -z $PREFIX ]; then
    PREFIX=/usr/local
fi

os=$(auto-ostype)
if [ $os = RHEL ]; then
    os=RHEL
fi
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
if [ -e $os/Sys-scripts ]; then
    install -c $os/Sys-scripts/* ${DESTDIR}${PREFIX}/sbin
fi

chmod o-rwx ${DESTDIR}${PREFIX}/sbin/*

install -c cluster-passwd ${DESTDIR}${PREFIX}/bin
chmod 6555 ${DESTDIR}${PREFIX}/bin/cluster-passwd

# FIXME: Create and install man pages

mkdir -p ${DESTDIR}${DATADIR}/WWW
install -c Common/Share/* ${DESTDIR}${DATADIR}
if [ -e $os/Share ]; then
    install -c $os/Share/* ${DESTDIR}${DATADIR}
fi
install -c Common/WWW/* ${DESTDIR}${DATADIR}/WWW
if [ -e $os/WWW ]; then
    install -c $os/WWW/* ${DESTDIR}${DATADIR}/WWW
fi

install -c Common/*.awk ${DESTDIR}${PREFIX}/libexec

# FIXME: Generate lpjs-usage-report script

sed -e "s|cluster-admin.conf|${PREFIX}/etc/spcm/cluster-admin.conf|g" \
    Common/Sys-scripts/cluster-lowest-uid \
    > ${DESTDIR}${PREFIX}/sbin/cluster-lowest-uid
sed -e "s|cluster-admin.conf|${PREFIX}/etc/spcm/cluster-admin.conf|g" \
    Common/Sys-scripts/cluster-highest-uid \
    > ${DESTDIR}${PREFIX}/sbin/cluster-highest-uid
