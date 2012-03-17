#import <UIKit/UIKit.h>
#import "PullHeaderTableViewController.h"
#import "PushOverlayView.h"
#import "MainMenuViewController.h"
#import "SettingsViewController.h"

@interface ContainerViewController : PullHeaderTableViewController <PushOverlayViewDelegate, MainMenuViewControllerDelegate, SettingsViewControllerDelegate>

@property (strong, nonatomic) MainMenuViewController *mainMenu;

-(void)showMenu:(id)sender;
-(void)showSettings:(id)sender;
@end