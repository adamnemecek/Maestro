#import "TipsViewController.h"
#import "UIColor+DesignColors.h"

@implementation TipsViewController


#pragma mark Initialization

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    [self.navigationItem setTitle:@"Tips"];
    self.makeHeader = NO;   // Don't create a pull header for this view
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    [header setBackgroundColor:[UIColor lightGrayColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:header.frame];
    label.text = @"Here are some awesome tips";
    label.textAlignment = UITextAlignmentCenter;
    [label setTextColor:[UIColor whiteColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    [header addSubview:label];
    
    [self.tableView setTableHeaderView:header];
    [self.tableView setBackgroundColor:[UIColor lightGrayColor]];
    
    [self.navigationItem setRightBarButtonItem:nil];
    [self.navigationController setToolbarHidden:YES animated:NO];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    cell.textLabel.text = @"Tip";
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor offWhiteColor]];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end