#import "SettingsViewController.h"
#import "Defaults.h"

@implementation SettingsViewController

@synthesize delegate;
@synthesize playmodeDetail;
@synthesize rootOctaveDetail;
@synthesize highOctaveDetail;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [self setPlaymodeDetail:nil];
    [self setRootOctaveDetail:nil];
    [self setHighOctaveDetail:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    NSString *playmodeText;
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
    playmodeDetail.text = playmodeText;
    
    NSString *rootOctaveText;
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
    rootOctaveDetail.text = rootOctaveText;
    
    NSString *highOctaveText;
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
    highOctaveDetail.text = highOctaveText;
    
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
- (IBAction)done:(id)sender {
    [self.delegate SettingsViewControllerDidFinish:self];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end