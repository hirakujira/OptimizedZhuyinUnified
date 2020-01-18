TWEAK_NAME = OptimizedZhuyin
OptimizedZhuyin_FILES = Tweak.xm KBDumper.mm
OptimizedZhuyin_CFLAGS = -F$(SYSROOT)/System/Library/CoreServices -fobjc-arc
OptimizedZhuyin_PRIVATE_FRAMEWORKS = UIKit Foundation

SYSROOT = $(THEOS)/sdks/iPhoneOS9.2.sdk
TARGET = iphone:latest:6.0
ARCHS = armv7 arm64 arm64e

OptimizedZhuyin_LDFLAGS += -Wl,-segalign,4000
GO_EASY_ON_ME = 1
FINALPACKAGE = 1

SUBPROJECTS += Preferences

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

sync: stage
	# scp.sh
	# @ssh root@127.0.0.1 -p 2222 killall MobileSMS
	rsync -e "ssh -p 2222" -z $(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/* root@127.0.0.1:/Library/MobileSubstrate/DynamicLibraries/
	ssh root@127.0.0.1 -p 2222 killall MobileNotes
	ssh root@127.0.0.1 -p 2222 open com.apple.mobilenotes