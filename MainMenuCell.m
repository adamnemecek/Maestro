#import "MainMenuCell.h"

@implementation MainMenuCell
@synthesize viewTitle;

- (void)awakeFromNib {
}

+ (NSString *)nibName {
    return @"MainMenuCell";
}

+ (NSString *)reuseIdentifier {
    return @"MainMenuCell";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end