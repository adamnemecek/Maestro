#import <UIKit/UIKit.h>

@interface PlaymodeSettingsViewController : UITableViewController

- (NSInteger)getPlaymode;
- (void)savePlaymode:(NSInteger)playmode;
@end