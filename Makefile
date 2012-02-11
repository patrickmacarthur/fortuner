# Makefile
# Patrick MacArthur <generalpenguin89@gmail.com>

CFLAGS_libnotify = $(shell pkg-config --cflags libnotify)
CFLAGS = -g -Wall
CFLAGS_ALL = $(CFLAGS_libnotify) $(CFLAGS)

LIBS_libnotify = $(shell pkg-config --libs libnotify)
LDFLAGS = -g
LDFLAGS_ALL = $(LIBS_libnotify) $(LDFLAGS)

.c.o:
	$(CC) -c $(CPPFLAGS) $(CFLAGS_ALL) $<

all: fortuner

fortuner: fortuner.o
	$(CC) $(LDFLAGS_ALL) -o $@ $^

clean:
	$(RM) fortuner fortuner.o
