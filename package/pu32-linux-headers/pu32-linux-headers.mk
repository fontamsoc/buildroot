################################################################################
#
# pu32-linux-headers
#
################################################################################

PU32_LINUX_HEADERS_VERSION = main
PU32_LINUX_HEADERS_SITE = https://github.com/fontamsoc/pu32/raw/$(PU32_LINUX_HEADERS_VERSION)
PU32_LINUX_HEADERS_SOURCE = linux-headers.tar.xz

define PU32_LINUX_HEADERS_EXTRACT_CMDS
        tar -xf $($(PKG)_DL_DIR)/$($(PKG)_SOURCE) -C $(@D)/
endef

define PU32_LINUX_HEADERS_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/opt/toolchain/ && \
		cp -a $(@D)/* $(TARGET_DIR)/opt/toolchain/
endef

$(eval $(generic-package))
