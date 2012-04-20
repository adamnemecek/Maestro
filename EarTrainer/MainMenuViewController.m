#import "MainMenuViewController.h"
#import "IntervalTrainerViewController.h"
#import "ChordTrainerViewController.h"
#import "TipsViewController.h"
#import "AboutViewController.h"

#import "MainMenuCell.h"

@implementation MainMenuViewController {
    NSArray *items;
}

@synthesize delegate;
@synthesize currentIndexPath = _currentIndexPath;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    items    = [NSArray arrayWithObjects:@"Interval Trainer", @"Chord Trainer", @"Tips", @"About", nil];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[UIColor darkGrayColor]];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainMenuCell *cell = (MainMenuCell *)[tableView dequeueReusableCellWithIdentifier:[MainMenuCell reuseIdentifier]];
    if (!cell) cell = [[[NSBundle mainBundle] loadNibNamed:[MainMenuCell nibName] owner:self options:nil] objectAtIndex:0];
    if (!_currentIndexPath && indexPath.row == 0) _currentIndexPath = indexPath;
    cell.viewTitle.text = [items objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MENU_CELL_HEIGHT;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    [cell setBackgroundColor:[UIColor clearColor]];
//}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([indexPath isEqual:_currentIndexPath]) {
        [self.delegate mainMenuSelectedCurrentView:self];
        return;
    }
    
    UIViewController *selectedViewController;
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    selectedViewController = [[IntervalTrainerViewController alloc] initWithStyle:UITableViewStylePlain];
                    break;
                case 1:
                    selectedViewController = [[ChordTrainerViewController alloc] initWithStyle:UITableViewStylePlain];
                    break;
                case 2:
                    selectedViewController = [[TipsViewController alloc] initWithStyle:UITableViewStylePlain];
                    break;
                case 3:
                    selectedViewController = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
//                    [self.delegate mainMenuSelectedCurrentView:self];
//                    return;
                    break;
            }
            break;
    }
    _currentIndexPath = indexPath;
    [self.delegate mainMenu:self didSelectViewController:selectedViewController];
}
@end