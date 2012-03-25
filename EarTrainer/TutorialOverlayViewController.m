#import "TutorialOverlayViewController.h"

@interface TutorialOverlayViewController ()
-(void)finishedAnimation:(id)sender;
-(void)fadeOverlay;
@end

@implementation TutorialOverlayViewController {
    BOOL isDragging;
}

@synthesize delegate;

- (id)init {
    self = [super init];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tutorial_overlay.png"]];
    UIView *mainView = [[UIView alloc] initWithFrame:imageView.frame];
    [mainView addSubview:imageView];
    self.view = mainView;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Animation

- (void)finishedAnimation:(id)sender {
    [delegate tutorialViewControllerDidFinishFading:self];
}

- (void)fadeOverlay {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationDidStopSelector:@selector(finishedAnimation:)];
    [self.view setAlpha:0.0];
    [UIView commitAnimations];
}

#pragma mark - Touch handling

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    isDragging = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!isDragging) [self fadeOverlay];
    isDragging = NO;
}
@end