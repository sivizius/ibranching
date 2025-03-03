DESTDIR = /
PREFIX = /usr/local

SRC = .
DEST = ./build

IB = ib
CC = gcc
LD = gcc
STRIP = strip

CFLAGS = -Os -Wall
LDFLAGS = -flto

LIBS =

PROGRAM = ib

IB_HEADERS = $(wildcard $(SRC)/*.h.ib)
IB_CFILES  = $(wildcard $(SRC)/*.c.ib)
HEADERS = $(patsubst $(SRC)/%.h.ib, $(DEST)/%.h, $(IB_HEADERS))
OBJS = $(patsubst $(SRC)/%.c.ib, $(DEST)/%.o, $(IB_CFILES))
CFILES = $(patsubst $(SRC)/%.c.ib, $(DEST)/%.c, $(IB_CFILES))

all: $(PROGRAM)

$(DEST)/%.h: $(SRC)/%.h.ib
	@echo " IB      $<"
	@$(IB) $< -o $@

$(DEST)/%.c: $(SRC)/%.c.ib
	@echo " IB      $<"
	@$(IB) $< -o $@

$(DEST)/%.o: $(DEST)/%.c
	@echo " CC      $<"
	@$(CC) $< $(CFLAGS) -I build -c -o $@ 

$(PROGRAM): $(HEADERS) $(CFILES) $(OBJS)
	@echo " LD      $(PROGRAM)"
	@$(LD) $(LDFLAGS) $(LIBS) $(OBJS) -o $(PROGRAM)
	@echo " STRIP   $(PROGRAM)"
	#@$(STRIP) $(PROGRAM)

bootstrap:
	@echo " CC      $<"
	@$(CC) $(DEST)/ib.c $(CFLAGS) $(LDFLAGS) -I build -o $(PROGRAM) 

setup_test:
	$(eval IB = ./ib)

test: setup_test clean $(PROGRAM)
	make -C testing

clean:
	@echo " CLEAN"
	@rm -f $(DEST)/*.h $(DEST)/*.o $(DEST)/*.c

install:
	@echo " INSTALL $(PROGRAM)"
	@mkdir -p $(DESTDIR)/${PREFIX}/bin
	@cp $(PROGRAM) $(DESTDIR)/$(PREFIX)/bin/
