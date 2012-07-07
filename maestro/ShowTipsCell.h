#import <UIKit/UIKit.h>

@interface ShowTipsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *showTipsSwitch;
@property (weak, nonatomic) IBOutlet UILabel *label;

- (IBAction)showSwitched:(id)sender;
+(NSString *)nibName;
+(NSString *)reuseIdentifier;
@end