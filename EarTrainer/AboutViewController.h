#import <UIKit/UIKit.h>
#import "PushOverlayView.h"
#import "MainMenuViewController.h"

@interface AboutViewController : UIViewController <PushOverlayViewDelegate, MainMenuViewControllerDelegate>

@property (strong, nonatomic) MainMenuViewController *mainMenu;
@property (nonatomic) BOOL menuShowing;

- (IBAction)openWebsite:(id)sender;
- (IBAction)contact:(id)sender;


-(void)showMenu:(id)sender;
@end