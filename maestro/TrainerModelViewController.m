#import "TrainerModelViewController.h"
#import "Stats.h"
#import "SoundEngine.h"
#import "NoteCollection.h"

@implementation TrainerModelViewController {
    PLAYMODE _playmode;
    PLAYTYPE playType;
    NSInteger currentDifficulty;
    NoteCollection *currentSelection;
    BOOL playTypeIsTransitioning;
    UIPinchGestureRecognizer *pinchGesture;
    Stats *sessionStats;
    NSInteger listeningOctave;
}
@synthesize playButton, skipButton, playmodeButton, playTypeButton, octaveSelection,flexSpace,fixedSpace;
@synthesize selections;
@synthesize subtitles;
@synthesize choiceIndices;

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup pinch gesture recognizer
    pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.tableView addGestureRecognizer:pinchGesture];
    
    // build toolbar
    octaveSelection = [[UIBarButtonItem alloc] initWithTitle:@"Octave: C4" style:UIBarButtonItemStyleBordered target:self action:@selector(openListeningOctaveSelection)];
    flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    playmodeButton = [[UIBarButtonItem alloc] initWithImage:[self getCurrentPlaymodeImage] style:UIBarButtonItemStyleBordered target:self action:@selector(changePlaymode:)];
    playButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(play:)];
    [playButton setStyle:UIBarButtonItemStyleBordered];
    skipButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(skip:)];
    [skipButton setStyle:UIBarButtonItemStyleBordered];
    fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 30.0;
    playTypeButton = [[UIBarButtonItem alloc] initWithTitle:@"Listen" style:UIBarButtonItemStyleBordered target:self action:@selector(changePlayType:)];
    self.toolbarItems = [NSArray arrayWithObjects:flexSpace,playmodeButton,playButton,skipButton,fixedSpace,playTypeButton,nil];
    
    [skipButton setEnabled:NO]; // Skip button isn't enabled until we first play
    
    // Show toolbar
    [self.navigationController setToolbarHidden:NO animated:NO];
    
    // Grab the current difficulty
    currentDifficulty = [self getDifficulty];
    
    // Setup stats object
    sessionStats = [Stats new];
    
    listeningOctave = 2; // C4
    playTypeIsTransitioning = NO;
    playType = PLAYTYPE_TRAIN;
}


- (void)viewDidUnload {
    [super viewDidUnload];
    [self setOctaveSelection:nil];
    [self setFlexSpace:nil];
    [self setFixedSpace:nil];
    [self setPlaymodeButton:nil];
    [self setPlayButton:nil];
    [self setSkipButton:nil];
    [self setPlayTypeButton:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // These can be changed in the settings, so we want to to call them every time the view appears
    _playmode = [self getPlaymode];
    [playmodeButton setImage:[self getCurrentPlaymodeImage]];
    
    // Fills the selections, subtitles, and choiceIndices arrays
    [self setSelectionsAndChoices];
    
    // If we changed the difficulty level in the settings then we reset the trainer
    if (currentDifficulty != [self getDifficulty]) {
        [sessionStats resetStats];
        skipButton.enabled = NO;
        currentSelection = nil;
        currentDifficulty = [self getDifficulty];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Toolbar
- (void)itemsInToolbar:(NSArray *)items animated:(BOOL)animated {
    [self.navigationController.toolbar setItems:items animated:animated];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (playType == PLAYTYPE_TRAIN)
        return selections.count;
    else
        return [self getAllSelections].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    
    // Training
    if (playType == PLAYTYPE_TRAIN) {
        if (!currentSelection)  // If we haven't started training then make the cells gray
            cell.textLabel.textColor = [UIColor lightGrayColor];
        else
            cell.textLabel.textColor = [UIColor blackColor];
        
        cell.textLabel.text = [selections objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [subtitles objectAtIndex:indexPath.row];
    } else {  // Practicing
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.text = [[self getAllSelectionsAbbreviated] objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [[self getAllSelections] objectAtIndex:indexPath.row];

    }
    
    // If we are showing the stats header view then gray the cells and disable user input
    if (self.isShowing) {
        [cell setUserInteractionEnabled:NO];
        cell.textLabel.textColor = [UIColor grayColor];
    } else {
        [cell setUserInteractionEnabled:YES];
    }
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (playType == PLAYTYPE_TRAIN) {
        if (!currentSelection) return;
        NSString *alertTitle, *alertMessage;
        BOOL right;
        
        // choiceIndices is nil if we are on pro difficulty
        NSInteger choiceIndex = (!choiceIndices) ? indexPath.row : [[choiceIndices objectAtIndex:indexPath.row] integerValue];
        
        if (currentSelection.index == choiceIndex) {
            alertTitle = @"Correct";
            alertMessage = [NSString stringWithFormat:@"%@", currentSelection.longName];
            right = YES;
        } else {
            alertTitle = @"Wrong";
            alertMessage = [NSString stringWithFormat:@"Answer: %@", currentSelection.longName];
            right = NO;
        }
        [sessionStats addToStats:right];
        
        // Alert the user if he was correct or not
        [[[BSAlert alloc] initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:@"Next" otherButtonTitles:nil, nil] show];
    } else { // Training mode
        // Simply play the note corresponding to the row
        [self playCollection:(NoteCollection *)[self getSelectionWithIndex:indexPath.row andOctave:listeningOctave]];
    }
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // Select a new interval/chord when the user closes the alert
    if (buttonIndex == 0) {
        currentSelection = [self getRandomSelection];
        [self playCollection:currentSelection];
    }
}

#pragma mark - Play notes
- (void)playCollection:(NoteCollection *)collection {
    [[SoundEngine sharedInstance] playCollection:collection withTempo:2.0 andPlayOrder:0];
}

/* These methods are to be written by subclass */
#pragma mark - subclass methods

#pragma mark choices and selections
- (NSArray *)getAllSelections {
    return [NSArray arrayWithObject:@"Mystery Note"];
}

- (NSArray *)getAllSelectionsAbbreviated {
    return [NSArray arrayWithObject:@"MN"];
}

- (void)setSelectionsAndChoices {
}

#pragma mark Defaults
- (NSInteger)getDifficulty {
    return 0;
}

- (PLAYMODE)getPlaymode {
    return PLAYMODE_ASCENDING;
}

- (int)getTempo {
    return 1;
}

- (void)savePlaymode:(PLAYMODE)playmode {
}

#pragma mark Selection
// Use for training
- (id)getRandomSelection {
    return nil;
}

// Use for listening
- (id)getSelectionWithIndex:(NSInteger)index andOctave:(NSInteger)octave {
    return nil;
}

#pragma mark - Training mode
- (void)setupTrainingMode {
    // Animate in the right toolbar buttons
    [self itemsInToolbar:[NSArray arrayWithObjects:flexSpace,playmodeButton,playButton,skipButton,fixedSpace,playTypeButton,nil] animated:YES];
    
    playTypeIsTransitioning = YES;
    if (choiceIndices) {
        NSMutableArray *rowsToRefresh = [NSMutableArray array];
        for (int i = 0; i < [selections count]; i++) {
            [rowsToRefresh addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        
        NSMutableArray *rowsToDelete = [NSMutableArray array];
        for (int i = 0; i < [choiceIndices count]; i++) {
            int currentIndex, nextIndex;
            int spaceForNextIndex = 0;
            if (i != ([choiceIndices count] - 1)) spaceForNextIndex = 1;
            currentIndex = [[choiceIndices objectAtIndex:i] intValue];
            nextIndex = [[choiceIndices objectAtIndex:(i + spaceForNextIndex)] intValue];
            if (currentIndex == nextIndex) {
                for (int j = 1; j <= (([[self getAllSelections] count] - 1) - [[choiceIndices objectAtIndex:i] intValue]); j++) {
                    [rowsToDelete addObject:[NSIndexPath indexPathForRow:([[self getAllSelections] count] - j) inSection:0]];
                }
                break;
            }
            
            for (int j = 1; j < (nextIndex - currentIndex); j++) {
                [rowsToDelete addObject:[NSIndexPath indexPathForRow:(currentIndex + j) inSection:0]];
            }
        }
        [self.tableView deleteRowsAtIndexPaths:rowsToDelete withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self performBlock:^{
                [self.tableView reloadRowsAtIndexPaths:rowsToRefresh withRowAnimation:UITableViewRowAnimationAutomatic];
        } afterTimeInterval:0.31];
        [self performBlock:^{
                playTypeIsTransitioning = NO;
        } afterTimeInterval:0.32];
        
    } else {
        NSMutableArray *rowsToRefresh = [NSMutableArray array];
        for (int i = 0; i < [[self getAllSelections] count]; i++) {
            [rowsToRefresh addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [self.tableView reloadRowsAtIndexPaths:rowsToRefresh withRowAnimation:UITableViewRowAnimationFade];
        playTypeIsTransitioning = NO;
    }
    [self setUsingTrainingButtons:YES];
    [sessionStats resetStats];
}

#pragma mark - Practice mode
- (void)setupPracticeMode {
    [self itemsInToolbar:[NSArray arrayWithObjects:octaveSelection,playmodeButton,flexSpace,playTypeButton,nil] animated:YES];
    
    playTypeIsTransitioning = YES;
    if (choiceIndices) {
        NSMutableArray *rowsToRefresh = [NSMutableArray array];
        for (int i = 0; i < [selections count]; i++) {
            [rowsToRefresh addObject:[NSIndexPath indexPathForRow:[[choiceIndices objectAtIndex:i] integerValue] inSection:0]];
        }
        
        /***
         * For each cell we find its index in context of all selections
         * We then find the next cell's index in context of all selections
         * Then we subtract the next cell's index from the first's and if there is a difference greater than one we know to add cells there
         * So we loop through the difference between cell indeces and create an indexPath for each one which row is the
         * first cell's index + current iteration
         * If we hit the last cell then both cells become the same cell
         * In that case we find how many choices are left after the last cell and add them
         ***/
        NSMutableArray *rowsToInsert = [NSMutableArray array];
        for (int i = 0; i < [selections count]; i++) {
            int currentIndex, nextIndex;
            int nextCellIndex = 0;
            UITableViewCell *cell, *nextCell;
            cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (i != ([selections count] - 1)) nextCellIndex = 1;
            nextCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(i + nextCellIndex) inSection:0]];
            
            if (cell == nextCell) {
                for (int j = 1; j <= (([[self getAllSelections] count] - 1) - [[choiceIndices objectAtIndex:i] intValue]); j++) {
                    [rowsToInsert addObject:[NSIndexPath indexPathForRow:([[choiceIndices objectAtIndex:i] intValue] + j) inSection:0]];
                }
                break;
            }
            
            for (int j = 0; j < [[self getAllSelectionsAbbreviated] count]; j++) {
                if ([cell.textLabel.text isEqualToString:[[self getAllSelectionsAbbreviated] objectAtIndex:j]]) {
                    currentIndex = j;
                }
                if ([nextCell.textLabel.text isEqualToString:[[self getAllSelectionsAbbreviated] objectAtIndex:j]]) {
                    nextIndex = j;
                    break;
                }
            }
            if (nextIndex - currentIndex != 1) {
                for (int k = 1; k < (nextIndex - currentIndex); k++) {
                    [rowsToInsert addObject:[NSIndexPath indexPathForRow:(currentIndex + k) inSection:0]];
                }
            }
        }
        [self.tableView insertRowsAtIndexPaths:rowsToInsert withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self performBlock:^{
            [self.tableView reloadRowsAtIndexPaths:rowsToRefresh withRowAnimation:UITableViewRowAnimationAutomatic];
        } afterTimeInterval:0.31];
        [self performBlock:^{
            playTypeIsTransitioning = NO;
        } afterTimeInterval:0.32];
        
    } else {
        NSMutableArray *rowsToRefresh = [NSMutableArray array];
        for (int i = 0; i < [[self getAllSelections] count]; i++) {
            [rowsToRefresh addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [self.tableView reloadRowsAtIndexPaths:rowsToRefresh withRowAnimation:UITableViewRowAnimationFade];
        playTypeIsTransitioning = NO;
    }
    
    currentSelection = nil;
    [self setUsingTrainingButtons:NO];
}

#pragma mark - enabling/disabling
// Enables/Disables buttons depending on our mode
- (void)setUsingTrainingButtons:(BOOL)using {
    if (using) {
        [playButton setEnabled:YES];
    } else {
        [playButton setEnabled:NO];
        [skipButton setEnabled:NO];
    }
}

#pragma mark - Playmode
// Returns the correct playmode image
- (UIImage *)getCurrentPlaymodeImage {
    NSString *playmodeImageTitle;
    switch (_playmode) {
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
// Changes the mode between listening and training
- (void)setPlayType:(PLAYTYPE)type {
    if (playTypeIsTransitioning) return;
    if (playType == type) return;
    playType = type;
    switch (playType) {
        case PLAYTYPE_TRAIN:
            [playTypeButton setTitle:@"Listen"];
            [self setupTrainingMode];
            break;
        case PLAYTYPE_PRACTICE:
            [playTypeButton setTitle:@"Train"];
            [self setupPracticeMode];
            break;
    }
}

#pragma mark - Listening octaves
- (void)openListeningOctaveSelection {
    [[[UIActionSheet alloc] initWithTitle:@"Octaves" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil
                        otherButtonTitles:@"C2", @"C3", @"C4", @"C5", nil] showFromToolbar:self.navigationController.toolbar];
}

#pragma mark - Actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *octaveTitle;
    switch (buttonIndex) {
        case 0:
            octaveTitle = @"C2";
            listeningOctave = 0;
            break;
        case 1:
            octaveTitle = @"C3";
            listeningOctave = 1;
            break;
        case 2:
            octaveTitle = @"C4";
            listeningOctave = 2;
            break;
        case 3:
            octaveTitle = @"C5";
            listeningOctave = 3;
            break;
        default:
            // Get rid of the string except for the octave part
            octaveTitle = [octaveSelection.title stringByReplacingOccurrencesOfString:@"Octave: " withString:@""];
            break;
    }
    // For some reason the toolbar resets back to training mode so we have to set it back
    [self itemsInToolbar:[NSArray arrayWithObjects:octaveSelection,playmodeButton,flexSpace,playTypeButton,nil] animated:NO];
    
    [octaveSelection setTitle:[NSString stringWithFormat:@"Octave: %@", octaveTitle]];
}

#pragma mark - Actions
- (void)changePlaymode:(id)sender {
    switch (_playmode) {
        case PLAYMODE_ASCENDING:
            _playmode = PLAYMODE_DESCENDING;
            break;
        case PLAYMODE_DESCENDING:
            _playmode = PLAYMODE_CHORD;
            break;
        case PLAYMODE_CHORD:
            _playmode = PLAYMODE_ASCENDING;
            break;
    }
    [self savePlaymode:_playmode];
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
            [self setPlayType:PLAYTYPE_PRACTICE];
            break;
        case PLAYTYPE_PRACTICE:
            [self setPlayType:PLAYTYPE_TRAIN];
            break;
    }
}

#pragma mark - Overide pull header methods
// Create the stats view when the user views the header
- (void)refreshHeader {
    [super refreshHeader]; // Clears out the header for us
    
    // Create green stats bar
    UIView *percentBar = [[UIView alloc] initWithFrame:CGRectMake(self.headerView.frame.size.width  * 0.3,
                                                                   self.headerView.frame.size.height * 0.30,
                                                                   self.headerView.frame.size.width  * 0.4,
                                                                   self.headerView.frame.size.height * 0.40)];
    [percentBar setBackgroundColor:[UIColor niceGreenColorWithAlpha:1.0]];
    
    // Create red bar to show the amount wrong
    UIView *percentWrong = [[UIView alloc] initWithFrame:CGRectMake(percentBar.frame.origin.x + (percentBar.frame.size.width * (1.0 - [sessionStats getPercentWrong])),
                                                                    self.headerView.frame.size.height * 0.30,
                                                                    percentBar.frame.size.width * [sessionStats getPercentWrong],
                                                                    self.headerView.frame.size.height * 0.40)];
    [percentWrong setBackgroundColor:[UIColor niceRedColorWithAlpha:1.0]];
    
    // Create labels                        
    UILabel *right = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.headerView.frame.size.width * 0.3, self.headerView.frame.size.height)];
    UILabel *wrong = [[UILabel alloc] initWithFrame:CGRectMake(self.headerView.frame.size.width * 0.7, 0,
                                                               self.headerView.frame.size.width * 0.3, self.headerView.frame.size.height)];
    right.font = [UIFont fontWithName:@"Baskerville-Bold" size:22.0];
    wrong.font = [UIFont fontWithName:@"Baskerville-Bold" size:22.0];
    right.text = [NSString stringWithFormat:@"%i", sessionStats.right];
    wrong.text = [NSString stringWithFormat:@"%i", sessionStats.wrong];
    right.textAlignment = UITextAlignmentCenter;
    wrong.textAlignment = UITextAlignmentCenter;
    right.backgroundColor = [UIColor clearColor];
    wrong.backgroundColor = [UIColor clearColor];
    [right setTextColor:[UIColor niceGreenColorWithAlpha:1.0]];
    [wrong setTextColor:[UIColor niceRedColorWithAlpha:1.0]];
    
    [self.headerView addSubview:percentBar];
    [self.headerView addSubview:percentWrong];
    
    [self.headerView addSubview:right];
    [self.headerView addSubview:wrong];
}

// Reenables things when header view releases
- (void)enableCommonFunctionality {
    [self.tableView reloadData];
    [self.tableView addGestureRecognizer:pinchGesture];
    [playmodeButton setEnabled:YES];
    if (playType == PLAYTYPE_TRAIN) [playButton setEnabled:YES];
    if (currentSelection) [skipButton setEnabled:YES];
    [playTypeButton setEnabled:YES];
}

// When we are viewing the header view certain functions need to be disabled
- (void)disableCommonFunctionality {
    [self.tableView reloadData];
    [self.tableView removeGestureRecognizer:pinchGesture];
    [playmodeButton setEnabled:NO];
    [playButton setEnabled:NO];
    [skipButton setEnabled:NO];
    [playTypeButton setEnabled:NO];
}

#pragma mark - Pinch gesture
- (void)handlePinch:(UIPinchGestureRecognizer *)gesture {
//    dbgLog(@"pinch scale: %f velocity: %f",pinchGesture.scale,pinchGesture.velocity);
    if (gesture.scale > 1.4 && gesture.velocity > 1.3) [self setPlayType:PLAYTYPE_PRACTICE];
    else if (gesture.scale < 0.6 && gesture.velocity < - 1.3) [self setPlayType:PLAYTYPE_TRAIN];
}
@end