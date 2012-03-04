#import "ContainerViewController.h"

@interface ContainerViewController (Private)
-(void)openMenu:(BOOL)show;
@end

@implementation ContainerViewController {
    BOOL _menuShowing;
}

@synthesize mainMenu = _mainMenu;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup nav buttons
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Settings" style:UIBarButtonItemStyleBordered
                                                                               target:self action:@selector(showSettings:)]];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ButtonMenu.png"] style:UIBarButtonItemStyleBordered
                                                                             target:self action:@selector(showMenu:)]];
    
    _menuShowing = NO;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions

- (void)showMenu:(id)sender {
    if (!_menuShowing) [self openMenu:YES];
    else [self openMenu:NO];
}

- (void)showSettings:(id)sender {
    SettingsViewController *settingsViewController = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    settingsViewController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    [navController.navigationBar setTintColor:[UIColor blackColor]];
    [self presentModalViewController:navController animated:YES];
}

#pragma mark - Menu animation

- (void)openMenu:(BOOL)show {
    float offsetScalar = 0.83;
    UIView *viewToMove = self.navigationController.view;
    if (show) {
        if (!_mainMenu) {
            _mainMenu = [[MainMenuViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController.view.superview insertSubview:_mainMenu.view atIndex:0];
//            _mainMenu.view.frame = [_mainMenu.view convertRect:[[UIScreen mainScreen] applicationFrame] toView:nil];
            _mainMenu.delegate = self;
        }
        [self.view setUserInteractionEnabled:NO];
        [UIView animateWithDuration:0.325f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            viewToMove.frame = CGRectOffset(viewToMove.frame, viewToMove.frame.size.width * offsetScalar, 0);
        } completion:NULL];
        _menuShowing = YES;
    } else {
        [self.view setUserInteractionEnabled:YES];
        [UIView animateWithDuration:0.325f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            viewToMove.frame = CGRectOffset(viewToMove.frame, viewToMove.frame.size.width * -offsetScalar, 0);
        } completion:NULL];
        _menuShowing = NO;
    }
}

#pragma mark - Menu delegate

- (void)mainMenuSelectedCurrentView:(MainMenuViewController *)viewController {
    [self openMenu:NO];
}

- (void)mainMenu:(MainMenuViewController *)viewController didSelectViewController:(UIViewController *)selectedViewController {
    [self openMenu:NO];
    ContainerViewController *controller = (ContainerViewController *)selectedViewController;
    if (!controller)return;
    controller.mainMenu = viewController;
    viewController.delegate = controller;
    [self.navigationController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
    
}

#pragma mark - Settings delegate

- (void)SettingsViewControllerDidFinish:(SettingsViewController *)controller {
    [self dismissModalViewControllerAnimated:YES];
}
@end