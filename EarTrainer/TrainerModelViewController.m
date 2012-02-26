#import "TrainerModelViewController.h"

#import "SoundEngine.h"
#import "Defaults.h"

#import "Note.h"
#import "Interval.h"

@interface TrainerModelViewController (Private)
-(UIImage *)getCurrentPlaymodeImage;
-(void)setPlayType:(PLAYTYPE)type;
-(void)setUsingTrainingButtons:(BOOL)using;
@end

@implementation TrainerModelViewController {
    PLAYMODE playmodeIndex;
    PLAYTYPE playType;
    Interval *currentInterval;
}

@synthesize playButton, skipButton, playmodeButton;
@synthesize selections;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    playType = PLAYTYPE_TRAIN;
    [skipButton setEnabled:NO];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self setPlaymodeButton:nil];
    [self setPlayButton:nil];
    [self setSkipButton:nil];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [selections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!currentInterval && playType == PLAYTYPE_TRAIN) cell.textLabel.textColor = [UIColor lightGrayColor];
    else cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = [selections objectAtIndex:indexPath.row];
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