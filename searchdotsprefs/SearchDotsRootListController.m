#import <Foundation/Foundation.h>
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

	[super setPreferenceValue:value specifier:specifier];
}

@end
