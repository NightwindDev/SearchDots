@import UIKit;
#import "MTMaterialView.h"

#define spotlight 0
#define appLibrary 1

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
@end

@interface SBHIconManager : NSObject
@end

@interface SBWindowScene : UIWindowScene
@end

@interface SBFolderScrollAccessoryView : UIView
@property (nonatomic, strong) SBIconListPageControl *pageControl;
@end

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
@property (nonatomic, strong, readwrite) SBLibraryViewController *overlayLibraryViewController;
- (SBHIconManager *)iconManager;
- (SBWindowScene *)mainDisplayWindowScene;
+ (SBIconController *)sharedInstance;
- (SBLibraryViewController *)libraryViewController;
- (void)searchBarDidFocus;
- (void)dismissSearchView;
- (void)presentLibraryForIconManager:(SBHIconManager *)iconManager windowScene:(SBWindowScene *)windowScene animated:(BOOL)isAnimated; // iOS 16
- (BOOL)presentLibraryAnimated:(BOOL)animated completion:(id)completion; // iOS 15
- (void)presentLibraryOverlayForIconManager:(SBHIconManager *)iconManager; // iOS 14
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
@property (nonatomic, strong) SBFolderScrollAccessoryView *scrollAccessoryView;
@property (nonatomic, strong) SBIconListPageControl *pageControl;
- (void)setNewFrame;
@end

BOOL tweakEnabled;
NSInteger action;
CGFloat offset;
BOOL hideBackground;
BOOL onePageSupport;

CGFloat origYCoord;

