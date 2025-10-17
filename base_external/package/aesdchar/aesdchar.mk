##############################################################
#
# AESDCHAR
#
##############################################################
AESDCHAR_VERSION = 991d723fa3c0b29211532f193660d1fcbca27841
AESDCHAR_SITE = git@github.com:cu-ecen-aeld/assignments-3-and-later-vizdr.git
AESDCHAR_SITE_METHOD = git

AESDCHAR_MODULE_SUBDIRS = aesd-char-driver

define AESDCHAR_BUILD_CMDS
# Copy the ioctl header to server directory to get updated aesdsocket build
    cp $(@D)/aesd-char-driver/aesd_ioctl.h $(@D)/server/
    # Build aesdsocket
    $(TARGET_CC) $(TARGET_CFLAGS) -DUSE_AESD_CHAR_DEVICE=1 -o $(@D)/server/aesdsocket $(@D)/server/aesdsocket.c -lpthread
endef

define AESDCHAR_INSTALL_TARGET_CMDS
    
    # Install driver load/unload scripts
    $(INSTALL) -D -m 0755 $(@D)/aesd-char-driver/aesdchar_load $(TARGET_DIR)/usr/bin/aesdchar_load
    $(INSTALL) -D -m 0755 $(@D)/aesd-char-driver/aesdchar_unload $(TARGET_DIR)/usr/bin/aesdchar_unload
    
    # Fix paths in load script to use installed module location
    sed -i 's|\./${module}.ko|/lib/modules/$$(uname -r)/extra/${module}.ko|g' $(TARGET_DIR)/usr/bin/aesdchar_load
    sed -i 's|insmod ./$module.ko|insmod /lib/modules/$$(uname -r)/extra/$module.ko|g' $(TARGET_DIR)/usr/bin/aesdchar_load
    
    # Install built aesdsocket binary and start-stop script
    $(INSTALL) -D -m 0755 $(@D)/server/aesdsocket $(TARGET_DIR)/usr/bin/aesdsocket
    $(INSTALL) -D -m 0755 $(@D)/server/aesdsocket-start-stop $(TARGET_DIR)/usr/bin/aesdsocket-start-stop
endef

$(eval $(kernel-module))
$(eval $(generic-package))