#import "AboutViewController.h"

@implementation AboutViewController {
    UIImageView *shadowView;
    PushOverlayView *pushBackView;
}

@synthesize mainMenu    = _mainMenu;
@synthesize menuShowing = _menuShowing;
@synthesize version     = _version;

- (id)init {
    self = [super initWithNibName:@"AboutView" bundle:nil];
    if (self) {
        self.title = @"Maestro";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self roundNavCorners];
    self.navigationController.toolbarHidden = YES;
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ButtonMenu.png"] style:UIBarButtonItemStyleBordered
                                                                              target:self action:@selector(showMenu:)]];
    _menuShowing = NO;
    _version.text = [NSString stringWithFormat:@"Version %@", currentVersion()];
}

- (void)viewDidUnload {
    [self setVersion:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Actions
- (IBAction)openWebsite:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://penguinsoftapps.com/"]];
}

- (IBAction)contact:(id)sender {
    [self sendEmailTo:@"contact@penguinsoftapps.com" withCC:@"" withBCC:@"" withSubject:@"Maestro" withBody:@""];
}

- (void)showMenu:(id)sender {
    if (!_menuShowing) [self openMenu:YES];
    else [self openMenu:NO];
}

- (void)sendEmailTo:(NSString*)to withCC:(NSString*)cc withBCC:(NSString*)bcc withSubject:(NSString*)subject withBody:(NSString*)body {
	NSString * url = [NSString stringWithFormat:@"mailto:?to=%@&cc=%@&bcc=%@&subject=%@&body=%@",
					  [to stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
					  [cc stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
					  [bcc stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
					  [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
					  [body stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

#pragma mark - Menu animation
- (void)openMenu:(BOOL)show {
    float offsetScalar = 0.83;
    UIView *viewToMove = self.navigationController.view;
    if (!pushBackView) {
        pushBackView = [[PushOverlayView alloc] initWithFrame:viewToMove.frame];
        [pushBackView setDelegate:self];
    }
    [viewToMove addSubview:pushBackView];
    if (!shadowView) {
        shadowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shadow_sidebar.png"]];
        shadowView.frame = CGRectMake(viewToMove.frame.origin.x - shadowView.frame.size.width, shadowView.frame.origin.y, shadowView.frame.size.width, shadowView.frame.size.height);
        [self.navigationController.view.superview insertSubview:shadowView belowSubview:viewToMove];
    }
    if (show) {
        if (!_mainMenu) {
            _mainMenu = [[MainMenuViewController alloc] initWithStyle:UITableViewStylePlain];
            CGRect menuFrame = _mainMenu.tableView.frame;
            [_mainMenu.tableView setFrame:CGRectMake(menuFrame.origin.x, menuFrame.origin.y, menuFrame.size.width * offsetScalar, menuFrame.size.height)];
            //            _mainMenu.view.frame = [_mainMenu.view convertRect:[[UIScreen mainScreen] applicationFrame] toView:nil];
            [self.navigationController.view.superview insertSubview:_mainMenu.view atIndex:0];
            _mainMenu.delegate = self;
        }
        [_mainMenu.tableView setHidden:NO];
        [self.view setUserInteractionEnabled:NO];
        [UIView animateWithDuration:0.325f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            viewToMove.frame = CGRectOffset(viewToMove.frame, viewToMove.frame.size.width * offsetScalar, 0);
            shadowView.frame = CGRectOffset(shadowView.frame, viewToMove.frame.size.width * offsetScalar, 0);
        } completion:^(BOOL finished) {
            _menuShowing = YES;
        }];
    } else {
        [self.view setUserInteractionEnabled:YES];
        [pushBackView removeFromSuperview];
        [UIView animateWithDuration:0.325f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            viewToMove.frame = CGRectOffset(viewToMove.frame, viewToMove.frame.size.width * -offsetScalar, 0);
            shadowView.frame = CGRectOffset(shadowView.frame, viewToMove.frame.size.width * -offsetScalar, 0);
        } completion:^(BOOL finished) {
            _menuShowing = NO;
            [_mainMenu.tableView setHidden:YES];
        }];
    }
}

#pragma mark - Push view delegate
- (void)tapEnded:(PushOverlayView *)view {
    [self openMenu:NO];
}

#pragma mark - Main menu delegate
- (void)mainMenuSelectedCurrentView:(MainMenuViewController *)viewController {
    [self openMenu:NO];
}

- (void)mainMenu:(MainMenuViewController *)viewController didSelectViewController:(UIViewController *)selectedViewController {
    [self openMenu:NO];
    AboutViewController *controller = (AboutViewController *)selectedViewController;
    if (!controller)return;
    controller.mainMenu = viewController;
    viewController.delegate = controller;
    [self.navigationController setViewControllers:[NSArray arrayWithObject:controller] animated:NO];
}
@end