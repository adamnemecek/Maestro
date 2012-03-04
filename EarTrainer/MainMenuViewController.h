#import <UIKit/UIKit.h>

@class MainMenuViewController;

@protocol MainMenuViewControllerDelegate <NSObject>
-(void)MainMenu:(MainMenuViewController *)viewController didSelectViewController:(UIViewController *)selectedViewController;
@end

@interface MainMenuViewController : UITableViewController

@property(nonatomic, weak) id <MainMenuViewControllerDelegate> delegate;

@end