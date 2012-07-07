#import <UIKit/UIKit.h>

void uncaughtExceptionHandler(NSException *exception);

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) IBOutlet UIWindow *window;

@end
