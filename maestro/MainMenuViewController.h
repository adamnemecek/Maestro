#import <UIKit/UIKit.h>

@class MainMenuViewController;

@protocol MainMenuViewControllerDelegate <NSObject>
-(void)mainMenu:(MainMenuViewController *)viewController didSelectViewController:(UIViewController *)selectedViewController;
-(void)mainMenuSelectedCurrentView:(MainMenuViewController *)viewController;
@end

@interface MainMenuViewController : UITableViewController

@property (nonatomic, weak) id <MainMenuViewControllerDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

-(void)deselect;

@end