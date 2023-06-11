#import "SearchDotsRootListController.h"

@implementation SearchDotsRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)open:(PSSpecifier *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[sender propertyForKey:@"url"]] options:@{} completionHandler:nil];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
	NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.nightwind.searchdotsprefs"];
	[prefs setValue:value forKey:specifier.properties[@"key"]];

	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"tweakEnableStateChanged" object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"actionStateChanged" object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"offsetStateChanged" object:nil];
	[NSDistributedNotificationCenter.defaultCenter postNotificationName:@"hideBackgroundStateChanged" object:nil];

	[super setPreferenceValue:value specifier:specifier];
}

- (void)respring {
	UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
	UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blur];
	blurView.frame = self.view.bounds;
	blurView.alpha = 0;
	[self.view addSubview:blurView];

	[UIView animateWithDuration:0.50 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		[blurView setAlpha:1.0];
	} completion:^(BOOL finished) {
		[self.view endEditing:YES];
		[self respringUtil];
	}];
}

- (void)respringUtil {
    extern char **environ;
    pid_t pid;

	const char *args[] = {"killall", "backboardd", NULL};
	posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char *const *)args, environ);
}

@end
