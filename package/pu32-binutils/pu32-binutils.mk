################################################################################
#
# pu32-binutils
#
################################################################################

PU32_BINUTILS_VERSION = pu32.20230923
PU32_BINUTILS_SITE = $(call github,fontamsoc,binutils-gdb,$(PU32_BINUTILS_VERSION))
PU32_BINUTILS_SOURCE = $(PU32_BINUTILS_VERSION).tar.gz

PU32_BINUTILS_DEPENDENCIES = expat gmp mpfr

PU32_BINUTILS_SUBDIR = pu32-build

ifeq ($(BR2_ENABLE_DEBUG),y)
PU32_BINUTILS_EXTRA_CFLAGS += -g
endif

PU32_BINUTILS_EXTRA_CFLAGS += -O3 -I$(TARGET_DIR)/usr/include/ -L$(TARGET_DIR)/usr/lib/

define PU32_BINUTILS_CONFIGURE_CMDS
	mkdir -p $(@D)/pu32-build
	(cd $(@D)/pu32-build; \
		$(TARGET_CONFIGURE_OPTS) CPPFLAGS="" \
		CFLAGS="$(PU32_BINUTILS_EXTRA_CFLAGS)" \
		CXXFLAGS="$(PU32_BINUTILS_EXTRA_CFLAGS)" \
		$(@D)/configure \
		--target=pu32-elf \
		--host=pu32-elf \
		--prefix=/opt/toolchain \
		--libexecdir=/opt/toolchain/lib \
		--with-expat \
		--disable-nls \
		--disable-gdbserver \
		--disable-sim \
		--disable-tui \
		--disable-plugins \
		--disable-multilib \
		--disable-werror \
		--disable-shared \
		--enable-static \
		--without-debuginfod \
		--disable-doc \
		--disable-docs \
		--disable-documentation)
endef

define PU32_BINUTILS_SET_PATH
	fgrep -qs '/opt/toolchain/' $(TARGET_DIR)/etc/profile.d/toolchain.sh || \
		echo 'PATH=$${PATH}:/opt/toolchain/sbin:/opt/toolchain/bin' > $(TARGET_DIR)/etc/profile.d/toolchain.sh
endef
PU32_BINUTILS_TARGET_FINALIZE_HOOKS += PU32_BINUTILS_SET_PATH

$(eval $(autotools-package))
