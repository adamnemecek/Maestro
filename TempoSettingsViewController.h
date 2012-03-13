#import <UIKit/UIKit.h>

@interface TempoSettingsViewController : UITableViewController

- (NSInteger)getTempo;
- (void)saveTempo:(NSInteger)tempo;

@end