################################################################################
#
# pu32-glibc
#
################################################################################

PU32_GLIBC_VERSION = pu32.20221031
PU32_GLIBC_SITE = $(call github,fontamsoc,glibc,$(PU32_GLIBC_VERSION))
PU32_GLIBC_SOURCE = $(PU32_GLIBC_VERSION).tar.gz

PU32_GLIBC_DEPENDENCIES = pu32-linux-headers host-bison host-gawk \
	$(BR2_MAKE_HOST_DEPENDENCY) $(BR2_PYTHON3_HOST_DEPENDENCY)

PU32_GLIBC_SUBDIR = pu32-build

ifeq ($(BR2_ENABLE_DEBUG),y)
PU32_GLIBC_EXTRA_CFLAGS += -g
endif

PU32_GLIBC_CONF_ENV = \
	CXX=no

define PU32_GLIBC_CONFIGURE_CMDS
	mkdir -p $(@D)/pu32-build
	(cd $(@D)/pu32-build; \
		$(TARGET_CONFIGURE_OPTS) CPPFLAGS="" \
		CFLAGS="$(PU32_GLIBC_EXTRA_CFLAGS)" \
		CXXFLAGS="$(PU32_GLIBC_EXTRA_CFLAGS)" \
		$(PU32_GLIBC_CONF_ENV) \
		$(@D)/configure \
		--target=pu32-elf \
		--host=$(GNU_TARGET_NAME) \
		--prefix=/opt/toolchain \
		--libexecdir=/opt/toolchain/lib \
		--disable-werror \
		--without-gd \
		--disable-profile \
		--enable-static-nss \
		--disable-nscd \
		--disable-nls \
		--enable-kernel=5.0 \
		--with-headers=$(TARGET_DIR)/opt/toolchain/include)
endef

define PU32_GLIBC_TARGET_INSTALL_FIXUPS
	rm -f $$(find $(TARGET_DIR)/opt/toolchain/ | fgrep .so)
	rm -f $(TARGET_DIR)/opt/toolchain/bin/{ldd,pldd,sotruss,sprof}
	rm -f $(TARGET_DIR)/opt/toolchain/sbin/{ldconfig,sln}
	rm -rf $(TARGET_DIR)/opt/toolchain/{var,share}
endef
PU32_GLIBC_POST_INSTALL_TARGET_HOOKS += PU32_GLIBC_TARGET_INSTALL_FIXUPS

define PU32_GLIBC_SET_PATH
	fgrep -qs '/opt/toolchain/' $(TARGET_DIR)/etc/profile.d/toolchain.sh || \
		echo 'PATH=$${PATH}:/opt/toolchain/sbin:/opt/toolchain/bin' > $(TARGET_DIR)/etc/profile.d/toolchain.sh
endef
PU32_GLIBC_TARGET_FINALIZE_HOOKS += PU32_GLIBC_SET_PATH

$(eval $(autotools-package))
