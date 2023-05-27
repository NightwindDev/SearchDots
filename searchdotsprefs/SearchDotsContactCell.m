#import "SearchDotsContactCell.h"

@implementation SearchDotsContactCell {
    UIImageView *leftImageView;
    UILabel *usernameLabel;
    UILabel *handleLabel;
    BOOL subviewsAdded;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];

    if (self) {
        // self.translatesAutoresizingMaskIntoConstraints = false;

        UIImage *image = [UIImage imageNamed:[specifier propertyForKey:@"image"] inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];

        leftImageView = [[UIImageView alloc] initWithImage:image];
        leftImageView.layer.masksToBounds = true;
        leftImageView.layer.cornerRadius = 10.0f;
        leftImageView.translatesAutoresizingMaskIntoConstraints = false;
        [[self contentView] addSubview: leftImageView];

        usernameLabel = [UILabel new];
        usernameLabel.text = [specifier propertyForKey:@"titleLabel"];
        usernameLabel.font = [UIFont boldSystemFontOfSize:15];
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false;
        [[self contentView] addSubview:usernameLabel];

        handleLabel = [UILabel new];
        handleLabel.text = [specifier propertyForKey:@"bottomLabel"];
        handleLabel.textColor = UIColor.secondaryLabelColor;
        handleLabel.font = [UIFont systemFontOfSize:11];
        handleLabel.translatesAutoresizingMaskIntoConstraints = false;
        [[self contentView] addSubview:handleLabel];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [NSLayoutConstraint activateConstraints:@[
        [leftImageView.centerYAnchor constraintEqualToAnchor:self.centerYAnchor],
        [leftImageView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:15],
        [leftImageView.heightAnchor constraintEqualToConstant:40],
        [leftImageView.widthAnchor constraintEqualToConstant:40],

        [usernameLabel.topAnchor constraintEqualToAnchor:self.centerYAnchor constant: -18],
        [usernameLabel.leadingAnchor constraintEqualToAnchor:leftImageView.trailingAnchor constant:10],
        [usernameLabel.heightAnchor constraintEqualToConstant:20],

        [handleLabel.bottomAnchor constraintEqualToAnchor:self.centerYAnchor constant: 18],
        [handleLabel.leadingAnchor constraintEqualToAnchor:leftImageView.trailingAnchor constant:10],
        [handleLabel.heightAnchor constraintEqualToConstant:20],
    ]];
}

@end
// NSString *getVersion() {
//     return strct(PACKAGE_VERSION, @" Prerelease");
// }

// @implementation SearchDotsContactCell

// -(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
//     self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];

//     if (self) {
//         self.userInteractionEnabled = false;

//         UILabel *tweakTitle = [UILabel new];
//         tweakTitle.text = [specifier propertyForKey:@"tweakTitle"];
//         tweakTitle.font = [UIFont boldSystemFontOfSize:40];
//         tweakTitle.textAlignment = NSTextAlignmentCenter;
//         tweakTitle.translatesAutoresizingMaskIntoConstraints = false;
//         [self.contentView addSubview:tweakTitle];

//         [NSLayoutConstraint activateConstraints:@[
//             [tweakTitle.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor],
//             [tweakTitle.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor constant: 20],
//             [tweakTitle.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
//         ]];

//         UIImage *searchImage = [[UIImage systemImageNamed:@"magnifyingglass"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//         UIImageView *searchImageView = [[UIImageView alloc] initWithImage:searchImage];
//         searchImageView.tintColor = UIColor.labelColor;
//         searchImageView.translatesAutoresizingMaskIntoConstraints = false;
//         [self.contentView addSubview:searchImageView];

//         [NSLayoutConstraint activateConstraints:@[
//             [searchImageView.widthAnchor constraintEqualToConstant: 30],
//             [searchImageView.heightAnchor constraintEqualToConstant: 30],
//             [searchImageView.bottomAnchor constraintEqualToAnchor:tweakTitle.topAnchor constant: -15],
//             [searchImageView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor constant: -20],
//         ]];


//         UIImage *accImage = [[UIImage systemImageNamed:@"person.crop.circle.fill"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//         UIImageView *accImageView = [[UIImageView alloc] initWithImage:accImage];
//         accImageView.translatesAutoresizingMaskIntoConstraints = false;
//         [self.contentView addSubview:accImageView];

//         [NSLayoutConstraint activateConstraints:@[
//             [accImageView.widthAnchor constraintEqualToConstant: 50],
//             [accImageView.heightAnchor constraintEqualToConstant: 50],
//             [accImageView.centerYAnchor constraintEqualToAnchor:searchImageView.centerYAnchor],
//             [accImageView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor constant: 20],
//         ]];


//         UILabel *versionSubtitle = [UILabel new];
//         versionSubtitle.text = getVersion();
//         versionSubtitle.textColor = UIColor.secondaryLabelColor;
//         versionSubtitle.font = [UIFont boldSystemFontOfSize:30];
//         versionSubtitle.textAlignment = NSTextAlignmentCenter;
//         versionSubtitle.translatesAutoresizingMaskIntoConstraints = false;
//         [self.contentView addSubview:versionSubtitle];

//         [NSLayoutConstraint activateConstraints:@[
//             [versionSubtitle.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor],
//             [versionSubtitle.topAnchor constraintEqualToAnchor:tweakTitle.bottomAnchor constant: 5],
//             [versionSubtitle.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
//         ]];

//     }

//     return self;
// }

// @end