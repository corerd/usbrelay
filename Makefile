# Makefile for single file module program
# Thanks to http://stackoverflow.com/a/1484873
#
# Replace TARGET with your program name

TARGET = usbrelay
INSTALLDIR = /usr/local/bin

# HIDAPI library: two back-end are available.
#
# Either, uncomment the following line to use libusb
#HIDAPILIB = hidapi-libusb
#
# or, uncomment the following line to use hidraw
HIDAPILIB = hidapi-hidraw

# If you have compiled and installed the HIDAPI library in a given directory,
# it may be required to explicitly pass to the linker the full pathname of
# the shared libraries
HIDAPILIBDIR = /usr/local/lib
LD_RUNTIME_SEARCH_PATH = -Wl,-rpath,$(HIDAPILIBDIR)

CC = gcc
CFLAGS = -O2 -g -Wall
LDFLAGS = -l$(HIDAPILIB) $(LD_RUNTIME_SEARCH_PATH)

.PHONY: clean install all default 

default: $(TARGET)
all: default

HEADERS = $(wildcard *.h)

$(TARGET): $(TARGET).c $(HEADERS)
	$(CC) $(TARGET).c -Wall $(LDFLAGS) -o $@

clean:
	rm -f $(TARGET)

install: $(TARGET)
	install -d $(INSTALLDIR)
	install -m 0755 $(TARGET) $(INSTALLDIR)
