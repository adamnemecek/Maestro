#import "AppDelegate.h"
#import "SoundEngine.h"
#import "Tip.h"
#import "IntervalTrainerViewController.h"

@implementation AppDelegate {
    BOOL showFirstTimeTip;
    CFTimeInterval leaveTime;
}

@synthesize navController = _navController;
@synthesize window = _window;

#pragma mark - Tips
- (void)loadTip {
    if (![[Defaults sharedInstance] getShowTips]) return;
    Tip *currentTip = (Tip *)[_window viewWithTag:kTipTag]; // Get the tip if there is one
    if (currentTip == nil) {
        // If this is the first time we entered the app open the first tip, otherwise grab a random one
        (showFirstTimeTip) ? [[Tip tipAtIndex:0] run]  : [[Tip randomTip] run];
    } else {
        [currentTip resetTipInfo];
    }
    if (showFirstTimeTip) showFirstTimeTip = NO;
}

#pragma mark Exception handler
void uncaughtExceptionHandler(NSException *exception) {
    [FlurryAnalytics logError:@"Uncaught" message:@"Crash!" exception:exception];
}

#pragma mark - Application cycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    [FlurryAnalytics startSession:@"5RQGEC439LBCUI8FHFV9"];
    
    if (![[Defaults sharedInstance] getHereBefore]) {
        showFirstTimeTip = YES;
        [[Defaults sharedInstance] initialDefaults];
    }
    
    [[UINavigationBar appearance] setTintColor:[UIColor brownColor]];
    [[UIToolbar appearance] setTintColor:[UIColor brownColor]];
    
    IntervalTrainerViewController *intTrainerViewController = [[IntervalTrainerViewController alloc] initWithStyle:UITableViewStylePlain];
    _navController = [[UINavigationController alloc] initWithRootViewController:intTrainerViewController];
    
    _window.rootViewController = _navController;
    [_window makeKeyAndVisible];
    
    [self loadTip];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    [[SoundEngine sharedInstance] endAudioSession];
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    leaveTime = CACurrentMediaTime();
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // If we have left the app for 25 seconds or longer than load a tip when we come back on
    CFTimeInterval timeNow = CACurrentMediaTime();
    if ((int)(timeNow - leaveTime) >= 25) {
        // Only load tips in trainer view controllers
        if ([_navController.visibleViewController isKindOfClass:[TrainerModelViewController class]])
            // Make sure the menu isn't showing
            if (!((ContainerViewController *) _navController.visibleViewController).menuShowing)
                [self loadTip];
    }
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[SoundEngine sharedInstance] startAudioSession];
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}
@end