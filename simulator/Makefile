TWEAK_NAME = OptimizedZhuyin
OptimizedZhuyin_OBJCC_FILES = ../Tweak.xm
OptimizedZhuyin_CFLAGS = -F$(SYSROOT)/System/Library/CoreServices -fobjc-arc
OptimizedZhuyin_PRIVATE_FRAMEWORKS = UIKit Foundation

TARGET = simulator:clang
SDKVERSION = 10.2
SYSROOT = /opt/theos/sdks/iPhoneSimulator10.3.sdk

OptimizedZhuyin_LDFLAGS += -Wl,-segalign,4000
GO_EASY_ON_ME = 1
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

sync: stage
	cp .theos/_/Library/MobileSubstrate/DynamicLibraries/OptimizedZhuyin.dylib /opt/simject/OptimizedZhuyin.dylib
	ldid -S /opt/simject/OptimizedZhuyin.dylib
	respring_simulator