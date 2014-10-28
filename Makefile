# Makefile
# Patrick MacArthur <contact@patrickmacarthur.net>

# Required by GNU make conventions
SHELL = /bin/sh

# CFLAGS required to find libnotify/glib headers
CFLAGS_libnotify = $(shell pkg-config --cflags libnotify)
#
# default flags that can be overridden
CFLAGS = -g -Wall

# Required libraries for libnotify
LIBS_libnotify = $(shell pkg-config --libs libnotify)

# default linker flags
LDFLAGS = -g

# All CFLAGS/LDFLAGS required for compilation/linking
CFLAGS_ALL = $(CFLAGS_libnotify) $(CFLAGS)
LDLIBS_ALL = $(LIBS_libnotify) $(LDLIBS)

# Default rule: build executables
.PHONY: all
all: fortuner

# Clear suffix list and add only suffixes that we use
SUFFIXES:
SUFFIXES: .c .o

# Implicit rule for compiling C files
.c.o:
	$(CC) -c $(CPPFLAGS) $(CFLAGS_ALL) $<

fortuner: fortuner.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LDLIBS_ALL)

.PHONY: clean
clean:
	$(RM) fortuner fortuner.o
