#import "RootOctaveSettingsViewController.h"

@implementation RootOctaveSettingsViewController

@synthesize octaves = _octaves;
@synthesize currentCellPath = _currentCellPath;

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    self.title = @"Root Octave";
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _octaves = [NSArray arrayWithObjects:@"C2",@"C3",@"C4", nil];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_octaves count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    cell.textLabel.text = [_octaves objectAtIndex:indexPath.row];
    if (indexPath.row == [self getOctaveSelection]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        _currentCellPath = indexPath;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![self checkOctave:indexPath.row]) return;
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:_currentCellPath];
    oldCell.accessoryType = UITableViewCellAccessoryNone;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    _currentCellPath = indexPath;
    if ([self checkOctave:indexPath.row]) [self saveOctaveSelection:indexPath.row];
}

#pragma mark - defaults

- (NSInteger)getOctaveSelection {
    return [[Defaults sharedInstance] getRootOctave];
}

- (NSInteger)getOtherOctave {
    return [[Defaults sharedInstance] getHighOctave];
}

- (BOOL)checkOctave:(NSInteger)octaveIndex {
    if (octaveIndex <= [self getOtherOctave]) return YES;
    else {
        [[[UIAlertView alloc] initWithTitle:@"Can't select this octave" message:@"This octave is higher than your current high octave" delegate:nil
                          cancelButtonTitle:@"Okay" otherButtonTitles:nil] show];
        return NO;
    }
}

- (void)saveOctaveSelection:(NSInteger)selection {
    [[Defaults sharedInstance] saveRootOctave:selection];
}

@end
