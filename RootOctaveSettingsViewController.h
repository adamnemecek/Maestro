#import <UIKit/UIKit.h>

@interface RootOctaveSettingsViewController : UITableViewController

@property (nonatomic, strong) NSArray *octaves;
@property (nonatomic, strong) NSIndexPath *currentCellPath;

-(NSInteger)getOctaveSelection;
-(BOOL)checkOctave:(NSInteger)octaveIndex;
-(void)saveOctaveSelection:(NSInteger)selection;

@end