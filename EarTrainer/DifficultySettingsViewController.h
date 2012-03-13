#import <UIKit/UIKit.h>

@interface DifficultySettingsViewController : UITableViewController

- (NSInteger)getDifficulty;
- (void)saveDifficulty:(NSInteger)difficulty;
@end