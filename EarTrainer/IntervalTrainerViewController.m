#import "IntervalTrainerViewController.h"

#import "Defaults.h"
#import "SoundEngine.h"

#import "Note.h"
#import "Interval.h"

@interface IntervalTrainerViewController (Private)
-(UIImage *)getCurrentPlaymodeImage;
@end

@implementation IntervalTrainerViewController {
    PLAYMODE playmodeIndex;
    Interval *currentInterval;
}

@synthesize playmodeButton;

#pragma mark - Initialization and deallocation

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    currentInterval = [Interval getRandomInterval];
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [self setPlaymodeButton:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    playmodeIndex = [[Defaults sharedInstance] getPlaymode];
    [playmodeButton setImage:[self getCurrentPlaymodeImage]];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 1;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    return cell;
//}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *alertTitle, *alertMessage;
    if (currentInterval.interval == indexPath.row) {
        alertTitle = @"Correct";
    } else {
        alertTitle = @"Wrong";
    }
    alertMessage = [NSString stringWithFormat:@"%@ \n %@", [currentInterval getNoteNames], currentInterval.longName];
    [[[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:@"Next" otherButtonTitles:nil, nil] show];
}

#pragma mark - Playmode

- (UIImage *)getCurrentPlaymodeImage {
    NSString *playmodeImageTitle;
    switch (playmodeIndex) {
        case PLAYMODE_ASCENDING:
            playmodeImageTitle = kImage_Playmode_Ascending;
            break;
        case PLAYMODE_DESCENDING:
            playmodeImageTitle = kImage_Playmode_Descending;
            break;
        case PLAYMODE_CHORD:
            playmodeImageTitle = kImage_Playmode_Chord;
            break;
    }
    return [UIImage imageNamed:playmodeImageTitle];
}

#pragma mark - Actions

- (IBAction)changePlaymode:(id)sender {
    switch (playmodeIndex) {
        case PLAYMODE_ASCENDING:
            playmodeIndex = PLAYMODE_DESCENDING;
            break;
        case PLAYMODE_DESCENDING:
            playmodeIndex = PLAYMODE_CHORD;
            break;
        case PLAYMODE_CHORD:
            playmodeIndex = PLAYMODE_ASCENDING;
            break;
    }
    [[Defaults sharedInstance] savePlaymode:playmodeIndex];
    [(UIBarButtonItem *)sender setImage:[self getCurrentPlaymodeImage]];
}

- (IBAction)play:(id)sender {
    [[SoundEngine sharedInstance] playInterval:currentInterval];
}

- (IBAction)skip:(id)sender {
    currentInterval = [Interval getRandomInterval];
    [[SoundEngine sharedInstance] playInterval:currentInterval];
}

#pragma mark - Segue delegate connection

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kSegue_Identifier_Open_Settings]) {
        UINavigationController *navigationController = segue.destinationViewController;
        SettingsViewController *settingsViewController = [[navigationController viewControllers] objectAtIndex:0];
        settingsViewController.delegate = self;
    }
}

#pragma mark - Settings view controller delegate

- (void)SettingsViewControllerDidFinish:(SettingsViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end