
CC      ?= cc
CFLAGS  ?= -O
RM      ?= rm
BIN     = cluster-passwd
SED     ?= sed
PREFIX  ?= /usr/local

all: ${BIN}

cluster-passwd: Common/Src/cluster-passwd.c
	${SED} -e "s|%%PREFIX%%|$$PREFIX|g" Common/Src/cluster-passwd.c > cluster-passwd.c
	${CC} ${CFLAGS} -o cluster-passwd ${LDFLAGS} cluster-passwd.c

clean:
	${RM} -f cluster-passwd

realclean:  clean

install:
	./install.sh
