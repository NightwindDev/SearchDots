@interface MTMaterialView : UIView
@property (nonatomic, assign, readwrite) BOOL captureOnly;
+ (MTMaterialView *)materialViewWithRecipe:(NSInteger)recipe options:(NSUInteger)options;
@end