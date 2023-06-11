@interface MTMaterialView : UIView
@property (nonatomic, assign, readwrite) BOOL captureOnly;
+ (MTMaterialView *)materialViewWithRecipe:(NSInteger)recipe options:(NSUInteger)options;
+ (MTMaterialView *)materialViewWithRecipe:(NSInteger)recipe configuration:(NSInteger)configuration;
- (void)setRecipe:(NSInteger)recipe;
@end