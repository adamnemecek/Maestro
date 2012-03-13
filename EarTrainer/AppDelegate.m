#import "AppDelegate.h"
#import "Defaults.h"
#import "SoundEngine.h"
#import "IntervalTrainerViewController.h"

@implementation AppDelegate

@synthesize navController = _navController;
@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (![[Defaults sharedInstance] getHereBefore]) [[Defaults sharedInstance] initialDefaults];
    
    [[UINavigationBar appearance] setTintColor:[UIColor brownColor]];
    [[UIToolbar appearance] setTintColor:[UIColor brownColor]];
//    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], UITextAttributeTextColor, nil]];
//    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], UITextAttributeTextColor, nil]
//                                                forState:UIControlStateNormal];
    
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_texture_wood"] forBarMetrics:UIBarMetricsDefault];
//    [[UIToolbar appearance] setBackgroundImage:[UIImage imageNamed:@"tool_texture_wood"]
//                            forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
//    
//    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                          [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
//                                                          UITextAttributeTextColor,
//                                                          [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],
//                                                          UITextAttributeTextShadowColor,
//                                                          [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
//                                                          UITextAttributeTextShadowOffset,
//                                                          [UIFont fontWithName:@"Arial-Bold" size:0.0],
//                                                          UITextAttributeFont,
//                                                          nil]];
    
//    [[UIBarButtonItem appearance] setBackgroundImage:button30 forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [[UIBarButtonItem appearance] setBackgroundImage:button24 forState:UIControlStateNormal barMetrics:UIBarMetricsLandscapePhone];
    
//    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                          [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0],
//                                                          UITextAttributeTextColor,
//                                                          [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0],
//                                                          UITextAttributeTextShadowColor,[NSValue valueWithUIOffset:UIOffsetMake(0, 1)],
//                                                          UITextAttributeTextShadowOffset,
//                                                          [UIFont fontWithName:@"Arial"/*@"Noteworthy"*//*@"AmericanTypewriter"*/ size:0.0],
//                                                          UITextAttributeFont,
//                                                          nil] forState:UIControlStateNormal];
    
    
    IntervalTrainerViewController *intervalTrainerViewController = [[IntervalTrainerViewController alloc] initWithStyle:UITableViewStylePlain];
    intervalTrainerViewController.title = @"Ear Trainer";
    _navController = [[UINavigationController alloc] initWithRootViewController:intervalTrainerViewController];
    
    _window.rootViewController = _navController;
    [_window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    [[SoundEngine sharedInstance] setAlive:NO];
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[SoundEngine sharedInstance] setAlive:NO];
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[SoundEngine sharedInstance] setAlive:YES];
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
