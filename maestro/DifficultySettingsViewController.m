#import "DifficultySettingsViewController.h"

@implementation DifficultySettingsViewController {
    NSArray *difficultyLevels;
    NSIndexPath *currentCellPath;
}

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    self.title = @"Difficulty";
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    difficultyLevels = [NSArray arrayWithObjects:@"Beginner", @"Intermediate", @"Pro", nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [difficultyLevels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.textLabel.text = [difficultyLevels objectAtIndex:indexPath.row];
    if (indexPath.row == [self getDifficulty]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        currentCellPath = indexPath;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:currentCellPath];
    oldCell.accessoryType = UITableViewCellAccessoryNone;
    [self saveDifficulty:indexPath.row];
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    currentCellPath = indexPath;
}

#pragma mark - Overide methods

- (NSInteger)getDifficulty {
    return [[Defaults sharedInstance] getChallengeLevel];
}

- (void)saveDifficulty:(NSInteger)difficulty {
    [[Defaults sharedInstance] saveChallengeLevel:difficulty];
}
@end