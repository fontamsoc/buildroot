################################################################################
#
# pu32-gdbserver
#
################################################################################

PU32_GDBSERVER_VERSION = pu32.20230923
PU32_GDBSERVER_SITE = $(call github,fontamsoc,binutils-gdb,$(PU32_GDBSERVER_VERSION))
PU32_GDBSERVER_SOURCE = $(PU32_GDBSERVER_VERSION).tar.gz

PU32_GDBSERVER_DEPENDENCIES = expat gmp mpfr

PU32_GDBSERVER_CONF_OPTS += \
	--with-expat \
	--disable-binutils \
	--disable-install-libbfd \
	--disable-gdb \
	--disable-ld \
	--disable-gas \
	--disable-sim \
	--disable-gprof \
	--disable-nls \
	--disable-plugins \
	--disable-multilib \
	--disable-werror \
	--disable-shared \
	--enable-static \
	--without-debuginfod \
	--disable-doc \
	--disable-docs \
	--disable-documentation

$(eval $(autotools-package))
