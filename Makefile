
CC      ?= cc
CFLAGS  ?= -O
RM      ?= rm
BIN     = spcm-passwd
SED     ?= sed
PREFIX  ?= /usr/local
DESTDIR ?= .

all: ${BIN}

spcm-passwd: Common/Src/spcm-passwd.c
	${SED} -e "s|%%PREFIX%%|$$PREFIX|g" Common/Src/spcm-passwd.c > spcm-passwd.c
	${CC} ${CFLAGS} -o spcm-passwd ${LDFLAGS} spcm-passwd.c

clean:
	${RM} -f spcm-passwd

realclean:  clean

install:
	./install.sh
