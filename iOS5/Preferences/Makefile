BUNDLE_NAME = OptimizedZhuyin5
OptimizedZhuyin5_FILES = OptimizedZhuyinMainController.mm
OptimizedZhuyin5_INSTALL_PATH = /Library/PreferenceBundles
OptimizedZhuyin5_CFLAGS = -F$(SYSROOT)/System/Library/CoreServices -fobjc-arc
OptimizedZhuyin5_FRAMEWORKS = UIKit
OptimizedZhuyin5_PRIVATE_FRAMEWORKS = Preferences
TARGET = :clang::5.0
ARCHS = armv7 
GO_EASY_ON_ME = 1

include $(THEOS_MAKE_PATH)/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage ::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/OptimizedZhuyin5.plist$(ECHO_END)