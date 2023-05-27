@interface MTMaterialView : UIView
@property (nonatomic,copy) NSString *groupName;
@property (assign,nonatomic) BOOL allowsInPlaceFiltering;

+(MTMaterialView *)materialViewWithRecipe:(NSInteger)recipe options:(NSUInteger)options;
@end