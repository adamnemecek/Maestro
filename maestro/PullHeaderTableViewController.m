#import "PullHeaderTableViewController.h"

@interface PullHeaderTableViewController (Private)
-(void)addPullToRefreshHeader;
@end

@implementation PullHeaderTableViewController {
    NSString *textPull;
    NSString *textRelease;
    NSString *textShowing;
    BOOL isDragging;
}
@synthesize headerView;
@synthesize headerLabel;
@synthesize makeHeader;
@synthesize isShowing;

#pragma mark - Initialization
- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    [self setupStringForPull:@"Pull down to see awesome..." release:@"Release to see awesome..." andShowing:@"Awesome..."];
    makeHeader = YES;   // Set to no in init to cancel the header
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isDragging = NO;
    isShowing  = NO;
    [self addPullToRefreshHeader];
}

#pragma mark - Set up
- (void)setupStringForPull:(NSString *)pullString release:(NSString *)releaseString andShowing:(NSString *)showingString {
    textPull = pullString;
    textRelease = releaseString;
    textShowing = showingString;
}

- (void)addPullToRefreshHeader {
    if (!makeHeader) return;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - HEADER_HEIGHT, 320, HEADER_HEIGHT)];
    headerView.backgroundColor = [UIColor offWhiteColor];

    headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, HEADER_HEIGHT)];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:12.0];
    headerLabel.textAlignment = UITextAlignmentCenter;
    
    [headerView addSubview:headerLabel];
    [self.tableView addSubview:headerView];
}

#pragma mark update header
- (void)refreshHeader {
    for (UIView *view in headerView.subviews)
        [view removeFromSuperview];
}

#pragma mark - Dragging
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isShowing || !makeHeader) return;
    [self refreshHeader];
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!makeHeader) return;
    if (isDragging && scrollView.contentOffset.y < 0) {
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < -HEADER_HEIGHT * HEADER_SHOW_MARGIN_SCALAR) headerLabel.text = textRelease;  // User is scrolling above the header
        else headerLabel.text = textPull;                                                                             // User is scrolling somewhere within the header
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!makeHeader) return;
    isDragging = NO;
    if (!isShowing) {
        if (scrollView.contentOffset.y <= -HEADER_HEIGHT * HEADER_SHOW_MARGIN_SCALAR) [self showHeader];
    } else {
        if (scrollView.contentOffset.y >= -HEADER_HEIGHT * HEADER_HIDE_MARGIN_SCALAR) {
            [self hideHeader];
        } else if (scrollView.contentOffset.y <= -HEADER_HEIGHT * HEADER_HIDE_MARGIN_SCALAR && scrollView.contentOffset.y >= -HEADER_HEIGHT) {
            [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, -HEADER_HEIGHT) animated:YES];
        }
    }
}

#pragma mark - Stats
- (void)showHeader {
    isShowing = YES;
    [self disableCommonFunctionality];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.tableView.contentInset = UIEdgeInsetsMake(HEADER_HEIGHT, 0, 0, 0);
    headerLabel.text = textShowing;
    [UIView commitAnimations];
}

- (void)hideHeader {
    isShowing = NO;
    [self enableCommonFunctionality];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(hideStatsComplete:finished:context:)];
    self.tableView.contentInset = UIEdgeInsetsZero;
    [UIView commitAnimations];
}

- (void)hideStatsComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    headerLabel.text = textPull;
}

#pragma mark sublcass methods
- (void)enableCommonFunctionality {
    
}

- (void)disableCommonFunctionality {
    
}
@end