GO_EASY_ON_ME = 1
ARCHS = armv7 arm64 arm64e
TARGET = :clang::6.0
BUNDLE_NAME = OptimizedZhuyin
IP_ADDRESS=127.0.0.1
RSYNC_SETTINGS = -e "ssh -p 2222" -z
SSH_PORT = -p 2222
OptimizedZhuyin_FILES = OptimizedZhuyinMainController.mm 
OptimizedZhuyin_CFLAGS = -F$(SYSROOT)/System/Library/CoreServices -fobjc-arc
OptimizedZhuyin_INSTALL_PATH = /Library/PreferenceBundles
OptimizedZhuyin_FRAMEWORKS = UIKit Foundation
OptimizedZhuyin_PRIVATE_FRAMEWORKS = Preferences MessageUI

include theos/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage ::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/OptimizedZhuyin.plist$(ECHO_END)
	# rsync $(RSYNC_SETTINGS) $(THEOS_STAGING_DIR)/Library/PreferenceBundles/OptimizedZhuyin.bundle/* root@$(IP_ADDRESS):/Library/PreferenceBundles/OptimizedZhuyin.bundle/
	# ssh root@$(IP_ADDRESS) $(SSH_PORT) killall Preferences
	
sync: stage
	# rsync -z $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/OptimizedZhuyin.plist root@$(IP_ADDRESS):/Library/PreferenceLoader/Preferences/OptimizedZhuyin.plist
	# ssh root@$(IP_ADDRESS) open com.apple.Preferences
	
synclocal: stage
	rsync -e "ssh -p 2222" -z $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/OptimizedZhuyin.plist root@$(IP_ADDRESS):/Library/PreferenceLoader/Preferences/OptimizedZhuyin.plist
	# ssh root@$(IP_ADDRESS) $(SSH_PORT) open com.apple.Preferences