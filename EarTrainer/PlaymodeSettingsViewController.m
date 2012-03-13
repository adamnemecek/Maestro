#import "PlaymodeSettingsViewController.h"
#import "Defaults.h"

@implementation PlaymodeSettingsViewController {
    NSArray *playmodes;
    NSIndexPath *currentCellPath;
}

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    self.title = @"Playmode";
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    playmodes = [NSArray arrayWithObjects:@"Ascending",@"Descending",@"Chord",nil];
}

- (void)viewDidUnload
{
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [playmodes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    cell.textLabel.text = [playmodes objectAtIndex:indexPath.row];
    if (indexPath.row == [self getPlaymode]) {
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
    [self savePlaymode:indexPath.row];
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    currentCellPath = indexPath;
}

#pragma mark - overiding methods

- (NSInteger)getPlaymode {
    return [[Defaults sharedInstance] getPlaymode];
}

- (void)savePlaymode:(NSInteger)playmode {
    [[Defaults sharedInstance] savePlaymode:playmode];
}
@end