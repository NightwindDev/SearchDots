#import "SearchDotsBannerCell.h"

NSString *getVersion() {
    return PACKAGE_VERSION;
}

@implementation SearchDotsBannerCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:style reuseIdentifier:identifier specifier:specifier];

    if (self) {
        self.userInteractionEnabled = false;

        UILabel *tweakTitle = [UILabel new];
        tweakTitle.text = [specifier propertyForKey:@"tweakTitle"];
        tweakTitle.font = [UIFont boldSystemFontOfSize:40];
        tweakTitle.textAlignment = NSTextAlignmentCenter;
        tweakTitle.translatesAutoresizingMaskIntoConstraints = false;
        [self.contentView addSubview:tweakTitle];

        [NSLayoutConstraint activateConstraints:@[
            [tweakTitle.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor],
            [tweakTitle.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor constant: 20],
            [tweakTitle.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
        ]];

        UIImage *image = [UIImage imageNamed:@"icon@3.png" inBundle:[NSBundle bundleForClass:self.class] compatibleWithTraitCollection:nil];

        UIImageView *tweakIconImageView = [[UIImageView alloc] initWithImage:image];
        tweakIconImageView.layer.masksToBounds = true;
        tweakIconImageView.layer.cornerRadius = 10.0f;
        tweakIconImageView.translatesAutoresizingMaskIntoConstraints = false;
        [self.contentView addSubview: tweakIconImageView];

        [NSLayoutConstraint activateConstraints:@[
            [tweakIconImageView.widthAnchor constraintEqualToConstant: 70],
            [tweakIconImageView.heightAnchor constraintEqualToConstant: 70],
            [tweakIconImageView.bottomAnchor constraintEqualToAnchor:tweakTitle.topAnchor constant: -10],
            [tweakIconImageView.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
        ]];

        UILabel *versionSubtitle = [UILabel new];
        versionSubtitle.text = getVersion();
        versionSubtitle.textColor = UIColor.secondaryLabelColor;
        versionSubtitle.font = [UIFont boldSystemFontOfSize:30];
        versionSubtitle.textAlignment = NSTextAlignmentCenter;
        versionSubtitle.translatesAutoresizingMaskIntoConstraints = false;
        [self.contentView addSubview:versionSubtitle];

        [NSLayoutConstraint activateConstraints:@[
            [versionSubtitle.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor],
            [versionSubtitle.topAnchor constraintEqualToAnchor:tweakTitle.bottomAnchor constant: 5],
            [versionSubtitle.centerXAnchor constraintEqualToAnchor:self.contentView.centerXAnchor],
        ]];

    }

    return self;
}

@end