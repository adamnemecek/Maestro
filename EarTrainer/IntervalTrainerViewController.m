#import "IntervalTrainerViewController.h"
#import "MainMenuViewController.h"
#import "Defaults.h"
#import "Interval.h"

@implementation IntervalTrainerViewController {
    BOOL menuShowing;
}

@synthesize mainMenu = _mainMenu;

#pragma mark - Initialization and deallocation

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selections = [NSArray arrayWithObjects:@"U",@"m2",@"M2",@"m3",@"M3",@"P4",@"P5",@"m6",@"M6",@"m7",@"M7",@"P8", nil];
    menuShowing = NO;
    _mainMenu = [[MainMenuViewController alloc] initWithNibName:@"MainMenuView" bundle:nil];
    [self.navigationController.view.superview insertSubview:_mainMenu.view atIndex:0];
    _mainMenu.view.frame = [_mainMenu.view convertRect:[[UIScreen mainScreen] applicationFrame] toView:nil];
}

#pragma mark - Overide super

- (PLAYMODE)getPlaymode {
    return [[Defaults sharedInstance] getPlaymode];
}

- (void)savePlaymode:(PLAYMODE)playmode {
    [[Defaults sharedInstance] savePlaymode:playmode];
}

- (id)getRandomSelection {
    return [Interval getRandomInterval];
}

- (id)getSelectionWithIndex:(NSInteger)index {
    return [[Interval alloc] initInterval:index];
}

#pragma mark - Actions

- (IBAction)showMenu:(id)sender {
    float offsetScalar = 0.83;
    if (!menuShowing) {
        [self.view setUserInteractionEnabled:NO];
        [UIView animateWithDuration:0.325f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.navigationController.view.frame = CGRectOffset(self.navigationController.view.frame, self.navigationController.view.frame.size.width * offsetScalar, 0);
        } completion:NULL];
        menuShowing = YES;
    } else {
        [self.view setUserInteractionEnabled:YES];
        [UIView animateWithDuration:0.325f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.navigationController.view.frame = CGRectOffset(self.navigationController.view.frame, self.navigationController.view.frame.size.width * -offsetScalar, 0);
        } completion:NULL];
        menuShowing = NO;
    }
}
@end