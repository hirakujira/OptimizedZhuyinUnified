TWEAK_NAME = OptimizedZhuyinUnified
OptimizedZhuyinUnified_FILES = ../Tweak.xm ../KBDumper.mm
OptimizedZhuyinUnified_CFLAGS = -F$(SYSROOT)/System/Library/CoreServices -fobjc-arc
OptimizedZhuyinUnified_PRIVATE_FRAMEWORKS = UIKit Foundation

TARGET = simulator:clang
SDKVERSION = 10.2
SYSROOT = /opt/theos/sdks/iPhoneSimulator10.3.sdk

GO_EASY_ON_ME = 1
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

sync: stage
	cp .theos/_/Library/MobileSubstrate/DynamicLibraries/OptimizedZhuyinUnified.dylib /opt/simject/OptimizedZhuyinUnified.dylib
	ldid -S /opt/simject/OptimizedZhuyinUnified.dylib
	resim