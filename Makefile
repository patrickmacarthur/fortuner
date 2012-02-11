# Makefile
# Patrick MacArthur <generalpenguin89@gmail.com>

CFLAGS_libnotify = $(shell pkg-config --cflags libnotify)
CFLAGS += -g -Wall $(CFLAGS_libnotify)
LIBS = $(shell pkg-config --libs libnotify)
LDFLAGS = $(LIBS) -g

all: fortuner

fortuner: fortuner.o

clean:
	$(RM) fortuner fortuner.o
