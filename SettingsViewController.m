#import "SettingsViewController.h"
#import "Defaults.h"

#import "PlaymodeSettingsViewController.h"
#import "RootOctaveSettingsViewController.h"
#import "HighOctaveSettingsViewController.h"
#import "TempoSettingsViewController.h"

#import "ChordPlaymodeSettingsViewController.h"
#import "ChordRootOctaveSettingsViewController.h"
#import "ChordHighOctaveSettingsViewController.h"
#import "ChordTempoSettingsViewController.h"

@implementation SettingsViewController {
    NSArray *selections;
    NSArray *section1Details;
    NSArray *section2Details;
}

@synthesize delegate;

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
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    NSString *playmodeText, *rootOctaveText, *highOctaveText, *tempoText;
    NSString *chordPlaymodeText, *chordRootOctaveText, *chordHighOctaveText, *chordTempoText;
    
    // Interval
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
    
    // Chord
    switch ([[Defaults sharedInstance] getChordPlaymode]) {
        case 0:
            chordPlaymodeText = @"Ascending";
            break;
        case 1:
            chordPlaymodeText = @"Descending";
            break;
        case 2:
            chordPlaymodeText = @"Chord";
            break;
    }
    
    switch ([[Defaults sharedInstance] getChordRootOctave]) {
        case 0:
            chordRootOctaveText = @"C2";
            break;
        case 1:
            chordRootOctaveText = @"C3";
            break;
        case 2:
            chordRootOctaveText = @"C4";
            break;
    }
    
    switch ([[Defaults sharedInstance] getChordHighOctave]) {
        case 0:
            chordHighOctaveText = @"C2";
            break;
        case 1:
            chordHighOctaveText = @"C3";
            break;
        case 2:
            chordHighOctaveText = @"C4";
            break;
        case 3:
            chordHighOctaveText = @"C5";
            break;
    }
    
    switch ([[Defaults sharedInstance] getChordTempo]) {
        case 0:
            chordTempoText = @"Slow";
            break;
        case 1:
            chordTempoText = @"Medium";
            break;
        case 2:
            chordTempoText = @"Fast";
            break;
    }
    
    section1Details = [NSArray arrayWithObjects:playmodeText,rootOctaveText,highOctaveText,tempoText, nil];
    section2Details = [NSArray arrayWithObjects:chordPlaymodeText,chordRootOctaveText,chordHighOctaveText,chordTempoText, nil];
    
    [self.tableView reloadData];
    
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) cell.detailTextLabel.text = [section1Details objectAtIndex:indexPath.row];
    else if (indexPath.section == 1) cell.detailTextLabel.text = [section2Details objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewController *tableViewController;
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0: {
                    tableViewController = [[PlaymodeSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
                }
                    break;
                case 1: {
                    tableViewController = [[RootOctaveSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
                }
                    break;
                case 2: {
                    tableViewController = [[HighOctaveSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
                }
                    break;
                case 3:
                    tableViewController = [[TempoSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0: {
                    tableViewController = [[ChordPlaymodeSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
                }
                    break;
                case 1: {
                    tableViewController = [[ChordRootOctaveSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
                }
                    break;
                case 2: {
                    tableViewController = [[ChordHighOctaveSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
                }
                    break;
                case 3:
                    tableViewController = [[ChordTempoSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
                    break;
            }
            break;
    }
    [self.navigationController pushViewController:tableViewController animated:YES];
}
@end