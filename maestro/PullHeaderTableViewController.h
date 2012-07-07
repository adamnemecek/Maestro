#import <UIKit/UIKit.h>

#define HEADER_HEIGHT 55.0f

#define HEADER_SHOW_MARGIN_SCALAR 0.4f
#define HEADER_HIDE_MARGIN_SCALAR 0.8f

@interface PullHeaderTableViewController : UITableViewController

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic) BOOL makeHeader;
@property (nonatomic) BOOL isShowing;

-(void)setupStringForPull:(NSString *)pullString release:(NSString *)releaseString andShowing:(NSString *)showingString;                                                                

- (void)refreshHeader;

- (void)showHeader;
- (void)hideHeader;

- (void)enableCommonFunctionality;
- (void)disableCommonFunctionality;
@end