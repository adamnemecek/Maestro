#import "MainMenuCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation MainMenuCell
@synthesize viewTitle;

- (void)awakeFromNib {
//    self.layer.masksToBounds = YES;
//    self.layer.cornerRadius = 5.0f;
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