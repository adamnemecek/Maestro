#import "ShowTipsCell.h"
#import "Defaults.h"

@implementation ShowTipsCell

@synthesize showTipsSwitch;
@synthesize label;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}

- (IBAction)showSwitched:(id)sender {
    [[Defaults sharedInstance] saveShowTips:showTipsSwitch.on];
}

+ (NSString *)nibName {
    return @"ShowTipsCell";
}

+ (NSString *)reuseIdentifier {
    return @"ShowTipsCell";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end