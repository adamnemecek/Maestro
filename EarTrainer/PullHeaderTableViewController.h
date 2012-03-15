#import <UIKit/UIKit.h>

#define HEADER_HEIGHT 102.0f

@interface PullHeaderTableViewController : UITableViewController

@property (nonatomic, strong) UILabel *statsLabel;

- (void)showStats;
- (void)hideStats;
@end