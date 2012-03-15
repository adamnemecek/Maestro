#import <UIKit/UIKit.h>

#define HEADER_HEIGHT 70.0f

#define HEADER_SHOW_MARGIN_SCALAR 0.8f
#define HEADER_HIDE_MARGIN_SCALAR 0.8f

@interface PullHeaderTableViewController : UITableViewController

@property (nonatomic, strong) UILabel *statsLabel;
@property (nonatomic) BOOL makeHeader;
@property (nonatomic) BOOL isShowing;

- (void)showStats;
- (void)hideStats;

- (void)enableCommonFunctionality;
- (void)disableCommonFunctionality;
@end