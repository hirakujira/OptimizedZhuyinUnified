TWEAK_NAME = OptimizedZhuyin5
OptimizedZhuyin5_OBJCC_FILES = Tweak.xm
OptimizedZhuyin5_FRAMEWORKS = UIKit Foundation 
OptimizedZhuyin5_PRIVATE_FRAMEWORKS = UIKit Foundation TextInput
OptimizedZhuyin5_CFLAGS = -F$(SYSROOT)/System/Library/CoreServices -fobjc-arc

ARCHS = armv7
TARGET=:clang::5.0
GO_EASY_ON_ME = 1
FINALPACKAGE = 1

SUBPROJECTS += Preferences
include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk

sync: stage
	rsync -e "ssh -p 2222" -z $(THEOS_STAGING_DIR)/Library/MobileSubstrate/DynamicLibraries/* root@127.0.0.1:/Library/MobileSubstrate/DynamicLibraries/
	ssh root@127.0.0.1 -p 2222 killall MobileNotes
	ssh root@127.0.0.1 -p 2222 open com.apple.mobilenotes

after-install::
	install.exec "killall -9 MobileSafari"