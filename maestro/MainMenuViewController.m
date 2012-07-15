#import "MainMenuViewController.h"
#import "IntervalTrainerViewController.h"
#import "ChordTrainerViewController.h"
#import "TipsViewController.h"
#import "AboutViewController.h"

#import "MainMenuCell.h"

@implementation MainMenuViewController {
    NSArray *_items;
    BOOL _selected;
}

@synthesize delegate;
@synthesize currentIndexPath = _currentIndexPath;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _items = [NSArray arrayWithObjects:@"Interval Trainer", @"Chord Trainer", @"Tips", @"About", nil];
    
    _selected = NO;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_texture.png"]];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MainMenuCell *cell = (MainMenuCell *)[tableView dequeueReusableCellWithIdentifier:[MainMenuCell reuseIdentifier]];
    if (!cell) cell = [[[NSBundle mainBundle] loadNibNamed:[MainMenuCell nibName] owner:self options:nil] objectAtIndex:0];
    if (!_currentIndexPath && indexPath.row == 0) _currentIndexPath = indexPath;
    cell.viewTitle.text = [_items objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return MENU_CELL_HEIGHT;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    [cell setBackgroundColor:[UIColor clearColor]];
//}

#pragma mark - Deselection
- (void)deselect {
    _selected = NO;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (!_selected) {
        _selected = YES;
        if ([indexPath isEqual:_currentIndexPath]) {
            [self.delegate mainMenuSelectedCurrentView:self];
            return;
        }
        
        UIViewController *selectedViewController;
        switch (indexPath.section) {
            case 0:
                switch (indexPath.row) {
                    case 0:
                        selectedViewController = [[IntervalTrainerViewController alloc] init];
                        break;
                    case 1:
                        selectedViewController = [[ChordTrainerViewController alloc] init];
                        break;
                    case 2:
                        selectedViewController = [[TipsViewController alloc] init];
                        break;
                    case 3:
                        selectedViewController = [[AboutViewController alloc] init];
                        break;
                }
                break;
        }
        _currentIndexPath = indexPath;
        [self.delegate mainMenu:self didSelectViewController:selectedViewController];
    }
}
@end