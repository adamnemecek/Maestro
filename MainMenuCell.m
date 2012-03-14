#import "MainMenuCell.h"

@implementation MainMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width - 100, self.frame.size.height);
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
//    NSLog(@"cell tite: %@ selected? %i animated: %i", self.textLabel.text, selected, animated);
}

@end