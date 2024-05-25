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
rm -f ${DESTDIR}${PREFIX}/sbin/spcm-*
rm -f ${DESTDIR}${PREFIX}/bin/spcm-*

install -c Common/Sys-scripts/* ${DESTDIR}${PREFIX}/sbin
install -c Common/User-scripts/* ${DESTDIR}${PREFIX}/bin

# Overwrite Common scripts from above with OS-specific scripts if both exist.
# Most scripts should be in Common, but a few such as spcm-setup are so
# OS-specific that it doesn't make sense to unify them.
if [ -e $os/Sys-scripts ]; then
    install -c $os/Sys-scripts/* ${DESTDIR}${PREFIX}/sbin
fi

chmod o-rwx ${DESTDIR}${PREFIX}/sbin/*

install -c spcm-passwd ${DESTDIR}${PREFIX}/bin
chmod 6555 ${DESTDIR}${PREFIX}/bin/spcm-passwd

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

sed -e "s|spcm-admin.conf|${PREFIX}/etc/spcm/spcm-admin.conf|g" \
    Common/Sys-scripts/spcm-lowest-uid \
    > ${DESTDIR}${PREFIX}/sbin/spcm-lowest-uid
sed -e "s|spcm-admin.conf|${PREFIX}/etc/spcm/spcm-admin.conf|g" \
    Common/Sys-scripts/spcm-highest-uid \
    > ${DESTDIR}${PREFIX}/sbin/spcm-highest-uid
