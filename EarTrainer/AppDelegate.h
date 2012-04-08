#import <UIKit/UIKit.h>
#import "Tip.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, TipDelegate>

@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) IBOutlet UIWindow *window;

@end
