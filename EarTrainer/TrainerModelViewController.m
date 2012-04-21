#import "TrainerModelViewController.h"
#import "Stats.h"
#import "SoundEngine.h"
#import "NoteCollection.h"

@interface TrainerModelViewController (Private)
-(UIImage *)getCurrentPlaymodeImage;
-(void)setPlayType:(PLAYTYPE)type;
-(void)setUsingTrainingButtons:(BOOL)using;
-(void)setPlayTypeTransitionDone;
-(void)handlePinch:(UIPinchGestureRecognizer *)gesture;
@end

@implementation TrainerModelViewController {
    PLAYMODE playmodeIndex;
    PLAYTYPE playType;
    NoteCollection *currentSelection;
    BOOL playTypeIsTransitioning;
    UIPinchGestureRecognizer *pinchGesture;
    Stats *sessionStats;
}
@synthesize playButton, skipButton, playmodeButton, playTypeButton;
@synthesize selections;
@synthesize subtitles;
@synthesize choiceIndices;

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup pinch gesture recognizer
    pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    [self.tableView addGestureRecognizer:pinchGesture];
    
    // Setup stats object
    sessionStats = [Stats new];
    
    // Setup header strings
    [self setupStringForPull:@"Pull to see stats..." release:@"Release see stats..." andShowing:@"stats..."];
    
    // Show toolbar
    [self.navigationController setToolbarHidden:NO animated:NO];
    
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
    
    playTypeIsTransitioning = NO;
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
    [[SoundEngine sharedInstance] setAlive:YES];
    playmodeIndex = [self getPlaymode];
    [playmodeButton setImage:[self getCurrentPlaymodeImage]];
    [self setSelectionsAndChoices];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[SoundEngine sharedInstance] setAlive:NO];
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
    NSInteger rows = [selections count];
    if (playType == PLAYTYPE_TRAIN) rows = [selections count];
    else rows = [[self getAllSelections] count];
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    if (!currentSelection && playType == PLAYTYPE_TRAIN) cell.textLabel.textColor = [UIColor lightGrayColor];
    else {
        cell.textLabel.text = [[self getAllSelectionsAbbreviated] objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor blackColor];
//        cell.detailTextLabel.text = [[self getAllSelections] objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [[self getSelectionWithIndex:indexPath.row] getNoteNames];
    }
    if (playType == PLAYTYPE_TRAIN) {
        cell.textLabel.text = [selections objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [subtitles objectAtIndex:indexPath.row];
    }
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
    BOOL right;
    if (playType == PLAYTYPE_TRAIN) {
        if (!currentSelection) return;
        NSString *alertTitle, *alertMessage;
        NSInteger choiceIndex = (!choiceIndices) ? indexPath.row : [[choiceIndices objectAtIndex:indexPath.row] integerValue];
        if (currentSelection.index == choiceIndex) {
            alertTitle = @"Correct";
            right = YES;
        }
        else {
            alertTitle = @"Wrong";
            right = NO;
        }
        [sessionStats addToStats:right];
        alertMessage = [NSString stringWithFormat:@"%@", currentSelection.longName];
        [[[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:self cancelButtonTitle:@"Next" otherButtonTitles:nil, nil] show];
    } else {
        [self playCollection:(NoteCollection *)[self getSelectionWithIndex:indexPath.row]];
    }
}

#pragma mark - UIAlertView delegate

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

#pragma mark - Playtype transition

- (void)setPlayTypeTransitionDone {
    playTypeIsTransitioning = NO;
}

#pragma mark - Refresh rows

- (void)refreshRows:(NSArray *)rowsToRefresh {
    [self.tableView reloadRowsAtIndexPaths:rowsToRefresh withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Training mode

- (void)setupTrainingMode {
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
        [self performSelector:@selector(refreshRows:) withObject:rowsToRefresh afterDelay:0.31]; 
        [self performSelector:@selector(setPlayTypeTransitionDone) withObject:nil afterDelay:0.32];
    } else {
        NSMutableArray *rowsToRefresh = [NSMutableArray array];
        for (int i = 0; i < [[self getAllSelections] count]; i++) {
            [rowsToRefresh addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        [self.tableView reloadRowsAtIndexPaths:rowsToRefresh withRowAnimation:UITableViewRowAnimationFade];
        playTypeIsTransitioning = NO;
    }
    [self setUsingTrainingButtons:YES];
}

#pragma mark - Practice mode

- (void)setupPracticeMode {
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
        [self performSelector:@selector(refreshRows:) withObject:rowsToRefresh afterDelay:0.31];
        [self performSelector:@selector(setPlayTypeTransitionDone) withObject:nil afterDelay:0.32];
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
    if (playTypeIsTransitioning) return;
    if (playType == type) return;
    playType = type;
    switch (playType) {
        case PLAYTYPE_TRAIN:
            [playTypeButton setTitle:@"Practice"];
            [self setupTrainingMode];
            break;
        case PLAYTYPE_PRACTICE:
            [playTypeButton setTitle:@"Train"];
            [self setupPracticeMode];
            break;
    }
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
            [self setPlayType:PLAYTYPE_PRACTICE];
            break;
        case PLAYTYPE_PRACTICE:
            [self setPlayType:PLAYTYPE_TRAIN];
            break;
    }
}

#pragma mark - Overide pull header methods

- (void)refreshHeader {
    [super refreshHeader];
    
    //Build stats view
    UIView *percentView = [[UIView alloc] initWithFrame:CGRectMake(self.headerView.frame.size.width  * 0.3,
                                                                   self.headerView.frame.size.height * 0.30,
                                                                   self.headerView.frame.size.width  * 0.4,
                                                                   self.headerView.frame.size.height * 0.40)];
    [percentView setBackgroundColor:[UIColor statsRightColor]];
    
    UIView *percentWrong = [[UIView alloc] initWithFrame:CGRectMake(percentView.frame.origin.x + (percentView.frame.size.width * (1.0 - [sessionStats getPercentWrong])),
                                                                    self.headerView.frame.size.height * 0.30,
                                                                    percentView.frame.size.width * [sessionStats getPercentWrong],
                                                                    self.headerView.frame.size.height * 0.40)];
    [percentWrong setBackgroundColor:[UIColor statsWrongColor]];
                           
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
    [right setTextColor:[UIColor statsRightColor]];
    [wrong setTextColor:[UIColor statsWrongColor]];
    [self.headerView addSubview:right];
    [self.headerView addSubview:wrong];
    [self.headerView addSubview:percentWrong];
    [self.headerView insertSubview:percentView belowSubview:percentWrong];
}

- (void)enableCommonFunctionality {
    [self.tableView reloadData];
    [self.tableView addGestureRecognizer:pinchGesture];
    [playmodeButton setEnabled:YES];
    [playButton setEnabled:YES];
    if (currentSelection) [skipButton setEnabled:YES];
    [playTypeButton setEnabled:YES];
}
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
//    NSLog(@"pinch scale: %f velocity: %f",pinchGesture.scale,pinchGesture.velocity);    
    if (gesture.scale > 1.4 && gesture.velocity > 1.3) [self setPlayType:PLAYTYPE_PRACTICE];
    else if (gesture.scale < 0.6 && gesture.velocity < - 1.3) [self setPlayType:PLAYTYPE_TRAIN];
}
@end