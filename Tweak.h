@import UIKit;
#import "MTMaterialView.h"

#define spotlight 0
#define appLibrary 1

@interface UIView (SearchDots)
- (UIViewController *)_viewControllerForAncestor;
@end

@interface UIGestureRecognizerTarget : NSObject
@property (nonatomic, readwrite) SEL action;
@end

@interface NSDistributedNotificationCenter : NSNotificationCenter
+ (instancetype)defaultCenter;
@end

@interface SBHLibrarySearchController : UIViewController
- (void)setActive:(BOOL)active;
@end

@interface SBLibraryViewController : UIViewController
- (SBHLibrarySearchController *)containerViewController;
@end

@interface SBIconController : UIViewController
+ (SBIconController *)sharedInstance;
- (BOOL)presentLibraryAnimated:(BOOL)animated completion:(id)completion;
- (SBLibraryViewController *)libraryViewController;
- (void)searchBarDidFocus;
- (void)dismissSearchView;
@end

@interface SBIconListPageControl : UIView
@property (nonatomic, strong) UIImageView *searchIcon;
@property (nonatomic, strong) UILabel *searchLabel;
@property (nonatomic, strong) MTMaterialView *blurView;
- (void)newTapGesture:(id)gestureRecognizer;
- (BOOL)newActsAsButton;
- (void)addSearchPill;
- (void)newLayout;
- (void)setActsAsButton:(BOOL)actsAsButton;
- (void)setCurrentPageIndicatorTintColor:(UIColor *)tintColor;
// - (void)notificationReceived:(NSNotification *)notification;
@end

@interface _UIPageControlContentView : UIView
- (void)newLayout;
@end

@interface CALayer (SearchDots)
@property (atomic, assign, readwrite) BOOL continuousCorners;
@end

@interface SBFolderContainerView : UIView
@end

typedef struct SBRootFolderViewMetrics {
    struct CGRect _field1;
    struct CGRect _field2;
    struct CGRect _field3;
    struct CGRect _field4;
    struct CGRect _field5;
    struct CGRect _field6;
    struct CGRect _field7;
    double _field8;
    struct CGRect _field9;
    struct CGRect _field10;
    struct CGRect _field11;
} SBRootFolderViewMetrics;

@interface SBRootFolderView : UIView
@property (nonatomic, strong) SBIconListPageControl *pageControl;
- (void)setNewFrame;
@end

BOOL tweakEnabled;
NSInteger action;
CGFloat offset;
BOOL hideBackground;

CGFloat origYCoord;

