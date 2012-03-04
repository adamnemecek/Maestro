#import <UIKit/UIKit.h>
#import "MainMenuViewController.h"
#import "SettingsViewController.h"

@interface ContainerViewController : UITableViewController <MainMenuViewControllerDelegate, SettingsViewControllerDelegate>

@property (strong, nonatomic) MainMenuViewController *mainMenu;

-(void)showMenu:(id)sender;
-(void)showSettings:(id)sender;
@end