CFLAGS = -Wall -Wextra
CPPFLAGS = -I utils/ -I utils/log/
LDLIBS = -lpthread

EXEC = race_condition
OBJ = $(patsubst %,%.o,$(EXEC))
SRC = $(patsubst %,%.c,$(EXEC))

all: $(EXEC)

$(EXEC): $(OBJS) utils/log/log.o

$(OBJS): $(SRC)

utils/log/log.o: utils/log/log.c

clean::
	-rm -f $(OBJ) utils/log/log.o
	-rm -f $(EXEC)
	-rm -f *~
