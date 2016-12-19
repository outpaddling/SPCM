
CC	?= cc
CFLAGS	?= -O
RM	?= rm

all:
	${CC} ${CFLAGS} -o cluster-passwd Common/Src/cluster-passwd.c

clean:
	${RM} -f cluster-passwd

realclean:  clean

install:
	./install.sh
