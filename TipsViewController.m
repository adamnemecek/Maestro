#import "TipsViewController.h"

@implementation TipsViewController {
    NSArray *tips;
//    Tip *selectedTip;
}

#pragma mark Initialization

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    [self.navigationItem setTitle:@"Tips"];
    self.makeHeader = NO;   // Don't create a pull header for this view
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *tipDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Tips" ofType:@"plist"]];
    tips = [tipDict objectForKey:@"Tips"];
    
//    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
//    [header setBackgroundColor:[UIColor lightGrayColor]];
//    UILabel *label = [[UILabel alloc] initWithFrame:header.frame];
//    label.text = @"Here are some awesome tips";
//    label.textAlignment = UITextAlignmentCenter;
//    [label setTextColor:[UIColor whiteColor]];
//    [label setBackgroundColor:[UIColor clearColor]];
//    [header addSubview:label];
    
//    [self.tableView setTableHeaderView:header];
//    [self.tableView setBackgroundColor:[UIColor lightGrayColor]];
    
    [self.navigationItem setRightBarButtonItem:nil];    // Remove settings buttons
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
    return tips.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"Tip %i",(indexPath.row + 1)];
    cell.detailTextLabel.text = [tips objectAtIndex:indexPath.row];
    return cell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    [cell setBackgroundColor:[UIColor offWhiteColor]];
//}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Tip *selectedTip = [Tip tipAtIndex:indexPath.row];
    selectedTip.alpha = 0.0;
    [selectedTip setDelegate:self];
    [[UIApplication sharedApplication].keyWindow addSubview:selectedTip];
    [self.navigationController.view setUserInteractionEnabled:NO];
    
    [UIView animateWithDuration:0.5
                     animations:^{
        selectedTip.alpha = 1.0;
    } completion:nil];
}

#pragma mark - Tip delegate

- (void)TipPresentationFinished:(Tip *)tip {
    [self.navigationController.view setUserInteractionEnabled:YES];
    [tip removeFromSuperview];
}
@end