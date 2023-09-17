#import "Tweak.h"

BOOL pillWasAdded = false;

static void loadWithoutRespring() {
	NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.nightwind.searchdotsprefs"];

	tweakEnabled = [prefs objectForKey:@"tweakEnabled"] ? [prefs boolForKey:@"tweakEnabled"] : true;
	action = [prefs objectForKey:@"action"] ? [prefs integerForKey:@"action"] : 0;
	offset = [prefs objectForKey:@"yOffset"] ? [prefs floatForKey:@"yOffset"] : 0;
	hideBackground = [prefs objectForKey:@"hideBackground"] ? [prefs boolForKey:@"hideBackground"] : false;
	onePageSupport = [prefs objectForKey:@"onePageSupport"] ? [prefs boolForKey:@"onePageSupport"] : false;
}

NSString *localizedTextForiOS14And15(NSInteger action, NSString *languageCode) {
	NSString *filePath = nil;
	NSDictionary *dict = nil;
	NSString *localizedString = nil;

	if (action == spotlight) {
		filePath = [NSString stringWithFormat:@"/System/Library/PrivateFrameworks/UIKitCore.framework/%@.lproj/Localizable.strings", languageCode];
		dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
		localizedString = [dict objectForKey:@"Search"];
	} else if (action == appLibrary) {
		filePath = [NSString stringWithFormat:@"/System/Library/PrivateFrameworks/SpringBoardHome.framework/%@.lproj/SpringBoardHome.strings", languageCode];
		dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
		localizedString = [dict objectForKey:@"APP_LIBRARY_SEARCH_PLACEHOLDER"];
	}

	return localizedString;
}

NSString *localizedTextForiOS16(NSInteger action, NSString *languageCode) {
	NSString *localizedString = nil;

	if (action == spotlight) {
		NSBundle *frameworkBundle = [NSBundle bundleWithPath:@"/System/Library/PrivateFrameworks/SpotlightUIInternal.framework/"];
		localizedString = NSLocalizedStringWithDefaultValue(@"SEARCH_BAR_PLACEHOLDER", nil, frameworkBundle, @"Search", @"");
	} else if (action == appLibrary) {
		NSString *filePath = @"/System/Library/PrivateFrameworks/SpringBoardHome.framework/SpringBoardHome.loctable";
		NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
		NSDictionary *localeDict = [dict objectForKey:languageCode];
		localizedString = [localeDict objectForKey:@"APP_LIBRARY_SEARCH_PLACEHOLDER"];
	}

	return localizedString;
}

NSString *localizedSearchText(NSInteger action) {
    NSString *const languageCode = NSLocale.currentLocale.languageCode;
    NSDictionary *const chineseLanguageMap = @{
        @"CN": @"zh_CN",
        @"HK": @"zh_HK",
        @"TW": @"zh_TW"
    };

	if ([languageCode hasPrefix:@"zh"]) {
		NSString *regionCode = NSLocale.currentLocale.countryCode;
		NSString *chineseLanguageCode = chineseLanguageMap[regionCode] ? chineseLanguageMap[regionCode] : @"zh_CN";

		if (@available(iOS 16, *)) {
			return localizedTextForiOS16(action, chineseLanguageCode);
		} else {
			return localizedTextForiOS14And15(action, chineseLanguageCode);
		}
	} else {
		if (@available(iOS 16, *)) {
			return localizedTextForiOS16(action, languageCode);
		} else {
			return localizedTextForiOS14And15(action, languageCode);
		}
	}
}

// for iOS 16
// https://stackoverflow.com/questions/11770743/capturing-touches-on-a-subview-outside-the-frame-of-its-superview-using-hittest
%hook SBFolderScrollAccessoryView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

    if (self.clipsToBounds || self.hidden || self.alpha == 0) return nil;

    for (UIView *subview in self.subviews.reverseObjectEnumerator) {
        CGPoint subPoint = [subview convertPoint:point fromView:self];
        UIView *result = [subview hitTest:subPoint withEvent:event];

        if (result) {
            return result;
        }
    }

    return nil;
}

%end

// TAKEN FROM ATRIA
%hook SBRootFolderView

%new
- (void)setNewFrame {
	loadWithoutRespring();

	UIView *view = nil;

	if (@available(iOS 16, *)) view = self.scrollAccessoryView;
	else view = self.pageControl;

	CGRect newFrame = view.frame;

	if (tweakEnabled) {
		newFrame.origin.y = origYCoord + offset;
	} else {
		newFrame.origin.y = origYCoord;
	}

	view.frame = newFrame;
}

- (void)layoutPageControlWithMetrics:(const struct SBRootFolderViewMetrics *)metrics {
    %orig;

	// if (tweakEnabled) {
		UIView *view = nil;

		if (@available(iOS 16, *)) view = self.scrollAccessoryView;
		else view = self.pageControl;

		origYCoord = view.frame.origin.y;

		[self setNewFrame];
	// }

	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(setNewFrame) name:@"tweakEnableStateChanged" object:nil];
}

- (void)_updateDockOffscreenFractionWithMetrics:(const struct SBRootFolderViewMetrics *)metrics {
	%orig;

	// if (tweakEnabled) {
		[self setNewFrame];
	// }

	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(setNewFrame) name:@"tweakEnableStateChanged" object:nil];
}

%end

%hook _UIPageControlContentView

%new
- (void)newLayout {
	loadWithoutRespring();

	for (UIView *subview in self.subviews) {
		if (tweakEnabled) {
			subview.hidden = true;
		} else {
			subview.hidden = false;
		}
	}
}

- (void)layoutSubviews {
	%orig;

	if ([[self _viewControllerForAncestor] isKindOfClass:%c(SBRootFolderController)]) {
		[self newLayout];

		[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(newLayout) name:@"tweakEnableStateChanged" object:nil];
	}
}

%end


// * ACTUAL SEARCH BUTTON * //

%hook SBIconListPageControl
%property (nonatomic, strong) UIImageView *searchIcon;
%property (nonatomic, strong) UILabel *searchLabel;
%property (nonatomic, strong) MTMaterialView *blurView;

%new
- (void)newTapGesture:(id)gestureRecognizer {
    loadWithoutRespring();

    if (tweakEnabled == true && [gestureRecognizer isKindOfClass:%c(UITapGestureRecognizer)]) {
        SBIconController *iconController = [%c(SBIconController) sharedInstance];

        if (action == spotlight) {
            [iconController searchBarDidFocus];
        }

        if (action == appLibrary) {
			if (@available(iOS 16, *)) {
				SBLibraryViewController *appLibraryViewController = [iconController overlayLibraryViewController];
				[iconController presentLibraryForIconManager:[iconController iconManager] windowScene:[iconController mainDisplayWindowScene] animated:true];
				[[appLibraryViewController containerViewController] setActive:true];
			} else if (@available(iOS 15, *)) {
				SBLibraryViewController *appLibraryViewController = [iconController libraryViewController];
				[iconController presentLibraryAnimated:true completion:nil];
				[[appLibraryViewController containerViewController] setActive:true];
			} else {
				[iconController presentLibraryOverlayForIconManager:nil];
			}
        }
    }
}

- (void)tapGestureDidUpdate:(id)arg1 {
    if (!(MSHookIvar<BOOL>([self _viewControllerForAncestor], "_isEditing"))) {
        [self newTapGesture:arg1];
    } else {
        %orig;
    }
}

- (void)didMoveToWindow {
    %orig;

	if ([[self _viewControllerForAncestor] isKindOfClass:%c(SBRootFolderController)]) {
		[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(newActsAsButton) name:@"tweakEnableStateChanged" object:nil];
		[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(newTapGesture:) name:@"tweakEnableStateChanged" object:nil];
		[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(newTapGesture:) name:@"actionStateChanged" object:nil];
	}
}

%new
- (BOOL)newActsAsButton {
	loadWithoutRespring();

	if (tweakEnabled == true) {
		return true;
	} else {
		return false;
	}
}

- (BOOL)actsAsButton {
	if ([[self _viewControllerForAncestor] isKindOfClass:%c(SBRootFolderController)]) {
		if ([self newActsAsButton]) {
			return true;
		} else {
			return %orig;
		}
	} else return %orig;
}

- (void)setHidesForSinglePage:(BOOL)hides {
	if ([[self _viewControllerForAncestor] isKindOfClass:%c(SBRootFolderController)]) {
		if (tweakEnabled) {
			%orig(onePageSupport ? false : true);
		} else %orig;
	} else %orig;
}

%new
- (void)addSearchPill {
	loadWithoutRespring();

	self.searchLabel.text = localizedSearchText(action);

	self.blurView.captureOnly = hideBackground ? true : false;

	if (tweakEnabled == true && !pillWasAdded) {
		if (@available(iOS 15, *)) {
			self.blurView = [%c(MTMaterialView) materialViewWithRecipe:19 options:2];
		} else {
			self.blurView = [%c(MTMaterialView) materialViewWithRecipe:19 configuration:1];
		}

		self.blurView.layer.cornerRadius = 17.5;
		self.blurView.layer.continuousCorners = true;
		self.blurView.translatesAutoresizingMaskIntoConstraints = false;
		self.blurView.captureOnly = hideBackground ? true : false;
		[self addSubview:self.blurView];

		self.searchIcon = [UIImageView new];
		self.searchIcon.image = [UIImage systemImageNamed:@"magnifyingglass"];
		self.searchIcon.contentMode = UIViewContentModeScaleAspectFit;
		self.searchIcon.tintColor = UIColor.whiteColor;
		self.searchIcon.translatesAutoresizingMaskIntoConstraints = false;
		self.searchIcon.alpha = 0.8;
		[self.blurView insertSubview:self.searchIcon atIndex:0];

		self.searchLabel = [UILabel new];
		self.searchLabel.textColor = UIColor.whiteColor;
		self.searchLabel.text = localizedSearchText(action);
		self.searchLabel.translatesAutoresizingMaskIntoConstraints = false;
		self.searchLabel.alpha = 0.8;
		self.searchLabel.font = [UIFont systemFontOfSize:14];
		[self.blurView insertSubview:self.searchLabel atIndex:1];

		pillWasAdded = true;
	}

	if (!tweakEnabled) {
		self.blurView.alpha = 0;
		self.blurView.hidden = true;
	} else {
		self.blurView.alpha = 1;
		self.blurView.hidden = false;
	}
}

- (void)didMoveToSuperview {
	%orig;

	[self addSearchPill];

	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(newActsAsButton) name:@"tweakEnableStateChanged" object:nil];
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(addSearchPill) name:@"tweakEnableStateChanged" object:nil];
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(addSearchPill) name:@"actionStateChanged" object:nil];
	[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(addSearchPill) name:@"hideBackgroundStateChanged" object:nil];
}

%new
- (void)newLayout {
	loadWithoutRespring();

	if (tweakEnabled == true) {
		UIView *contentView = self.subviews[0];

		[self.blurView.centerXAnchor constraintEqualToAnchor:contentView.centerXAnchor].active = YES;
		[self.blurView.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor].active = YES;
		[self.blurView.heightAnchor constraintEqualToConstant:35].active = YES;

		[self.searchIcon.widthAnchor constraintEqualToConstant:13].active = YES;
		[self.searchIcon.centerYAnchor constraintEqualToAnchor:self.blurView.centerYAnchor].active = YES;
		[self.searchIcon.leadingAnchor constraintEqualToAnchor:self.blurView.leadingAnchor constant:13].active = YES;

		[self.searchLabel.centerYAnchor constraintEqualToAnchor:self.blurView.centerYAnchor].active = YES;
		[self.searchLabel.leadingAnchor constraintEqualToAnchor:self.searchIcon.trailingAnchor constant:4].active = YES;

		[self.blurView.widthAnchor constraintEqualToAnchor:self.searchLabel.widthAnchor constant:45].active = YES;

		[self.blurView layoutIfNeeded];

		if (@available(iOS 16, *)) {
			self.translatesAutoresizingMaskIntoConstraints = false;

			[self.centerXAnchor constraintEqualToAnchor:self.superview.centerXAnchor].active = true;
			[self.widthAnchor constraintEqualToAnchor:self.blurView.widthAnchor].active = true;
			[self.heightAnchor constraintEqualToAnchor:self.blurView.heightAnchor].active = true;
		}
	}
}

- (void)layoutSubviews {
    %orig;

	if ([[self _viewControllerForAncestor] isKindOfClass:%c(SBRootFolderController)]) {

		[self setCurrentPageIndicatorTintColor:[UIColor labelColor]];

		[self newLayout];

		[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(newActsAsButton) name:@"tweakEnableStateChanged" object:nil];
		[NSDistributedNotificationCenter.defaultCenter addObserver:self selector:@selector(newLayout) name:@"tweakEnableStateChanged" object:nil];

	}
}


%end

%ctor {

	loadWithoutRespring();

}