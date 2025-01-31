################################################################################
#
# nano
#
################################################################################

NANO_VERSION_MAJOR = 7
NANO_VERSION = $(NANO_VERSION_MAJOR).2
NANO_SITE = https://www.nano-editor.org/dist/v$(NANO_VERSION_MAJOR)
NANO_SOURCE = nano-$(NANO_VERSION).tar.xz
NANO_LICENSE = GPL-3.0+
NANO_LICENSE_FILES = COPYING
NANO_DEPENDENCIES = ncurses

ifeq ($(BR2_PACKAGE_NCURSES_WCHAR),y)
NANO_CONF_ENV += ac_cv_prog_NCURSESW_CONFIG=$(STAGING_DIR)/usr/bin/$(NCURSES_CONFIG_SCRIPTS)
else
NANO_CONF_ENV += ac_cv_prog_NCURSESW_CONFIG=false
NANO_MAKE_ENV += CURSES_LIB="-lncurses"
endif

ifeq ($(BR2_PACKAGE_FILE),y)
NANO_DEPENDENCIES += file
NANO_CONF_OPTS += --enable-libmagic
else
NANO_CONF_OPTS += --disable-libmagic
endif

ifeq ($(BR2_PACKAGE_NANO_TINY),y)
NANO_CONF_OPTS += \
	--enable-tiny \
	--disable-libmagic \
	--disable-color \
	--disable-nanorc
define NANO_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/src/nano $(TARGET_DIR)/usr/bin/nano
endef
else
NANO_CONF_OPTS += --disable-tiny
ifeq ($(BR2_PACKAGE_FILE),y)
NANO_DEPENDENCIES += file
NANO_CONF_OPTS += --enable-libmagic --enable-color --enable-nanorc
else
NANO_CONF_OPTS += --disable-libmagic --disable-libmagic --disable-color
endif # BR2_PACKAGE_FILE
endif # BR2_PACKAGE_NANO_TINY

define NANO_INSTALL_NANORC
	$(INSTALL) -m 0644 package/nano/nanorc $(TARGET_DIR)/etc/nanorc
endef
NANO_POST_INSTALL_TARGET_HOOKS += NANO_INSTALL_NANORC

$(eval $(autotools-package))
