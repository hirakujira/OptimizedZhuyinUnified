TWEAK_NAME = OptimizedZhuyinUnified
OptimizedZhuyinUnified_FILES = Tweak.xm KBDumper.mm
OptimizedZhuyinUnified_CFLAGS = -F$(SYSROOT)/System/Library/CoreServices -fobjc-arc
OptimizedZhuyinUnified_PRIVATE_FRAMEWORKS = UIKit Foundation

SYSROOT = $(THEOS)/sdks/iPhoneOS9.2.sdk

ifeq ($(THEOS_PACKAGE_SCHEME),rootless)
	ARCHS = arm64 arm64e
	TARGET = iphone:16.2:12.0
else
	ARCHS = armv7 arm64 arm64e
	TARGET = iphone:12.1.2:6.0
endif

GO_EASY_ON_ME = 1
FINALPACKAGE = 1

SUBPROJECTS += Preferences
SUBPROJECTS += iOS5 # You can comment this if you don't want to build this tweak for iOS 5

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

sync: stage
	# scp.sh
	# @ssh root@127.0.0.1 -p 2222 killall MobileSMS
	rsync -e "ssh -p 2222" -z $(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/* root@127.0.0.1:/Library/MobileSubstrate/DynamicLibraries/
	ssh root@127.0.0.1 -p 2222 killall MobileNotes
	ssh root@127.0.0.1 -p 2222 open com.apple.mobilenotes
