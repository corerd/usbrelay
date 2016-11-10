# Makefile for single file module program
# Thanks to http://stackoverflow.com/a/1484873
#
# Replace TARGET with your program name

TARGET = usbrelay
HIDAPILIB = hidapi-hidraw
INSTALLDIR = /usr/local/bin

CC = gcc
CFLAGS = -O2 -g -Wall
LDFLAGS = -l$(HIDAPILIB)

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
