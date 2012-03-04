#import "SettingsViewController.h"
#import "Defaults.h"

@implementation SettingsViewController {
    NSArray *selections;
    NSArray *selectionDetails;
}

@synthesize delegate;
@synthesize playmodeDetail;
@synthesize rootOctaveDetail;
@synthesize highOctaveDetail;
@synthesize tempoDetail;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    [self.navigationItem setTitle:@"Settings"];
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    selections = [NSArray arrayWithObjects:@"Playmode",@"Root Octave",@"High Octave",@"Tempo", nil];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)]];
}

- (void)viewDidUnload {
    [self setPlaymodeDetail:nil];
    [self setRootOctaveDetail:nil];
    [self setHighOctaveDetail:nil];
    [self setTempoDetail:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    NSString *playmodeText, *rootOctaveText, *highOctaveText, *tempoText;
    switch ([[Defaults sharedInstance] getPlaymode]) {
        case 0:
            playmodeText = @"Ascending";
            break;
        case 1:
            playmodeText = @"Descending";
            break;
        case 2:
            playmodeText = @"Chord";
            break;
    }
    
    switch ([[Defaults sharedInstance] getRootOctave]) {
        case 0:
            rootOctaveText = @"C2";
            break;
        case 1:
            rootOctaveText = @"C3";
            break;
        case 2:
            rootOctaveText = @"C4";
            break;
    }

    switch ([[Defaults sharedInstance] getHighOctave]) {
        case 0:
            highOctaveText = @"C2";
            break;
        case 1:
            highOctaveText = @"C3";
            break;
        case 2:
            highOctaveText = @"C4";
            break;
        case 3:
            highOctaveText = @"C5";
            break;
    }
    
    switch ([[Defaults sharedInstance] getTempo]) {
        case 0:
            tempoText = @"Slow";
            break;
        case 1:
            tempoText = @"Medium";
            break;
        case 2:
            tempoText = @"Fast";
            break;
    }
    
    selectionDetails = [NSArray arrayWithObjects:playmodeText,rootOctaveText,highOctaveText,tempoText, nil];
    
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

#pragma mark - Actions
- (void)done:(id)sender {
    [self.delegate SettingsViewControllerDidFinish:self];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) return @"Interval Training";
    else return @"Chord Training";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    cell.textLabel.text = [selections objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [selectionDetails objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end