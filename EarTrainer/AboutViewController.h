#import <UIKit/UIKit.h>
#import "PushOverlayView.h"
#import "MainMenuViewController.h"

@interface AboutViewController : UIViewController <PushOverlayViewDelegate, MainMenuViewControllerDelegate>

@property (strong, nonatomic) MainMenuViewController *mainMenu;

- (IBAction)openWebsite:(id)sender;

-(void)showMenu:(id)sender;
@end