#import "HighOctaveSettingsViewController.h"
#import "Defaults.h"

@implementation HighOctaveSettingsViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.octaves = [NSArray arrayWithObjects:@"C3",@"C4",@"C5", nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Overide defaults methods

- (NSInteger)indexToOctave:(NSInteger)index {
    NSInteger octave;
    switch (index) {
        case 0:
            octave = 1;
            break;
        case 1:
            octave = 2;
            break;
        case 2:
            octave = 3;
            break;
    }
    return octave;
}

- (NSInteger)getOctaveSelection {
    NSInteger octaveIndex;
    switch ([[Defaults sharedInstance] getHighOctave]) {
        case 1:
            octaveIndex = 0;
            break;
        case 2:
            octaveIndex = 1;
            break;
        case 3:
            octaveIndex = 2;
            break;
    }
    return octaveIndex;
}

- (BOOL)checkOctave:(NSInteger)octaveIndex {
    if ([self indexToOctave:octaveIndex] >= [[Defaults sharedInstance] getRootOctave]) return YES;
    else {
        [[[UIAlertView alloc] initWithTitle:@"Can't select this octave" message:@"This octave is lower than your current root octave" delegate:nil
                          cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        return NO;
    }
}

- (void)saveOctaveSelection:(NSInteger)selection {
    NSInteger octave = [self indexToOctave:selection];
    [[Defaults sharedInstance] saveHighOctave:octave];
}

@end