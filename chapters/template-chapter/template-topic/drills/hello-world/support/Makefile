CFLAGS = -Wall -Wextra
CPPFLAGS = -I utils/ -I utils/log/

EXEC = hello-world
OBJ = $(patsubst %,%.o,$(EXEC))
SRC = $(patsubst %,%.c,$(EXEC))

all: $(EXEC)

$(EXEC): $(OBJ) utils/log/log.o

$(OBJ): $(SRC)

utils/log/log.o: utils/log/log.c

clean::
	-rm -f $(OBJ) utils/log/log.o
	-rm -f $(EXEC)
	-rm -f *~
