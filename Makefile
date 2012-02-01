# Makefile
# Patrick MacArthur <generalpenguin89@gmail.com>

CFLAGS = -pthread -I/usr/include/gdk-pixbuf-2.0 -I/usr/include/glib-2.0 -I/usr/lib64/glib-2.0/include -I/usr/include/libpng12 -Wall -Wextra -g
LIBS = -pthread -lnotify -lgdk_pixbuf-2.0 -lgio-2.0 -lgobject-2.0 -lgmodule-2.0 -lgthread-2.0 -lrt -lglib-2.0
LDFLAGS = $(LIBS) -g

all: fortuner

fortuner: fortuner.o

clean:
	$(RM) fortuner fortuner.o
