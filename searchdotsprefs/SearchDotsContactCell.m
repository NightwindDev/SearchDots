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