#import "TipsViewController.h"
#import "Tip.h"

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
    
//    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
//    [header setBackgroundColor:[UIColor clearColor]];
//    UILabel *label = [[UILabel alloc] initWithFrame:header.frame];
//    label.font = [UIFont boldSystemFontOfSize:23.0];
//    label.text = @"Tap on a tip to view it";
//    label.textAlignment = UITextAlignmentCenter;
//    [label setTextColor:[UIColor blackColor]];
//    [label setBackgroundColor:[UIColor clearColor]];
//    [header addSubview:label];
//    
//    [self.tableView setTableHeaderView:header];
    
    [self.navigationItem setRightBarButtonItem:nil];    // Remove settings buttons
    [self.navigationController setToolbarHidden:YES animated:NO];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section  {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [headerView setBackgroundColor:[UIColor offWhiteColor]];
    [headerView setAlpha:0.7];
    
    NSString *header;
    switch (section) {
        case 0:
            header = @"General";
            break;
        case 1:
            header = @"Intervals";
            break;
        case 2:
            header = @"Chords";
            break;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 18)];
    label.center = CGPointMake(label.center.x, 17.5);
    label.font = [UIFont fontWithName:@"Baskerville-Bold" size:20.0];
    label.text = header;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows;
    switch (section) {
        case 0:
            rows = [Tip getGeneralTips].count;
            break;
        case 1:
            rows = [Tip getIntervalTips].count;
            break;
        case 2:
            rows = [Tip getChordTips].count;
            break;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    switch (indexPath.section) {
        case 0:
//            cell.textLabel.text = [NSString stringWithFormat:@"Tip %i",(indexPath.row + 1)];
            cell.detailTextLabel.text = [[Tip getGeneralTips] objectAtIndex:indexPath.row];
            break;
        case 1:
//            cell.textLabel.text = [NSString stringWithFormat:@"Tip %i",(indexPath.row + 1)];
            cell.detailTextLabel.text = [[Tip getIntervalTips] objectAtIndex:indexPath.row];
            break;
        case 2:
//            cell.textLabel.text = [NSString stringWithFormat:@"Tip %i",(indexPath.row + 1)];
            cell.detailTextLabel.text = [[Tip getChordTips] objectAtIndex:indexPath.row];
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor offWhiteColor]];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Tip *selectedTip;
    switch (indexPath.section) {
        case 0:
            selectedTip = [Tip tipWithType:TIP_QUICK atIndex:indexPath.row];
            break;
        case 1:
            selectedTip = [Tip tipWithType:TIP_INTERVAL atIndex:indexPath.row];
            break;
        case 2:
            selectedTip = [Tip tipWithType:TIP_CHORD atIndex:indexPath.row];
            break;
    }
    [selectedTip run];
}
@end