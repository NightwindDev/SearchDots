export SYSROOT = $(THEOS)/sdks/iPhoneOS14.4.sdk/
export TARGET := iphone:clang:latest:14.0
export ARCHS = arm64 arm64e

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = SearchDots

SearchDots_FILES = Tweak.xm
SearchDots_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += searchdotsprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
