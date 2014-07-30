#
#   goahead-macosx-static.mk -- Makefile to build Embedthis GoAhead for macosx
#

NAME                  := goahead
VERSION               := 3.3.5
PROFILE               ?= static
ARCH                  ?= $(shell uname -m | sed 's/i.86/x86/;s/x86_64/x64/;s/arm.*/arm/;s/mips.*/mips/')
CC_ARCH               ?= $(shell echo $(ARCH) | sed 's/x86/i686/;s/x64/x86_64/')
OS                    ?= macosx
CC                    ?= clang
CONFIG                ?= $(OS)-$(ARCH)-$(PROFILE)
BUILD                 ?= build/$(CONFIG)
LBIN                  ?= $(BUILD)/bin
PATH                  := $(LBIN):$(PATH)

ME_COM_EST            ?= 1
ME_COM_MATRIXSSL      ?= 0
ME_COM_NANOSSL        ?= 0
ME_COM_OPENSSL        ?= 0
ME_COM_SSL            ?= 1
ME_COM_VXWORKS        ?= 0
ME_COM_WINSDK         ?= 1

ifeq ($(ME_COM_EST),1)
    ME_COM_SSL := 1
endif
ifeq ($(ME_COM_MATRIXSSL),1)
    ME_COM_SSL := 1
endif
ifeq ($(ME_COM_NANOSSL),1)
    ME_COM_SSL := 1
endif
ifeq ($(ME_COM_OPENSSL),1)
    ME_COM_SSL := 1
endif

ME_COM_COMPILER_PATH  ?= clang
ME_COM_LIB_PATH       ?= ar
ME_COM_MATRIXSSL_PATH ?= /usr/src/matrixssl
ME_COM_NANOSSL_PATH   ?= /usr/src/nanossl
ME_COM_OPENSSL_PATH   ?= /usr/src/openssl

CFLAGS                += -g -w
DFLAGS                +=  $(patsubst %,-D%,$(filter ME_%,$(MAKEFLAGS))) -DME_COM_EST=$(ME_COM_EST) -DME_COM_MATRIXSSL=$(ME_COM_MATRIXSSL) -DME_COM_NANOSSL=$(ME_COM_NANOSSL) -DME_COM_OPENSSL=$(ME_COM_OPENSSL) -DME_COM_SSL=$(ME_COM_SSL) -DME_COM_VXWORKS=$(ME_COM_VXWORKS) -DME_COM_WINSDK=$(ME_COM_WINSDK) 
IFLAGS                += "-Ibuild/$(CONFIG)/inc"
LDFLAGS               += '-Wl,-rpath,@executable_path/' '-Wl,-rpath,@loader_path/'
LIBPATHS              += -Lbuild/$(CONFIG)/bin
LIBS                  += -ldl -lpthread -lm

DEBUG                 ?= debug
CFLAGS-debug          ?= -g
DFLAGS-debug          ?= -DME_DEBUG
LDFLAGS-debug         ?= -g
DFLAGS-release        ?= 
CFLAGS-release        ?= -O2
LDFLAGS-release       ?= 
CFLAGS                += $(CFLAGS-$(DEBUG))
DFLAGS                += $(DFLAGS-$(DEBUG))
LDFLAGS               += $(LDFLAGS-$(DEBUG))

ME_ROOT_PREFIX        ?= 
ME_BASE_PREFIX        ?= $(ME_ROOT_PREFIX)/usr/local
ME_DATA_PREFIX        ?= $(ME_ROOT_PREFIX)/
ME_STATE_PREFIX       ?= $(ME_ROOT_PREFIX)/var
ME_APP_PREFIX         ?= $(ME_BASE_PREFIX)/lib/$(NAME)
ME_VAPP_PREFIX        ?= $(ME_APP_PREFIX)/$(VERSION)
ME_BIN_PREFIX         ?= $(ME_ROOT_PREFIX)/usr/local/bin
ME_INC_PREFIX         ?= $(ME_ROOT_PREFIX)/usr/local/include
ME_LIB_PREFIX         ?= $(ME_ROOT_PREFIX)/usr/local/lib
ME_MAN_PREFIX         ?= $(ME_ROOT_PREFIX)/usr/local/share/man
ME_SBIN_PREFIX        ?= $(ME_ROOT_PREFIX)/usr/local/sbin
ME_ETC_PREFIX         ?= $(ME_ROOT_PREFIX)/etc/$(NAME)
ME_WEB_PREFIX         ?= $(ME_ROOT_PREFIX)/var/www/$(NAME)-default
ME_LOG_PREFIX         ?= $(ME_ROOT_PREFIX)/var/log/$(NAME)
ME_SPOOL_PREFIX       ?= $(ME_ROOT_PREFIX)/var/spool/$(NAME)
ME_CACHE_PREFIX       ?= $(ME_ROOT_PREFIX)/var/spool/$(NAME)/cache
ME_SRC_PREFIX         ?= $(ME_ROOT_PREFIX)$(NAME)-$(VERSION)


TARGETS               += build/$(CONFIG)/bin/ca.crt
TARGETS               += build/$(CONFIG)/bin/goahead
TARGETS               += build/$(CONFIG)/bin/goahead-test
TARGETS               += build/$(CONFIG)/bin/gopass

unexport CDPATH

ifndef SHOW
.SILENT:
endif

all build compile: prep $(TARGETS)

.PHONY: prep

prep:
	@echo "      [Info] Use "make SHOW=1" to trace executed commands."
	@if [ "$(CONFIG)" = "" ] ; then echo WARNING: CONFIG not set ; exit 255 ; fi
	@if [ "$(ME_APP_PREFIX)" = "" ] ; then echo WARNING: ME_APP_PREFIX not set ; exit 255 ; fi
	@[ ! -x $(BUILD)/bin ] && mkdir -p $(BUILD)/bin; true
	@[ ! -x $(BUILD)/inc ] && mkdir -p $(BUILD)/inc; true
	@[ ! -x $(BUILD)/obj ] && mkdir -p $(BUILD)/obj; true
	@[ ! -f $(BUILD)/inc/me.h ] && cp projects/goahead-macosx-static-me.h $(BUILD)/inc/me.h ; true
	@if ! diff $(BUILD)/inc/me.h projects/goahead-macosx-static-me.h >/dev/null ; then\
		cp projects/goahead-macosx-static-me.h $(BUILD)/inc/me.h  ; \
	fi; true
	@if [ -f "$(BUILD)/.makeflags" ] ; then \
		if [ "$(MAKEFLAGS)" != "`cat $(BUILD)/.makeflags`" ] ; then \
			echo "   [Warning] Make flags have changed since the last build: "`cat $(BUILD)/.makeflags`"" ; \
		fi ; \
	fi
	@echo $(MAKEFLAGS) >$(BUILD)/.makeflags

clean:
	rm -f "build/$(CONFIG)/obj/action.o"
	rm -f "build/$(CONFIG)/obj/alloc.o"
	rm -f "build/$(CONFIG)/obj/auth.o"
	rm -f "build/$(CONFIG)/obj/cgi.o"
	rm -f "build/$(CONFIG)/obj/crypt.o"
	rm -f "build/$(CONFIG)/obj/est.o"
	rm -f "build/$(CONFIG)/obj/estLib.o"
	rm -f "build/$(CONFIG)/obj/file.o"
	rm -f "build/$(CONFIG)/obj/fs.o"
	rm -f "build/$(CONFIG)/obj/goahead.o"
	rm -f "build/$(CONFIG)/obj/gopass.o"
	rm -f "build/$(CONFIG)/obj/http.o"
	rm -f "build/$(CONFIG)/obj/js.o"
	rm -f "build/$(CONFIG)/obj/jst.o"
	rm -f "build/$(CONFIG)/obj/matrixssl.o"
	rm -f "build/$(CONFIG)/obj/nanossl.o"
	rm -f "build/$(CONFIG)/obj/openssl.o"
	rm -f "build/$(CONFIG)/obj/options.o"
	rm -f "build/$(CONFIG)/obj/osdep.o"
	rm -f "build/$(CONFIG)/obj/rom-documents.o"
	rm -f "build/$(CONFIG)/obj/route.o"
	rm -f "build/$(CONFIG)/obj/runtime.o"
	rm -f "build/$(CONFIG)/obj/socket.o"
	rm -f "build/$(CONFIG)/obj/test.o"
	rm -f "build/$(CONFIG)/obj/upload.o"
	rm -f "build/$(CONFIG)/bin/ca.crt"
	rm -f "build/$(CONFIG)/bin/goahead"
	rm -f "build/$(CONFIG)/bin/goahead-test"
	rm -f "build/$(CONFIG)/bin/gopass"
	rm -f "build/$(CONFIG)/bin/libest.a"
	rm -f "build/$(CONFIG)/bin/libgo.a"

clobber: clean
	rm -fr ./$(BUILD)


#
#   ca-crt
#
DEPS_1 += src/paks/est/ca.crt

build/$(CONFIG)/bin/ca.crt: $(DEPS_1)
	@echo '      [Copy] build/$(CONFIG)/bin/ca.crt'
	mkdir -p "build/$(CONFIG)/bin"
	cp src/paks/est/ca.crt build/$(CONFIG)/bin/ca.crt


#
#   est.h
#
build/$(CONFIG)/inc/est.h: $(DEPS_2)
	@echo '      [Copy] build/$(CONFIG)/inc/est.h'
	mkdir -p "build/$(CONFIG)/inc"
	cp src/paks/est/est.h build/$(CONFIG)/inc/est.h

#
#   me.h
#
build/$(CONFIG)/inc/me.h: $(DEPS_3)
	@echo '      [Copy] build/$(CONFIG)/inc/me.h'

#
#   osdep.h
#
DEPS_4 += build/$(CONFIG)/inc/me.h

build/$(CONFIG)/inc/osdep.h: $(DEPS_4)
	@echo '      [Copy] build/$(CONFIG)/inc/osdep.h'
	mkdir -p "build/$(CONFIG)/inc"
	cp src/paks/osdep/osdep.h build/$(CONFIG)/inc/osdep.h

#
#   estLib.o
#
DEPS_5 += build/$(CONFIG)/inc/me.h
DEPS_5 += build/$(CONFIG)/inc/est.h
DEPS_5 += build/$(CONFIG)/inc/osdep.h

build/$(CONFIG)/obj/estLib.o: \
    src/paks/est/estLib.c $(DEPS_5)
	@echo '   [Compile] build/$(CONFIG)/obj/estLib.o'
	$(CC) -c $(DFLAGS) -o build/$(CONFIG)/obj/estLib.o -arch $(CC_ARCH) $(CFLAGS) $(IFLAGS) src/paks/est/estLib.c

ifeq ($(ME_COM_EST),1)
#
#   libest
#
DEPS_6 += build/$(CONFIG)/inc/est.h
DEPS_6 += build/$(CONFIG)/inc/me.h
DEPS_6 += build/$(CONFIG)/inc/osdep.h
DEPS_6 += build/$(CONFIG)/obj/estLib.o

build/$(CONFIG)/bin/libest.a: $(DEPS_6)
	@echo '      [Link] build/$(CONFIG)/bin/libest.a'
	ar -cr build/$(CONFIG)/bin/libest.a "build/$(CONFIG)/obj/estLib.o"
endif

#
#   goahead.h
#
build/$(CONFIG)/inc/goahead.h: $(DEPS_7)
	@echo '      [Copy] build/$(CONFIG)/inc/goahead.h'
	mkdir -p "build/$(CONFIG)/inc"
	cp src/goahead.h build/$(CONFIG)/inc/goahead.h

#
#   js.h
#
build/$(CONFIG)/inc/js.h: $(DEPS_8)
	@echo '      [Copy] build/$(CONFIG)/inc/js.h'
	mkdir -p "build/$(CONFIG)/inc"
	cp src/js.h build/$(CONFIG)/inc/js.h

#
#   action.o
#
DEPS_9 += build/$(CONFIG)/inc/me.h
DEPS_9 += build/$(CONFIG)/inc/goahead.h
DEPS_9 += build/$(CONFIG)/inc/osdep.h

build/$(CONFIG)/obj/action.o: \
    src/action.c $(DEPS_9)
	@echo '   [Compile] build/$(CONFIG)/obj/action.o'
	$(CC) -c $(DFLAGS) -o build/$(CONFIG)/obj/action.o -arch $(CC_ARCH) $(CFLAGS) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" "-I$(ME_COM_MATRIXSSL_PATH)" "-I$(ME_COM_MATRIXSSL_PATH)/matrixssl" "-I$(ME_COM_NANOSSL_PATH)/src" src/action.c

#
#   alloc.o
#
DEPS_10 += build/$(CONFIG)/inc/me.h
DEPS_10 += build/$(CONFIG)/inc/goahead.h

build/$(CONFIG)/obj/alloc.o: \
    src/alloc.c $(DEPS_10)
	@echo '   [Compile] build/$(CONFIG)/obj/alloc.o'
	$(CC) -c $(DFLAGS) -o build/$(CONFIG)/obj/alloc.o -arch $(CC_ARCH) $(CFLAGS) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" "-I$(ME_COM_MATRIXSSL_PATH)" "-I$(ME_COM_MATRIXSSL_PATH)/matrixssl" "-I$(ME_COM_NANOSSL_PATH)/src" src/alloc.c

#
#   auth.o
#
DEPS_11 += build/$(CONFIG)/inc/me.h
DEPS_11 += build/$(CONFIG)/inc/goahead.h

build/$(CONFIG)/obj/auth.o: \
    src/auth.c $(DEPS_11)
	@echo '   [Compile] build/$(CONFIG)/obj/auth.o'
	$(CC) -c $(DFLAGS) -o build/$(CONFIG)/obj/auth.o -arch $(CC_ARCH) $(CFLAGS) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" "-I$(ME_COM_MATRIXSSL_PATH)" "-I$(ME_COM_MATRIXSSL_PATH)/matrixssl" "-I$(ME_COM_NANOSSL_PATH)/src" src/auth.c

#
#   cgi.o
#
DEPS_12 += build/$(CONFIG)/inc/me.h
DEPS_12 += build/$(CONFIG)/inc/goahead.h

build/$(CONFIG)/obj/cgi.o: \
    src/cgi.c $(DEPS_12)
	@echo '   [Compile] build/$(CONFIG)/obj/cgi.o'
	$(CC) -c $(DFLAGS) -o build/$(CONFIG)/obj/cgi.o -arch $(CC_ARCH) $(CFLAGS) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" "-I$(ME_COM_MATRIXSSL_PATH)" "-I$(ME_COM_MATRIXSSL_PATH)/matrixssl" "-I$(ME_COM_NANOSSL_PATH)/src" src/cgi.c

#
#   crypt.o
#
DEPS_13 += build/$(CONFIG)/inc/me.h
DEPS_13 += build/$(CONFIG)/inc/goahead.h

build/$(CONFIG)/obj/crypt.o: \
    src/crypt.c $(DEPS_13)
	@echo '   [Compile] build/$(CONFIG)/obj/crypt.o'
	$(CC) -c $(DFLAGS) -o build/$(CONFIG)/obj/crypt.o -arch $(CC_ARCH) $(CFLAGS) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" "-I$(ME_COM_MATRIXSSL_PATH)" "-I$(ME_COM_MATRIXSSL_PATH)/matrixssl" "-I$(ME_COM_NANOSSL_PATH)/src" src/crypt.c

#
#   file.o
#
DEPS_14 += build/$(CONFIG)/inc/me.h
DEPS_14 += build/$(CONFIG)/inc/goahead.h

build/$(CONFIG)/obj/file.o: \
    src/file.c $(DEPS_14)
	@echo '   [Compile] build/$(CONFIG)/obj/file.o'
	$(CC) -c $(DFLAGS) -o build/$(CONFIG)/obj/file.o -arch $(CC_ARCH) $(CFLAGS) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" "-I$(ME_COM_MATRIXSSL_PATH)" "-I$(ME_COM_MATRIXSSL_PATH)/matrixssl" "-I$(ME_COM_NANOSSL_PATH)/src" src/file.c

#
#   fs.o
#
DEPS_15 += build/$(CONFIG)/inc/me.h
DEPS_15 += build/$(CONFIG)/inc/goahead.h

build/$(CONFIG)/obj/fs.o: \
    src/fs.c $(DEPS_15)
	@echo '   [Compile] build/$(CONFIG)/obj/fs.o'
	$(CC) -c $(DFLAGS) -o build/$(CONFIG)/obj/fs.o -arch $(CC_ARCH) $(CFLAGS) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" "-I$(ME_COM_MATRIXSSL_PATH)" "-I$(ME_COM_MATRIXSSL_PATH)/matrixssl" "-I$(ME_COM_NANOSSL_PATH)/src" src/fs.c

#
#   http.o
#
DEPS_16 += build/$(CONFIG)/inc/me.h
DEPS_16 += build/$(CONFIG)/inc/goahead.h

build/$(CONFIG)/obj/http.o: \
    src/http.c $(DEPS_16)
	@echo '   [Compile] build/$(CONFIG)/obj/http.o'
	$(CC) -c $(DFLAGS) -o build/$(CONFIG)/obj/http.o -arch $(CC_ARCH) $(CFLAGS) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" "-I$(ME_COM_MATRIXSSL_PATH)" "-I$(ME_COM_MATRIXSSL_PATH)/matrixssl" "-I$(ME_COM_NANOSSL_PATH)/src" src/http.c

#
#   js.o
#
DEPS_17 += build/$(CONFIG)/inc/me.h
DEPS_17 += build/$(CONFIG)/inc/js.h
DEPS_17 += build/$(CONFIG)/inc/goahead.h

build/$(CONFIG)/obj/js.o: \
    src/js.c $(DEPS_17)
	@echo '   [Compile] build/$(CONFIG)/obj/js.o'
	$(CC) -c $(DFLAGS) -o build/$(CONFIG)/obj/js.o -arch $(CC_ARCH) $(CFLAGS) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" "-I$(ME_COM_MATRIXSSL_PATH)" "-I$(ME_COM_MATRIXSSL_PATH)/matrixssl" "-I$(ME_COM_NANOSSL_PATH)/src" src/js.c

#
#   jst.o
#
DEPS_18 += build/$(CONFIG)/inc/me.h
DEPS_18 += build/$(CONFIG)/inc/goahead.h
DEPS_18 += build/$(CONFIG)/inc/js.h

build/$(CONFIG)/obj/jst.o: \
    src/jst.c $(DEPS_18)
	@echo '   [Compile] build/$(CONFIG)/obj/jst.o'
	$(CC) -c $(DFLAGS) -o build/$(CONFIG)/obj/jst.o -arch $(CC_ARCH) $(CFLAGS) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" "-I$(ME_COM_MATRIXSSL_PATH)" "-I$(ME_COM_MATRIXSSL_PATH)/matrixssl" "-I$(ME_COM_NANOSSL_PATH)/src" src/jst.c

#
#   options.o
#
DEPS_19 += build/$(CONFIG)/inc/me.h
DEPS_19 += build/$(CONFIG)/inc/goahead.h

build/$(CONFIG)/obj/options.o: \
    src/options.c $(DEPS_19)
	@echo '   [Compile] build/$(CONFIG)/obj/options.o'
	$(CC) -c $(DFLAGS) -o build/$(CONFIG)/obj/options.o -arch $(CC_ARCH) $(CFLAGS) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" "-I$(ME_COM_MATRIXSSL_PATH)" "-I$(ME_COM_MATRIXSSL_PATH)/matrixssl" "-I$(ME_COM_NANOSSL_PATH)/src" src/options.c

#
#   osdep.o
#
DEPS_20 += build/$(CONFIG)/inc/me.h
DEPS_20 += build/$(CONFIG)/inc/goahead.h

build/$(CONFIG)/obj/osdep.o: \
    src/osdep.c $(DEPS_20)
	@echo '   [Compile] build/$(CONFIG)/obj/osdep.o'
	$(CC) -c $(DFLAGS) -o build/$(CONFIG)/obj/osdep.o -arch $(CC_ARCH) $(CFLAGS) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" "-I$(ME_COM_MATRIXSSL_PATH)" "-I$(ME_COM_MATRIXSSL_PATH)/matrixssl" "-I$(ME_COM_NANOSSL_PATH)/src" src/osdep.c

#
#   rom-documents.o
#
DEPS_21 += build/$(CONFIG)/inc/me.h
DEPS_21 += build/$(CONFIG)/inc/goahead.h

build/$(CONFIG)/obj/rom-documents.o: \
    src/rom-documents.c $(DEPS_21)
	@echo '   [Compile] build/$(CONFIG)/obj/rom-documents.o'
	$(CC) -c $(DFLAGS) -o build/$(CONFIG)/obj/rom-documents.o -arch $(CC_ARCH) $(CFLAGS) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" "-I$(ME_COM_MATRIXSSL_PATH)" "-I$(ME_COM_MATRIXSSL_PATH)/matrixssl" "-I$(ME_COM_NANOSSL_PATH)/src" src/rom-documents.c

#
#   route.o
#
DEPS_22 += build/$(CONFIG)/inc/me.h
DEPS_22 += build/$(CONFIG)/inc/goahead.h

build/$(CONFIG)/obj/route.o: \
    src/route.c $(DEPS_22)
	@echo '   [Compile] build/$(CONFIG)/obj/route.o'
	$(CC) -c $(DFLAGS) -o build/$(CONFIG)/obj/route.o -arch $(CC_ARCH) $(CFLAGS) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" "-I$(ME_COM_MATRIXSSL_PATH)" "-I$(ME_COM_MATRIXSSL_PATH)/matrixssl" "-I$(ME_COM_NANOSSL_PATH)/src" src/route.c

#
#   runtime.o
#
DEPS_23 += build/$(CONFIG)/inc/me.h
DEPS_23 += build/$(CONFIG)/inc/goahead.h

build/$(CONFIG)/obj/runtime.o: \
    src/runtime.c $(DEPS_23)
	@echo '   [Compile] build/$(CONFIG)/obj/runtime.o'
	$(CC) -c $(DFLAGS) -o build/$(CONFIG)/obj/runtime.o -arch $(CC_ARCH) $(CFLAGS) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" "-I$(ME_COM_MATRIXSSL_PATH)" "-I$(ME_COM_MATRIXSSL_PATH)/matrixssl" "-I$(ME_COM_NANOSSL_PATH)/src" src/runtime.c

#
#   socket.o
#
DEPS_24 += build/$(CONFIG)/inc/me.h
DEPS_24 += build/$(CONFIG)/inc/goahead.h

build/$(CONFIG)/obj/socket.o: \
    src/socket.c $(DEPS_24)
	@echo '   [Compile] build/$(CONFIG)/obj/socket.o'
	$(CC) -c $(DFLAGS) -o build/$(CONFIG)/obj/socket.o -arch $(CC_ARCH) $(CFLAGS) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" "-I$(ME_COM_MATRIXSSL_PATH)" "-I$(ME_COM_MATRIXSSL_PATH)/matrixssl" "-I$(ME_COM_NANOSSL_PATH)/src" src/socket.c

#
#   upload.o
#
DEPS_25 += build/$(CONFIG)/inc/me.h
DEPS_25 += build/$(CONFIG)/inc/goahead.h

build/$(CONFIG)/obj/upload.o: \
    src/upload.c $(DEPS_25)
	@echo '   [Compile] build/$(CONFIG)/obj/upload.o'
	$(CC) -c $(DFLAGS) -o build/$(CONFIG)/obj/upload.o -arch $(CC_ARCH) $(CFLAGS) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" "-I$(ME_COM_MATRIXSSL_PATH)" "-I$(ME_COM_MATRIXSSL_PATH)/matrixssl" "-I$(ME_COM_NANOSSL_PATH)/src" src/upload.c

#
#   est.o
#
DEPS_26 += build/$(CONFIG)/inc/me.h
DEPS_26 += build/$(CONFIG)/inc/goahead.h
DEPS_26 += build/$(CONFIG)/inc/est.h

build/$(CONFIG)/obj/est.o: \
    src/ssl/est.c $(DEPS_26)
	@echo '   [Compile] build/$(CONFIG)/obj/est.o'
	$(CC) -c $(DFLAGS) -o build/$(CONFIG)/obj/est.o -arch $(CC_ARCH) $(CFLAGS) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" "-I$(ME_COM_MATRIXSSL_PATH)" "-I$(ME_COM_MATRIXSSL_PATH)/matrixssl" "-I$(ME_COM_NANOSSL_PATH)/src" src/ssl/est.c

#
#   matrixssl.o
#
DEPS_27 += build/$(CONFIG)/inc/me.h
DEPS_27 += build/$(CONFIG)/inc/goahead.h

build/$(CONFIG)/obj/matrixssl.o: \
    src/ssl/matrixssl.c $(DEPS_27)
	@echo '   [Compile] build/$(CONFIG)/obj/matrixssl.o'
	$(CC) -c $(DFLAGS) -o build/$(CONFIG)/obj/matrixssl.o -arch $(CC_ARCH) $(CFLAGS) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" "-I$(ME_COM_MATRIXSSL_PATH)" "-I$(ME_COM_MATRIXSSL_PATH)/matrixssl" "-I$(ME_COM_NANOSSL_PATH)/src" src/ssl/matrixssl.c

#
#   nanossl.o
#
DEPS_28 += build/$(CONFIG)/inc/me.h

build/$(CONFIG)/obj/nanossl.o: \
    src/ssl/nanossl.c $(DEPS_28)
	@echo '   [Compile] build/$(CONFIG)/obj/nanossl.o'
	$(CC) -c $(DFLAGS) -o build/$(CONFIG)/obj/nanossl.o -arch $(CC_ARCH) $(CFLAGS) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" "-I$(ME_COM_MATRIXSSL_PATH)" "-I$(ME_COM_MATRIXSSL_PATH)/matrixssl" "-I$(ME_COM_NANOSSL_PATH)/src" src/ssl/nanossl.c

#
#   openssl.o
#
DEPS_29 += build/$(CONFIG)/inc/me.h
DEPS_29 += build/$(CONFIG)/inc/osdep.h
DEPS_29 += build/$(CONFIG)/inc/goahead.h

build/$(CONFIG)/obj/openssl.o: \
    src/ssl/openssl.c $(DEPS_29)
	@echo '   [Compile] build/$(CONFIG)/obj/openssl.o'
	$(CC) -c $(DFLAGS) -o build/$(CONFIG)/obj/openssl.o -arch $(CC_ARCH) $(CFLAGS) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" "-I$(ME_COM_MATRIXSSL_PATH)" "-I$(ME_COM_MATRIXSSL_PATH)/matrixssl" "-I$(ME_COM_NANOSSL_PATH)/src" src/ssl/openssl.c

#
#   libgo
#
DEPS_30 += build/$(CONFIG)/inc/est.h
DEPS_30 += build/$(CONFIG)/inc/me.h
DEPS_30 += build/$(CONFIG)/inc/osdep.h
DEPS_30 += build/$(CONFIG)/obj/estLib.o
ifeq ($(ME_COM_EST),1)
    DEPS_30 += build/$(CONFIG)/bin/libest.a
endif
DEPS_30 += build/$(CONFIG)/inc/goahead.h
DEPS_30 += build/$(CONFIG)/inc/js.h
DEPS_30 += build/$(CONFIG)/obj/action.o
DEPS_30 += build/$(CONFIG)/obj/alloc.o
DEPS_30 += build/$(CONFIG)/obj/auth.o
DEPS_30 += build/$(CONFIG)/obj/cgi.o
DEPS_30 += build/$(CONFIG)/obj/crypt.o
DEPS_30 += build/$(CONFIG)/obj/file.o
DEPS_30 += build/$(CONFIG)/obj/fs.o
DEPS_30 += build/$(CONFIG)/obj/http.o
DEPS_30 += build/$(CONFIG)/obj/js.o
DEPS_30 += build/$(CONFIG)/obj/jst.o
DEPS_30 += build/$(CONFIG)/obj/options.o
DEPS_30 += build/$(CONFIG)/obj/osdep.o
DEPS_30 += build/$(CONFIG)/obj/rom-documents.o
DEPS_30 += build/$(CONFIG)/obj/route.o
DEPS_30 += build/$(CONFIG)/obj/runtime.o
DEPS_30 += build/$(CONFIG)/obj/socket.o
DEPS_30 += build/$(CONFIG)/obj/upload.o
DEPS_30 += build/$(CONFIG)/obj/est.o
DEPS_30 += build/$(CONFIG)/obj/matrixssl.o
DEPS_30 += build/$(CONFIG)/obj/nanossl.o
DEPS_30 += build/$(CONFIG)/obj/openssl.o

build/$(CONFIG)/bin/libgo.a: $(DEPS_30)
	@echo '      [Link] build/$(CONFIG)/bin/libgo.a'
	ar -cr build/$(CONFIG)/bin/libgo.a "build/$(CONFIG)/obj/action.o" "build/$(CONFIG)/obj/alloc.o" "build/$(CONFIG)/obj/auth.o" "build/$(CONFIG)/obj/cgi.o" "build/$(CONFIG)/obj/crypt.o" "build/$(CONFIG)/obj/file.o" "build/$(CONFIG)/obj/fs.o" "build/$(CONFIG)/obj/http.o" "build/$(CONFIG)/obj/js.o" "build/$(CONFIG)/obj/jst.o" "build/$(CONFIG)/obj/options.o" "build/$(CONFIG)/obj/osdep.o" "build/$(CONFIG)/obj/rom-documents.o" "build/$(CONFIG)/obj/route.o" "build/$(CONFIG)/obj/runtime.o" "build/$(CONFIG)/obj/socket.o" "build/$(CONFIG)/obj/upload.o" "build/$(CONFIG)/obj/est.o" "build/$(CONFIG)/obj/matrixssl.o" "build/$(CONFIG)/obj/nanossl.o" "build/$(CONFIG)/obj/openssl.o"

#
#   goahead.o
#
DEPS_31 += build/$(CONFIG)/inc/me.h
DEPS_31 += build/$(CONFIG)/inc/goahead.h
DEPS_31 += build/$(CONFIG)/inc/osdep.h

build/$(CONFIG)/obj/goahead.o: \
    src/goahead.c $(DEPS_31)
	@echo '   [Compile] build/$(CONFIG)/obj/goahead.o'
	$(CC) -c $(DFLAGS) -o build/$(CONFIG)/obj/goahead.o -arch $(CC_ARCH) $(CFLAGS) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" "-I$(ME_COM_MATRIXSSL_PATH)" "-I$(ME_COM_MATRIXSSL_PATH)/matrixssl" "-I$(ME_COM_NANOSSL_PATH)/src" src/goahead.c

#
#   goahead
#
DEPS_32 += build/$(CONFIG)/inc/est.h
DEPS_32 += build/$(CONFIG)/inc/me.h
DEPS_32 += build/$(CONFIG)/inc/osdep.h
DEPS_32 += build/$(CONFIG)/obj/estLib.o
ifeq ($(ME_COM_EST),1)
    DEPS_32 += build/$(CONFIG)/bin/libest.a
endif
DEPS_32 += build/$(CONFIG)/inc/goahead.h
DEPS_32 += build/$(CONFIG)/inc/js.h
DEPS_32 += build/$(CONFIG)/obj/action.o
DEPS_32 += build/$(CONFIG)/obj/alloc.o
DEPS_32 += build/$(CONFIG)/obj/auth.o
DEPS_32 += build/$(CONFIG)/obj/cgi.o
DEPS_32 += build/$(CONFIG)/obj/crypt.o
DEPS_32 += build/$(CONFIG)/obj/file.o
DEPS_32 += build/$(CONFIG)/obj/fs.o
DEPS_32 += build/$(CONFIG)/obj/http.o
DEPS_32 += build/$(CONFIG)/obj/js.o
DEPS_32 += build/$(CONFIG)/obj/jst.o
DEPS_32 += build/$(CONFIG)/obj/options.o
DEPS_32 += build/$(CONFIG)/obj/osdep.o
DEPS_32 += build/$(CONFIG)/obj/rom-documents.o
DEPS_32 += build/$(CONFIG)/obj/route.o
DEPS_32 += build/$(CONFIG)/obj/runtime.o
DEPS_32 += build/$(CONFIG)/obj/socket.o
DEPS_32 += build/$(CONFIG)/obj/upload.o
DEPS_32 += build/$(CONFIG)/obj/est.o
DEPS_32 += build/$(CONFIG)/obj/matrixssl.o
DEPS_32 += build/$(CONFIG)/obj/nanossl.o
DEPS_32 += build/$(CONFIG)/obj/openssl.o
DEPS_32 += build/$(CONFIG)/bin/libgo.a
DEPS_32 += build/$(CONFIG)/obj/goahead.o

LIBS_32 += -lgo
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_32 += -lssl
    LIBPATHS_32 += -L$(ME_COM_OPENSSL_PATH)
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_32 += -lcrypto
    LIBPATHS_32 += -L$(ME_COM_OPENSSL_PATH)
endif
ifeq ($(ME_COM_EST),1)
    LIBS_32 += -lest
endif
ifeq ($(ME_COM_MATRIXSSL),1)
    LIBS_32 += -lmatrixssl
    LIBPATHS_32 += -L$(ME_COM_MATRIXSSL_PATH)
endif
ifeq ($(ME_COM_NANOSSL),1)
    LIBS_32 += -lssls
    LIBPATHS_32 += -L$(ME_COM_NANOSSL_PATH)/bin
endif

build/$(CONFIG)/bin/goahead: $(DEPS_32)
	@echo '      [Link] build/$(CONFIG)/bin/goahead'
	$(CC) -o build/$(CONFIG)/bin/goahead -arch $(CC_ARCH) $(LDFLAGS) $(LIBPATHS)    "build/$(CONFIG)/obj/goahead.o" $(LIBPATHS_32) $(LIBS_32) $(LIBS_32) $(LIBS) 

#
#   test.o
#
DEPS_33 += build/$(CONFIG)/inc/me.h
DEPS_33 += build/$(CONFIG)/inc/goahead.h
DEPS_33 += build/$(CONFIG)/inc/js.h
DEPS_33 += build/$(CONFIG)/inc/osdep.h

build/$(CONFIG)/obj/test.o: \
    test/test.c $(DEPS_33)
	@echo '   [Compile] build/$(CONFIG)/obj/test.o'
	$(CC) -c $(DFLAGS) -o build/$(CONFIG)/obj/test.o -arch $(CC_ARCH) $(CFLAGS) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" "-I$(ME_COM_MATRIXSSL_PATH)" "-I$(ME_COM_MATRIXSSL_PATH)/matrixssl" "-I$(ME_COM_NANOSSL_PATH)/src" test/test.c

#
#   goahead-test
#
DEPS_34 += build/$(CONFIG)/inc/est.h
DEPS_34 += build/$(CONFIG)/inc/me.h
DEPS_34 += build/$(CONFIG)/inc/osdep.h
DEPS_34 += build/$(CONFIG)/obj/estLib.o
ifeq ($(ME_COM_EST),1)
    DEPS_34 += build/$(CONFIG)/bin/libest.a
endif
DEPS_34 += build/$(CONFIG)/inc/goahead.h
DEPS_34 += build/$(CONFIG)/inc/js.h
DEPS_34 += build/$(CONFIG)/obj/action.o
DEPS_34 += build/$(CONFIG)/obj/alloc.o
DEPS_34 += build/$(CONFIG)/obj/auth.o
DEPS_34 += build/$(CONFIG)/obj/cgi.o
DEPS_34 += build/$(CONFIG)/obj/crypt.o
DEPS_34 += build/$(CONFIG)/obj/file.o
DEPS_34 += build/$(CONFIG)/obj/fs.o
DEPS_34 += build/$(CONFIG)/obj/http.o
DEPS_34 += build/$(CONFIG)/obj/js.o
DEPS_34 += build/$(CONFIG)/obj/jst.o
DEPS_34 += build/$(CONFIG)/obj/options.o
DEPS_34 += build/$(CONFIG)/obj/osdep.o
DEPS_34 += build/$(CONFIG)/obj/rom-documents.o
DEPS_34 += build/$(CONFIG)/obj/route.o
DEPS_34 += build/$(CONFIG)/obj/runtime.o
DEPS_34 += build/$(CONFIG)/obj/socket.o
DEPS_34 += build/$(CONFIG)/obj/upload.o
DEPS_34 += build/$(CONFIG)/obj/est.o
DEPS_34 += build/$(CONFIG)/obj/matrixssl.o
DEPS_34 += build/$(CONFIG)/obj/nanossl.o
DEPS_34 += build/$(CONFIG)/obj/openssl.o
DEPS_34 += build/$(CONFIG)/bin/libgo.a
DEPS_34 += build/$(CONFIG)/obj/test.o

LIBS_34 += -lgo
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_34 += -lssl
    LIBPATHS_34 += -L$(ME_COM_OPENSSL_PATH)
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_34 += -lcrypto
    LIBPATHS_34 += -L$(ME_COM_OPENSSL_PATH)
endif
ifeq ($(ME_COM_EST),1)
    LIBS_34 += -lest
endif
ifeq ($(ME_COM_MATRIXSSL),1)
    LIBS_34 += -lmatrixssl
    LIBPATHS_34 += -L$(ME_COM_MATRIXSSL_PATH)
endif
ifeq ($(ME_COM_NANOSSL),1)
    LIBS_34 += -lssls
    LIBPATHS_34 += -L$(ME_COM_NANOSSL_PATH)/bin
endif

build/$(CONFIG)/bin/goahead-test: $(DEPS_34)
	@echo '      [Link] build/$(CONFIG)/bin/goahead-test'
	$(CC) -o build/$(CONFIG)/bin/goahead-test -arch $(CC_ARCH) $(LDFLAGS) $(LIBPATHS)    "build/$(CONFIG)/obj/test.o" $(LIBPATHS_34) $(LIBS_34) $(LIBS_34) $(LIBS) 

#
#   gopass.o
#
DEPS_35 += build/$(CONFIG)/inc/me.h
DEPS_35 += build/$(CONFIG)/inc/goahead.h
DEPS_35 += build/$(CONFIG)/inc/osdep.h

build/$(CONFIG)/obj/gopass.o: \
    src/utils/gopass.c $(DEPS_35)
	@echo '   [Compile] build/$(CONFIG)/obj/gopass.o'
	$(CC) -c $(DFLAGS) -o build/$(CONFIG)/obj/gopass.o -arch $(CC_ARCH) $(CFLAGS) $(IFLAGS) "-I$(ME_COM_OPENSSL_PATH)/include" "-I$(ME_COM_MATRIXSSL_PATH)" "-I$(ME_COM_MATRIXSSL_PATH)/matrixssl" "-I$(ME_COM_NANOSSL_PATH)/src" src/utils/gopass.c

#
#   gopass
#
DEPS_36 += build/$(CONFIG)/inc/est.h
DEPS_36 += build/$(CONFIG)/inc/me.h
DEPS_36 += build/$(CONFIG)/inc/osdep.h
DEPS_36 += build/$(CONFIG)/obj/estLib.o
ifeq ($(ME_COM_EST),1)
    DEPS_36 += build/$(CONFIG)/bin/libest.a
endif
DEPS_36 += build/$(CONFIG)/inc/goahead.h
DEPS_36 += build/$(CONFIG)/inc/js.h
DEPS_36 += build/$(CONFIG)/obj/action.o
DEPS_36 += build/$(CONFIG)/obj/alloc.o
DEPS_36 += build/$(CONFIG)/obj/auth.o
DEPS_36 += build/$(CONFIG)/obj/cgi.o
DEPS_36 += build/$(CONFIG)/obj/crypt.o
DEPS_36 += build/$(CONFIG)/obj/file.o
DEPS_36 += build/$(CONFIG)/obj/fs.o
DEPS_36 += build/$(CONFIG)/obj/http.o
DEPS_36 += build/$(CONFIG)/obj/js.o
DEPS_36 += build/$(CONFIG)/obj/jst.o
DEPS_36 += build/$(CONFIG)/obj/options.o
DEPS_36 += build/$(CONFIG)/obj/osdep.o
DEPS_36 += build/$(CONFIG)/obj/rom-documents.o
DEPS_36 += build/$(CONFIG)/obj/route.o
DEPS_36 += build/$(CONFIG)/obj/runtime.o
DEPS_36 += build/$(CONFIG)/obj/socket.o
DEPS_36 += build/$(CONFIG)/obj/upload.o
DEPS_36 += build/$(CONFIG)/obj/est.o
DEPS_36 += build/$(CONFIG)/obj/matrixssl.o
DEPS_36 += build/$(CONFIG)/obj/nanossl.o
DEPS_36 += build/$(CONFIG)/obj/openssl.o
DEPS_36 += build/$(CONFIG)/bin/libgo.a
DEPS_36 += build/$(CONFIG)/obj/gopass.o

LIBS_36 += -lgo
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_36 += -lssl
    LIBPATHS_36 += -L$(ME_COM_OPENSSL_PATH)
endif
ifeq ($(ME_COM_OPENSSL),1)
    LIBS_36 += -lcrypto
    LIBPATHS_36 += -L$(ME_COM_OPENSSL_PATH)
endif
ifeq ($(ME_COM_EST),1)
    LIBS_36 += -lest
endif
ifeq ($(ME_COM_MATRIXSSL),1)
    LIBS_36 += -lmatrixssl
    LIBPATHS_36 += -L$(ME_COM_MATRIXSSL_PATH)
endif
ifeq ($(ME_COM_NANOSSL),1)
    LIBS_36 += -lssls
    LIBPATHS_36 += -L$(ME_COM_NANOSSL_PATH)/bin
endif

build/$(CONFIG)/bin/gopass: $(DEPS_36)
	@echo '      [Link] build/$(CONFIG)/bin/gopass'
	$(CC) -o build/$(CONFIG)/bin/gopass -arch $(CC_ARCH) $(LDFLAGS) $(LIBPATHS)    "build/$(CONFIG)/obj/gopass.o" $(LIBPATHS_36) $(LIBS_36) $(LIBS_36) $(LIBS) 

#
#   stop
#
stop: $(DEPS_37)

#
#   installBinary
#
installBinary: $(DEPS_38)
	( \
	cd .; \
	mkdir -p "$(ME_APP_PREFIX)" ; \
	rm -f "$(ME_APP_PREFIX)/latest" ; \
	ln -s "3.3.5" "$(ME_APP_PREFIX)/latest" ; \
	mkdir -p "$(ME_VAPP_PREFIX)/bin" ; \
	cp build/$(CONFIG)/bin/goahead $(ME_VAPP_PREFIX)/bin/goahead ; \
	mkdir -p "$(ME_BIN_PREFIX)" ; \
	rm -f "$(ME_BIN_PREFIX)/goahead" ; \
	ln -s "$(ME_VAPP_PREFIX)/bin/goahead" "$(ME_BIN_PREFIX)/goahead" ; \
	if [ "$(ME_COM_OPENSSL)" = 1 ]; then true ; \
	cp build/$(CONFIG)/bin/libssl*.dylib* $(ME_VAPP_PREFIX)/bin/libssl*.dylib* ; \
	cp build/$(CONFIG)/bin/libcrypto*.dylib* $(ME_VAPP_PREFIX)/bin/libcrypto*.dylib* ; \
	fi ; \
	cp src/paks/est/ca.crt $(ME_VAPP_PREFIX)/bin/ca.crt ; \
	mkdir -p "$(ME_VAPP_PREFIX)/doc/man/man1" ; \
	cp doc/man/goahead.1 $(ME_VAPP_PREFIX)/doc/man/man1/goahead.1 ; \
	mkdir -p "$(ME_MAN_PREFIX)/man1" ; \
	rm -f "$(ME_MAN_PREFIX)/man1/goahead.1" ; \
	ln -s "$(ME_VAPP_PREFIX)/doc/man/man1/goahead.1" "$(ME_MAN_PREFIX)/man1/goahead.1" ; \
	cp doc/man/gopass.1 $(ME_VAPP_PREFIX)/doc/man/man1/gopass.1 ; \
	rm -f "$(ME_MAN_PREFIX)/man1/gopass.1" ; \
	ln -s "$(ME_VAPP_PREFIX)/doc/man/man1/gopass.1" "$(ME_MAN_PREFIX)/man1/gopass.1" ; \
	cp doc/man/webcomp.1 $(ME_VAPP_PREFIX)/doc/man/man1/webcomp.1 ; \
	rm -f "$(ME_MAN_PREFIX)/man1/webcomp.1" ; \
	ln -s "$(ME_VAPP_PREFIX)/doc/man/man1/webcomp.1" "$(ME_MAN_PREFIX)/man1/webcomp.1" ; \
	mkdir -p "$(ME_WEB_PREFIX)" ; \
	cp src/web/index.html $(ME_WEB_PREFIX)/index.html ; \
	cp src/web/favicon.ico $(ME_WEB_PREFIX)/favicon.ico ; \
	mkdir -p "$(ME_ETC_PREFIX)" ; \
	cp src/auth.txt $(ME_ETC_PREFIX)/auth.txt ; \
	cp src/route.txt $(ME_ETC_PREFIX)/route.txt ; \
	cp src/self.crt $(ME_ETC_PREFIX)/self.crt ; \
	cp src/self.key $(ME_ETC_PREFIX)/self.key ; \
	)

#
#   start
#
start: $(DEPS_39)

#
#   install
#
DEPS_40 += stop
DEPS_40 += installBinary
DEPS_40 += start

install: $(DEPS_40)

#
#   run
#
run: $(DEPS_41)
	cd src; goahead -v ; cd ..
#
#   uninstall
#
DEPS_42 += stop

uninstall: $(DEPS_42)
	( \
	cd .; \
	rm -fr "$(ME_WEB_PREFIX)" ; \
	rm -fr "$(ME_VAPP_PREFIX)" ; \
	rmdir -p "$(ME_ETC_PREFIX)" 2>/dev/null ; true ; \
	rmdir -p "$(ME_WEB_PREFIX)" 2>/dev/null ; true ; \
	rm -f "$(ME_APP_PREFIX)/latest" ; \
	rmdir -p "$(ME_APP_PREFIX)" 2>/dev/null ; true ; \
	)

#
#   version
#
version: $(DEPS_43)
	echo 3.3.5

