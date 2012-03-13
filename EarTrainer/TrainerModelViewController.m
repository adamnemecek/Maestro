#import "TrainerModelViewController.h"
#import "SoundEngine.h"
#import "NoteCollection.h"

@interface TrainerModelViewController (Private)
-(UIImage *)getCurrentPlaymodeImage;
-(void)setPlayType:(PLAYTYPE)type;
-(void)setUsingTrainingButtons:(BOOL)using;
@end

@implementation TrainerModelViewController {
    PLAYMODE playmodeIndex;
    PLAYTYPE playType;
    NoteCollection *currentSelection;
}

@synthesize playButton, skipButton, playmodeButton, playTypeButton;
@synthesize selections;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Show toolbar
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    // Setup toolbar items
    UIBarButtonItem *flex1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    playmodeButton = [[UIBarButtonItem alloc] initWithImage:[self getCurrentPlaymodeImage] style:UIBarButtonItemStyleBordered target:self action:@selector(changePlaymode:)];
    playButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(play:)];
    [playButton setStyle:UIBarButtonItemStyleBordered];
    skipButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(skip:)];
    [skipButton setStyle:UIBarButtonItemStyleBordered];
    UIBarButtonItem *flex2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    flex2.width = 30.0;
    playTypeButton = [[UIBarButtonItem alloc] initWithTitle:@"Practice" style:UIBarButtonItemStyleBordered target:self
                                                                                   action:@selector(changePlayType:)];
    
    self.toolbarItems = [NSArray arrayWithObjects:flex1,playmodeButton,playButton,skipButton,flex2, playTypeButton,nil];
    
    playType = PLAYTYPE_TRAIN;
    [skipButton setEnabled:NO];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self setPlaymodeButton:nil];
    [self setPlayButton:nil];
    [self setSkipButton:nil];
    [self setPlayTypeButton:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    playmodeIndex = [self getPlaymode];
    [playmodeButton setImage:[self getCurrentPlaymodeImage]];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [selections count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    if (!currentSelection && playType == PLAYTYPE_TRAIN) cell.textLabel.textColor = [UIColor lightGrayColor];
    else cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = [selections objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (playType == PLAYTYPE_TRAIN) {
        if (!currentSelection) return;
        NSString *alertTitle, *alertMessage;
        if (currentSelection.index == indexPath.row) alertTitle = @"Correct";
        else alertTitle = @"Wrong";
        alertMessage = [NSString stringWithFormat:@"%@ \n %@", [currentSelection getNoteNames], currentSelection.longName];
        [[[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:@"Next" otherButtonTitles:nil, nil] show];
    } else {
        NSString *promptMessage = [NSString stringWithFormat:@"%@ \n %@", [(NoteCollection *)[self getSelectionWithIndex:indexPath.row] getNoteNames],
                                  ((NoteCollection *)[self getSelectionWithIndex:indexPath.row]).longName];
        [self.navigationItem setPrompt:promptMessage];
        
        [self playCollection:(NoteCollection *)[self getSelectionWithIndex:indexPath.row]];
    }
}

#pragma mark UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        currentSelection = [self getRandomSelection];
        [self playCollection:currentSelection];
    }
}

#pragma mark - Play notes

- (void)playCollection:(NoteCollection *)collection {
    [[SoundEngine sharedInstance] playCollection:collection withProperties:[NSArray arrayWithObjects:
                                                                            [NSNumber numberWithInt:[self getPlaymode]],
                                                                            [NSNumber numberWithInt:[self getTempo]],
                                                                            nil]];
}

/* These methods are to be overridden by subclass */
#pragma mark - subclass methods

#pragma mark Defaults

- (PLAYMODE)getPlaymode {
    return PLAYMODE_ASCENDING;
}

- (int)getTempo {
    return 1;
}

- (void)savePlaymode:(PLAYMODE)playmode {
}

#pragma mark Selection

- (id)getRandomSelection {
    return nil;
}

- (id)getSelectionWithIndex:(NSInteger)index {
    return nil;
}

#pragma mark - Training mode

- (void)setupTrainingMode {
    [self.tableView reloadData];
    if (self.navigationItem.prompt) [self.navigationItem setPrompt:nil];
    [self setUsingTrainingButtons:YES];
}

#pragma mark - Practice mode

- (void)setupPracticeMode {
    currentSelection = nil;
    [self.tableView reloadData];
    self.navigationItem.prompt = @"";
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

- (void)changePlaymode:(id)sender {
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
    [self savePlaymode:playmodeIndex];
    [(UIBarButtonItem *)sender setImage:[self getCurrentPlaymodeImage]];
}

- (void)play:(id)sender {
    if (!currentSelection) {
        currentSelection = [self getRandomSelection];
        [self.tableView reloadData];
        [skipButton setEnabled:YES];
    }
    [self playCollection:currentSelection];
}

- (void)skip:(id)sender {
    currentSelection = [self getRandomSelection];
    [self playCollection:currentSelection];
}

- (void)changePlayType:(id)sender {
    switch (playType) {
        case PLAYTYPE_TRAIN:
            playType = PLAYTYPE_PRACTICE;
            [playTypeButton setTitle:@"Train"];
            [self setupPracticeMode];
            break;
        case PLAYTYPE_PRACTICE:
            playType = PLAYTYPE_TRAIN;
            [playTypeButton setTitle:@"Practice"];
            [self setupTrainingMode];
            break;
    }
}
@end