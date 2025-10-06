
##############################################################
#
# LDD3 Aesd
#
##############################################################

#TODO: Fill up the contents below in order to reference your assignment 3 git contents
LDD_VERSION = 57497d5cf1015ff819c422043938a5afcdb044d0
# Note: Be sure to reference the *ssh* repository URL here (not https) to work properly
# with ssh keys and the automated build/test system.
# Your site should start with git@github.com:
LDD_SITE = git@github.com:cu-ecen-aeld/assignment-7-vizdr.git
LDD_SITE_METHOD = git
LDD_GIT_SUBMODULES = YES
LDD_LICENSE = GPL-2.0
LDD_LICENSE_FILES = COPYING


# as per buildroot docs
LDD_MODULE_SUBDIRS = misc-modules/ scull/
LDD_MODULE_MAKE_OPTS = KVERSION=$(LINUX_VERSION_PROBED)

LDD_INSTALL_PATH = /lib/modules/$(LINUX_VERSION_PROBED)/ldd-modules/

# trick to expand variable value with following newline for correct interpretetion in bash
define newline


endef

# TODO add your utilities/scripts to the installation steps below
define LDD_INSTALL_TARGET_CMDS
	$(foreach subdir,$(LDD_MODULE_SUBDIRS), \
		$(INSTALL) -d $(TARGET_DIR)/$(LDD_INSTALL_PATH)/$(subdir)$(newline) \
		$(INSTALL) -m 0755 $(@D)/$(subdir)/*.ko $(TARGET_DIR)/$(LDD_INSTALL_PATH)/$(subdir)/$(newline) \
		$(INSTALL) -m 0755 $(@D)/$(subdir)/*load $(TARGET_DIR)/$(LDD_INSTALL_PATH)/$(subdir)/$(newline) \
	)	
endef

$(eval $(kernel-module))
$(eval $(generic-package))
