#import "TrainerModelViewController.h"
#import "Stats.h"
#import "SoundEngine.h"
#import "NoteCollection.h"

@implementation TrainerModelViewController {
    NoteCollection *_currentSelection;
    Stats *sessionStats;
    UIPinchGestureRecognizer *_pinchGesture;
    PLAYMODE _playmode;
    PLAYTYPE _playType;
    NSInteger _currentDifficulty;
    NSInteger _listeningOctave;
    BOOL _playTypeIsTransitioning;
    
}
@synthesize playButton, skipButton, playmodeButton, playTypeButton, octaveSelection,flexSpace,fixedSpace;
@synthesize selections    = _selections;
@synthesize subtitles     = _subtitles;
@synthesize choiceIndices = _choiceIndices;

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup pinch gesture recognizer
    _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.tableView addGestureRecognizer:_pinchGesture];
    
    // build toolbar
    octaveSelection = [[UIBarButtonItem alloc] initWithTitle:@"Octave: C4" style:UIBarButtonItemStyleBordered target:self action:@selector(openListeningOctaveSelection)];
    flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    playmodeButton = [[UIBarButtonItem alloc] initWithImage:imageForPlaymode([self getPlaymode]) style:UIBarButtonItemStyleBordered target:self action:@selector(changePlaymode:)];
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
    _currentDifficulty = [self getDifficulty];
    
    // Setup stats object
    sessionStats = [Stats new];
    
    _listeningOctave = C4;
    _playType = PLAYTYPE_TRAIN;
    _playTypeIsTransitioning = NO;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self setPlayButton:nil];
    [self setSkipButton:nil];
    [self setPlaymodeButton:nil];
    [self setPlayTypeButton:nil];
    [self setOctaveSelection:nil];
    [self setFlexSpace:nil];
    [self setFixedSpace:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // These can be changed in the settings, so we want to to call them every time the view appears
    _playmode = [self getPlaymode];
    [playmodeButton setImage:imageForPlaymode(_playmode)];
    
    // Fills the selections, subtitles, and choiceIndices arrays
    [self setSelectionsAndChoices];
    
    // If we changed the difficulty level in the settings then we reset the trainer
    if (_currentDifficulty != [self getDifficulty]) {
        [sessionStats resetStats];
        skipButton.enabled = NO;
        _currentSelection = nil;
        _currentDifficulty = [self getDifficulty];
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_playType == PLAYTYPE_TRAIN)
        return _selections.count;
    else
        return [self getAllSelections].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    
    // Training
    if (_playType == PLAYTYPE_TRAIN) {
        if (!_currentSelection)  // If we haven't started training then make the cells gray
            cell.textLabel.textColor = [UIColor lightGrayColor];
        else
            cell.textLabel.textColor = [UIColor blackColor];
        
        cell.textLabel.text = [_selections objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [_subtitles objectAtIndex:indexPath.row];
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
    
    if (_playType == PLAYTYPE_TRAIN) {
        if (!_currentSelection) return;
        NSString *alertTitle, *alertMessage;
        BOOL right;
        
        // choiceIndices is nil if we are on pro difficulty
        NSInteger choiceIndex = (!_choiceIndices) ? indexPath.row : [[_choiceIndices objectAtIndex:indexPath.row] integerValue];
        
        if (_currentSelection.index == choiceIndex) {
            alertTitle = @"Correct";
            alertMessage = [NSString stringWithFormat:@"%@", _currentSelection.longName];
            right = YES;
        } else {
            alertTitle = @"Wrong";
            alertMessage = [NSString stringWithFormat:@"Answer: %@", _currentSelection.longName];
            right = NO;
        }
        [sessionStats addToStats:right];
        
        // Alert the user if he was correct or not
        [[[BSAlert alloc] initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:@"Next" otherButtonTitles:nil, nil] show];
    } else { // Training mode
        // Simply play the note corresponding to the row
        [[SoundEngine sharedInstance] clearEngine];
        [self playCollection:(NoteCollection *)[self getSelectionWithIndex:indexPath.row andOctave:_listeningOctave]];
    }
}

#pragma mark - UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // Select a new interval/chord when the user closes the alert
    if (buttonIndex == 0) {
        _currentSelection = [self getRandomSelection];
        [[SoundEngine sharedInstance] clearEngine]; // Clear space for new notes
        [self playCollection:_currentSelection];
    }
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
    [(UIBarButtonItem *)sender setImage:imageForPlaymode(_playmode)];
}

- (void)play:(id)sender {
    if (!_currentSelection) {
        [[SoundEngine sharedInstance] clearEngine]; // Clear the engine just in case
        _currentSelection = [self getRandomSelection];
        [self.tableView reloadData];
        [skipButton setEnabled:YES];
    }
    [self playCollection:_currentSelection];
}

- (void)skip:(id)sender {
    [[SoundEngine sharedInstance] clearEngine];
    _currentSelection = [self getRandomSelection];
    [self playCollection:_currentSelection];
}

- (void)changePlayType:(id)sender {
    switch (_playType) {
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
    [self.tableView addGestureRecognizer:_pinchGesture];
    [playmodeButton setEnabled:YES];
    if (_playType == PLAYTYPE_TRAIN) [playButton setEnabled:YES];
    if (_currentSelection) [skipButton setEnabled:YES];
    [playTypeButton setEnabled:YES];
}

// When we are viewing the header view certain functions need to be disabled
- (void)disableCommonFunctionality {
    [self.tableView reloadData];
    [self.tableView removeGestureRecognizer:_pinchGesture];
    [playmodeButton setEnabled:NO];
    [playButton setEnabled:NO];
    [skipButton setEnabled:NO];
    [playTypeButton setEnabled:NO];
}

#pragma mark - Play
- (void)playCollection:(NoteCollection *)collection {
    [[SoundEngine sharedInstance] playCollection:collection withTempo:tempoFromType([self getTempo]) andPlayOrder:[self getPlaymode]];
}

#pragma mark - Training mode
- (void)setupTrainingMode {
    _playTypeIsTransitioning = YES;
    
    // Animate in the right toolbar buttons
    [self.navigationController.toolbar setItems:
     [NSArray arrayWithObjects:flexSpace,playmodeButton,playButton,skipButton,fixedSpace,playTypeButton,nil] animated:YES];
    
    if (_choiceIndices) {
        NSMutableArray *rowsToRefresh = [NSMutableArray array];
        for (int i = 0; i < [_selections count]; i++) {
            [rowsToRefresh addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        
        NSMutableArray *rowsToDelete = [NSMutableArray array];
        for (int i = 0; i < [_choiceIndices count]; i++) {
            int currentIndex, nextIndex;
            int spaceForNextIndex = 0;
            if (i != ([_choiceIndices count] - 1)) spaceForNextIndex = 1;
            currentIndex = [[_choiceIndices objectAtIndex:i] intValue];
            nextIndex = [[_choiceIndices objectAtIndex:(i + spaceForNextIndex)] intValue];
            if (currentIndex == nextIndex) {
                for (int j = 1; j <= (([[self getAllSelections] count] - 1) - [[_choiceIndices objectAtIndex:i] intValue]); j++) {
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
            _playTypeIsTransitioning = NO;
        } afterTimeInterval:0.32];
        
    } else {
        NSMutableArray *rowsToRefresh = [NSMutableArray array];
        for (int i = 0; i < [[self getAllSelections] count]; i++) {
            [rowsToRefresh addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [self.tableView reloadRowsAtIndexPaths:rowsToRefresh withRowAnimation:UITableViewRowAnimationFade];
        _playTypeIsTransitioning = NO;
    }
    [self setUsingTrainingButtons:YES];
    [sessionStats resetStats];
}

#pragma mark - Practice mode
- (void)setupPracticeMode {
    _playTypeIsTransitioning = YES;
    
    [self.navigationController.toolbar setItems:
     [NSArray arrayWithObjects:octaveSelection,playmodeButton,flexSpace,playTypeButton,nil] animated:YES];
    
    if (_choiceIndices) {
        NSMutableArray *rowsToRefresh = [NSMutableArray array];
        for (int i = 0; i < [_selections count]; i++) {
            [rowsToRefresh addObject:[NSIndexPath indexPathForRow:[[_choiceIndices objectAtIndex:i] integerValue] inSection:0]];
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
        for (int i = 0; i < [_selections count]; i++) {
            int currentIndex, nextIndex;
            int nextCellIndex = 0;
            UITableViewCell *cell, *nextCell;
            cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if (i != ([_selections count] - 1)) nextCellIndex = 1;
            nextCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(i + nextCellIndex) inSection:0]];
            
            if (cell == nextCell) {
                for (int j = 1; j <= (([[self getAllSelections] count] - 1) - [[_choiceIndices objectAtIndex:i] intValue]); j++) {
                    [rowsToInsert addObject:[NSIndexPath indexPathForRow:([[_choiceIndices objectAtIndex:i] intValue] + j) inSection:0]];
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
            _playTypeIsTransitioning = NO;
        } afterTimeInterval:0.32];
        
    } else {
        NSMutableArray *rowsToRefresh = [NSMutableArray array];
        for (int i = 0; i < [[self getAllSelections] count]; i++) {
            [rowsToRefresh addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [self.tableView reloadRowsAtIndexPaths:rowsToRefresh withRowAnimation:UITableViewRowAnimationFade];
        _playTypeIsTransitioning = NO;
    }
    
    _currentSelection = nil;
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

#pragma mark - Set playtype
// Changes the mode between listening and training
- (void)setPlayType:(PLAYTYPE)type {
    if (_playTypeIsTransitioning) return;
    if (_playType == type) return;
    _playType = type;
    switch (_playType) {
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
        case C2:
            octaveTitle = @"C2";
            _listeningOctave = C2;
            break;
        case C3:
            octaveTitle = @"C3";
            _listeningOctave = C3;
            break;
        case C4:
            octaveTitle = @"C4";
            _listeningOctave = C4;
            break;
        case C5:
            octaveTitle = @"C5";
            _listeningOctave = C5;
            break;
        default:
            // Get rid of the string except for the octave part
            octaveTitle = [octaveSelection.title stringByReplacingOccurrencesOfString:@"Octave: " withString:@""];
            break;
    }
    // For some reason the toolbar resets back to training mode so we have to set it back
    [self.navigationController.toolbar setItems:
     [NSArray arrayWithObjects:octaveSelection,playmodeButton,flexSpace,playTypeButton,nil] animated:NO];
    
    [octaveSelection setTitle:[NSString stringWithFormat:@"Octave: %@", octaveTitle]];
}

#pragma mark - Pinch gesture
- (void)handlePinch:(UIPinchGestureRecognizer *)gesture {
    //    dbgLog(@"pinch scale: %f velocity: %f",pinchGesture.scale,pinchGesture.velocity);
    if (gesture.scale > 1.4 && gesture.velocity > 1.3) [self setPlayType:PLAYTYPE_PRACTICE];
    else if (gesture.scale < 0.6 && gesture.velocity < - 1.3) [self setPlayType:PLAYTYPE_TRAIN];
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
- (id)getRandomSelection {
    return nil;
}

- (id)getSelectionWithIndex:(NSInteger)index andOctave:(NSInteger)octave {
    return nil;
}
@end