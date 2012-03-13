#import "MainMenuViewController.h"
#import "IntervalTrainerViewController.h"
#import "ChordTrainerViewController.h"
#import "TipsViewController.h"

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
    return 2;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    if (!_currentIndexPath && indexPath.row == 0) _currentIndexPath = indexPath;
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = [section1 objectAtIndex:indexPath.row];
            break;
        case 1:
            cell.textLabel.text = [section2 objectAtIndex:indexPath.row];
            break;
    }
    return cell;
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