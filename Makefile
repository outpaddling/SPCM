
CC      ?= cc
CFLAGS  ?= -O
RM      ?= rm
BIN     = cluster-passwd

all: ${BIN}

cluster-passwd: Common/Src/cluster-passwd.c
	${CC} ${CFLAGS} -o cluster-passwd ${LDFLAGS} Common/Src/cluster-passwd.c

clean:
	${RM} -f cluster-passwd

realclean:  clean

install:
	./install.sh
