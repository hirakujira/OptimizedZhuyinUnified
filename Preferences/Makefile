ifeq ($(THEOS_PACKAGE_SCHEME),rootless)
	ARCHS = arm64 arm64e
	TARGET = iphone:16.2:15.0
else
	ARCHS = armv7 arm64 arm64e
	TARGET = iphone:12.1.2:6.0
endif

GO_EASY_ON_ME = 1
BUNDLE_NAME = OptimizedZhuyinUnified
IP_ADDRESS=127.0.0.1
RSYNC_SETTINGS = -e "ssh -p 2222" -z
SSH_PORT = -p 2222
OptimizedZhuyinUnified_FILES = OptimizedZhuyinMainController.mm 
OptimizedZhuyinUnified_CFLAGS = -F$(SYSROOT)/System/Library/CoreServices -fobjc-arc
OptimizedZhuyinUnified_INSTALL_PATH = /Library/PreferenceBundles
OptimizedZhuyinUnified_FRAMEWORKS = UIKit Foundation
OptimizedZhuyinUnified_PRIVATE_FRAMEWORKS = Preferences MessageUI

include theos/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage ::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/OptimizedZhuyinUnified.plist$(ECHO_END)
