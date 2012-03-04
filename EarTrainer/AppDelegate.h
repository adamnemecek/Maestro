#import <UIKit/UIKit.h>

@class ContainerViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) ContainerViewController *containerViewController;
@property (strong, nonatomic) IBOutlet UIWindow *window;

@end
