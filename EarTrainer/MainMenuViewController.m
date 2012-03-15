#import "MainMenuViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "IntervalTrainerViewController.h"
#import "ChordTrainerViewController.h"
#import "TipsViewController.h"

#import "MainMenuCell.h"

@implementation MainMenuViewController {
    NSArray *section1;
    NSArray *section2;
}

@synthesize delegate;
@synthesize currentIndexPath = _currentIndexPath;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    section1 = [NSArray arrayWithObjects:@"Interval Trainer", @"Chord Trainer", nil];
    section2 = [NSArray arrayWithObjects:@"Tips", @"About", nil];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

- (void)viewDidUnload {
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

//#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rows;
    switch (section) {
        case 0:
            rows = [section1 count];
            break;
        case 1:
            rows = [section2 count];
            break;
    }
    return rows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle;
    switch (section) {
        case 0:
            sectionTitle = @"Ear Training";
            break;
        case 1:
            sectionTitle = @"About";
            break;
    }
    return sectionTitle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainMenuCell *cell = (MainMenuCell *)[tableView dequeueReusableCellWithIdentifier:[MainMenuCell reuseIdentifier]];
    if (!cell) cell = [[[NSBundle mainBundle] loadNibNamed:[MainMenuCell nibName] owner:self options:nil] objectAtIndex:0];
    if (!_currentIndexPath && indexPath.row == 0) _currentIndexPath = indexPath;
    switch (indexPath.section) {
        case 0:
            cell.viewTitle.text = [section1 objectAtIndex:indexPath.row];
            break;
        case 1:
            cell.viewTitle.text = [section2 objectAtIndex:indexPath.row];
            break;
    }
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    MainMenuCell *cell = (MainMenuCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//    return cell.frame.size.height + MENU_CELL_MARGIN;
//    return (MENU_CELL_HEIGHT + MENU_CELL_MARGIN);
//}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor whiteColor]];
}

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
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    selectedViewController = [[TipsViewController alloc] initWithStyle:UITableViewStylePlain];
                    break;
                case 1:
                    [self.delegate mainMenuSelectedCurrentView:self];
                    return;
                    break;
            }
            break;
    }
    _currentIndexPath = indexPath;
    [self.delegate mainMenu:self didSelectViewController:selectedViewController];
}
@end