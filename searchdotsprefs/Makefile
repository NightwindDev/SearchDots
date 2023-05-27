TARGET := iphone:clang:latest:14.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = SearchDotsPrefs

SearchDotsPrefs_FILES = SearchDotsRootListController.m SearchDotsBannerCell.m SearchDotsContactCell.m
SearchDotsPrefs_FRAMEWORKS = UIKit
SearchDotsPrefs_PRIVATE_FRAMEWORKS = Preferences
SearchDotsPrefs_INSTALL_PATH = /Library/PreferenceBundles
SearchDotsPrefs_CFLAGS = -fobjc-arc -DPACKAGE_VERSION='@"$(THEOS_PACKAGE_BASE_VERSION)"'

include $(THEOS_MAKE_PATH)/bundle.mk
