#import "ShowTipsCell.h"

@implementation ShowTipsCell

@synthesize showTipsSwitch;
@synthesize label;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    return self;
}

- (IBAction)showSwitched:(id)sender {
    [[Defaults sharedInstance] saveShowTips:showTipsSwitch.on];
    if (showTipsSwitch.on) {
        [FlurryAnalytics logEvent:@"Showing tips" withParameters:[NSDictionary dictionaryWithObject:@"Showing" forKey:@"ShowingTips"]];
    } else {
        [FlurryAnalytics logEvent:@"Showing tips" withParameters:[NSDictionary dictionaryWithObject:@"Not showing" forKey:@"ShowingTips"]];
    }
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