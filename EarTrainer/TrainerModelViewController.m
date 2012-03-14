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
@synthesize subtitles;
@synthesize choiceIndices;

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
    [self setSelectionsAndChoices];
    [self.tableView reloadData];
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
    NSInteger rows;
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
        cell.detailTextLabel.text = [[self getAllSelections] objectAtIndex:indexPath.row];
    }
    if (playType == PLAYTYPE_TRAIN) {
        cell.textLabel.text = [selections objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [subtitles objectAtIndex:indexPath.row];
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (playType == PLAYTYPE_TRAIN) {
        if (!currentSelection) return;
        NSString *alertTitle, *alertMessage;
        NSInteger choiceIndex = (!choiceIndices) ? indexPath.row : [[choiceIndices objectAtIndex:indexPath.row] integerValue];
        if (currentSelection.index == choiceIndex) alertTitle = @"Correct";
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

#pragma mark - Training mode

- (void)setupTrainingMode {
    
    NSMutableArray *rowsToDelete = [NSMutableArray array];
    for (int i = 0; i < ([choiceIndices count] - 1); i++) {
//        NSLog(@"i: %i",i);
        int currentIndex;
        int nextIndex;
        
//        NSLog(@"%i", [[self getAllSelections] count]);
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[[choiceIndices objectAtIndex:i] integerValue] inSection:0]];
        UITableViewCell *nextCell;
        
//        NSLog(@"next cell index: %i",[[choiceIndices objectAtIndex:(i + 1)] integerValue]);
        
        if (i != ([choiceIndices count] - 1))
            nextCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[[choiceIndices objectAtIndex:(i + 1)] integerValue] inSection:0]];
        for (int j = 0; j < [[self getAllSelectionsAbbreviated] count]; j++) {            
//            NSLog(@"cell text: %@",cell.textLabel.text);
//            NSLog(@"next cell text: %@",nextCell.textLabel.text);
//            NSLog(@"selection: %@",[[self getAllSelectionsAbbreviated] objectAtIndex:j]);
            if ([cell.textLabel.text isEqualToString:[[self getAllSelectionsAbbreviated] objectAtIndex:j]]) {
                currentIndex = j;
            }
            if ([nextCell.textLabel.text isEqualToString:[[self getAllSelectionsAbbreviated] objectAtIndex:j]]) {
                nextIndex = j;
            }
        }
        if (!nextCell) nextIndex = ([[self getAllSelectionsAbbreviated] count] - 1);
//        NSLog(@"current index: %i",currentIndex);
//        NSLog(@"next index: %i",nextIndex);
        if (nextIndex - currentIndex != 1) {
            for (int k = 1; k < (nextIndex - currentIndex); k++) {
//                NSLog(@"index path: %@",[NSIndexPath indexPathForRow:(currentIndex + k) inSection:0]);
                [rowsToDelete addObject:[NSIndexPath indexPathForRow:(currentIndex + k) inSection:0]];
            }
        }
    }
    
//    NSLog(@"%@",rowsToDelete);
    
    
//    for (int i = 0; i < ([[self getAllSelections] count] - [selections count]); i++) {
//        [rowsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:0]];
//    }
    [self.tableView deleteRowsAtIndexPaths:rowsToDelete withRowAnimation:UITableViewRowAnimationAutomatic];
//    [self.tableView reloadData];
    
    [self.navigationItem setPrompt:nil];
    [self setUsingTrainingButtons:YES];
}

#pragma mark - Practice mode

- (void)setupPracticeMode {
    //IDEA: Animate any extra cells in
    
//    [self.tableView beginUpdates];
//    [self.tableView endUpdates];
    
    // TODO: make simpler using choiceIndices instead of selections?
    
    /***
     * For each cell we find its index in context of all selections
     * We then find the next cell's index in context of all selections
     * Then we subtract the next cell's index from the first's and if there is a difference greater than one we know to add cells there
     * So we loop through the difference between cell indeces and create an indexPath for each one which row is the
     * first cell's index + current iteration
     ***/
    NSMutableArray *newRows = [NSMutableArray array];
    for (int i = 0; i < [selections count]; i++) {
        int currentIndex;
        int nextIndex;
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UITableViewCell *nextCell;
        if (i != ([selections count] - 1))
            nextCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(i + 1) inSection:0]];
        for (int j = 0; j < [[self getAllSelectionsAbbreviated] count]; j++) {            
//            NSLog(@"cell text: %@",cell.textLabel.text);
//            NSLog(@"next cell text: %@",nextCell.textLabel.text);
//            NSLog(@"selection: %@",[[self getAllSelectionsAbbreviated] objectAtIndex:j]);
            if ([cell.textLabel.text isEqualToString:[[self getAllSelectionsAbbreviated] objectAtIndex:j]]) {
                currentIndex = j;
            }
            if ([nextCell.textLabel.text isEqualToString:[[self getAllSelectionsAbbreviated] objectAtIndex:j]]) {
                nextIndex = j;
            }
        }
//        NSLog(@"current index: %i",currentIndex);
//        NSLog(@"next index: %i",nextIndex);
        if (nextIndex - currentIndex != 1) {
            for (int k = 1; k < (nextIndex - currentIndex); k++) {
//                NSLog(@"index path: %@",[NSIndexPath indexPathForRow:(currentIndex + k) inSection:0]);
                [newRows addObject:[NSIndexPath indexPathForRow:(currentIndex + k) inSection:0]];
            }
        }
    }
    
//    NSLog(@"%@",newRows);
    
    [self.tableView insertRowsAtIndexPaths:newRows withRowAnimation:UITableViewRowAnimationAutomatic];
    
//    [self.tableView reloadRowsAtIndexPaths:newRows withRowAnimation:UITableViewRowAnimationNone];
    
//    for (int i = 0; i < ([[self getAllSelections] count] - [selections count]); i++) {
//        [newRows addObject:[NSIndexPath indexPathForRow:i inSection:0]];
//    }    
    
//    for (int i = 1; i <= 3; i++) {
//        [newRows addObject:[NSIndexPath indexPathForRow:i inSection:0]];
//    }

    
    
    currentSelection = nil;
//    self.navigationItem.prompt = @"";
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