#import <UIKit/UIKit.h>
#import "TrainerModelViewController.h"

@class MainMenuViewController;

@interface IntervalTrainerViewController : TrainerModelViewController

@property (nonatomic, strong) MainMenuViewController *mainMenu;

- (IBAction)showMenu:(id)sender;
@end