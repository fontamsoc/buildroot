################################################################################
#
# pu32-gcc
#
################################################################################

PU32_GCC_VERSION = pu32.20221031
PU32_GCC_SITE = $(call github,fontamsoc,gcc,$(PU32_GCC_VERSION))
PU32_GCC_SOURCE = $(PU32_GCC_VERSION).tar.gz

PU32_GCC_DEPENDENCIES = pu32-binutils pu32-glibc

define PU32_GCC_PRE_PATCH_HOOKS_FIXUPS
	(cd $(@D); ./contrib/download_prerequisites)
endef
PU32_GCC_PRE_PATCH_HOOKS += PU32_GCC_PRE_PATCH_HOOKS_FIXUPS

PU32_GCC_SUBDIR = pu32-build

ifeq ($(BR2_ENABLE_DEBUG),y)
PU32_GCC_EXTRA_CFLAGS += -g
endif

define PU32_GCC_CONFIGURE_CMDS
	mkdir -p $(@D)/pu32-build
	(cd $(@D)/pu32-build; \
		$(TARGET_CONFIGURE_OPTS) CPPFLAGS="" \
		CFLAGS="$(PU32_GCC_EXTRA_CFLAGS)" \
		CXXFLAGS="$(PU32_GCC_EXTRA_CFLAGS)" \
		$(@D)/configure \
		--target=pu32-elf \
		--host=pu32-elf \
		--prefix=/opt/toolchain \
		--libexecdir=/opt/toolchain/lib \
		--without-headers \
		--disable-libssp \
		--disable-multilib \
		--disable-gcov \
		--disable-lto \
		--enable-libatomic \
		--enable-languages=c,c++ \
		--disable-nls \
		--disable-doc \
		--disable-docs \
		--disable-documentation)
endef

define PU32_GCC_SET_PATH
	fgrep -qs '/opt/toolchain/' $(TARGET_DIR)/etc/profile.d/toolchain.sh || \
		echo 'PATH=$${PATH}:/opt/toolchain/sbin:/opt/toolchain/bin' > $(TARGET_DIR)/etc/profile.d/toolchain.sh
endef
PU32_GCC_TARGET_FINALIZE_HOOKS += PU32_GCC_SET_PATH

$(eval $(autotools-package))
