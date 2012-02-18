#import "IntervalTrainerViewController.h"

#import "Defaults.h"
#import "SoundEngine.h"

#import "Note.h"
#import "Interval.h"

@interface IntervalTrainerViewController (Private)
-(UIImage *)getCurrentPlaymodeImage;
-(void)setPlayType:(PLAYTYPE)type;
-(void)setUsingTrainingButtons:(BOOL)using;
@end

@implementation IntervalTrainerViewController {
    PLAYMODE playmodeIndex;
    PLAYTYPE playType;
    NSArray *intervals;
    Interval *currentInterval;
}

@synthesize playButton;
@synthesize skipButton;
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
    intervals = [NSArray arrayWithObjects:@"U",@"m2",@"M2",@"m3",@"M3",@"P4",@"P5",@"m6",@"M6",@"m7",@"M7",@"P8", nil];
    playType = PLAYTYPE_TRAIN;
    [skipButton setEnabled:NO];
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [self setPlaymodeButton:nil];
    [self setPlayButton:nil];
    [self setSkipButton:nil];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [intervals count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IntervalCell"];
    if (!currentInterval && playType == PLAYTYPE_TRAIN) cell.textLabel.textColor = [UIColor lightGrayColor];
    else cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = [intervals objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (playType == PLAYTYPE_TRAIN) {
        if (!currentInterval) return;
        NSString *alertTitle, *alertMessage;
        if (currentInterval.interval == indexPath.row) alertTitle = @"Correct";
        else alertTitle = @"Wrong";
        alertMessage = [NSString stringWithFormat:@"%@ \n %@", [currentInterval getNoteNames], currentInterval.longName];
        [[[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:@"Next" otherButtonTitles:nil, nil] show];
    } else {
        Interval *interval = [[Interval alloc] initInterval:indexPath.row withRoot:[Note getRandomNote]];
        [[SoundEngine sharedInstance] playInterval:interval];
    }
}

#pragma mark UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        currentInterval = [Interval getRandomInterval];
        [[SoundEngine sharedInstance] playInterval:currentInterval];
    }
}

#pragma mark - Training mode

- (void)setupTrainingMode {
    [self.tableView reloadData];
    [self setUsingTrainingButtons:YES];
}

#pragma mark - Practice mode

- (void)setupPracticeMode {
    currentInterval = nil;
    [self.tableView reloadData];
    [self setUsingTrainingButtons:NO];
}

#pragma mark - enabling/disabling

- (void)setUsingTrainingButtons:(BOOL)using {
    if (using) {
        [playButton setEnabled:YES];
//        [skipButton setEnabled:YES];  // Don't enable this one. It's enabled after you press play
    } else {
        [playButton setEnabled:NO];
        [skipButton setEnabled:NO];
    }
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

#pragma mark - PlayType

- (void)setPlayType:(PLAYTYPE)type {
    playType = type;
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
    if (!currentInterval) {
        currentInterval = [Interval getRandomInterval];
        [self.tableView reloadData];
        [skipButton setEnabled:YES];
    }
    [[SoundEngine sharedInstance] playInterval:currentInterval];
}

- (IBAction)skip:(id)sender {
    currentInterval = [Interval getRandomInterval];
    [[SoundEngine sharedInstance] playInterval:currentInterval];
}

- (IBAction)changePlayType:(id)sender {
    switch (playType) {
        case PLAYTYPE_TRAIN:
            playType = PLAYTYPE_PRACTICE;
            [(UIBarButtonItem *)sender setTitle:@"train"];
            [self setupPracticeMode];
            break;
        case PLAYTYPE_PRACTICE:
            playType = PLAYTYPE_TRAIN;
            [(UIBarButtonItem *)sender setTitle:@"practice"];
            [self setupTrainingMode];
            break;
    }
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