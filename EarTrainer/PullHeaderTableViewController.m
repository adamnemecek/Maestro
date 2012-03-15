#import <QuartzCore/QuartzCore.h>
#import "PullHeaderTableViewController.h"

@interface PullHeaderTableViewController (Private)
-(void)setupStrings;
-(void)addPullToRefreshHeader;
@end

@implementation PullHeaderTableViewController {
    UIView *statsHeaderView;
    NSString *textPull;
    NSString *textRelease;
    NSString *textShowing;
    BOOL isDragging;
}
@synthesize statsLabel;
@synthesize makeHeader;
@synthesize isShowing;

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    [self setupStrings];
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

- (void)setupStrings{
    textPull = [[NSString alloc] initWithString:@"Pull down to see stats..."];
    textRelease = [[NSString alloc] initWithString:@"Release to see stats..."];
    textShowing = [[NSString alloc] initWithString:@"Stats..."];
}

- (void)addPullToRefreshHeader {
    if (!makeHeader) return;
    statsHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - HEADER_HEIGHT, 320, HEADER_HEIGHT)];
    statsHeaderView.backgroundColor = [UIColor underPageBackgroundColor];

    statsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, HEADER_HEIGHT)];
    statsLabel.backgroundColor = [UIColor clearColor];
    statsLabel.font = [UIFont boldSystemFontOfSize:12.0];
    statsLabel.textAlignment = UITextAlignmentCenter;
    
    [statsHeaderView addSubview:statsLabel];
    [self.tableView addSubview:statsHeaderView];
}

#pragma mark - Dragging

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isShowing || !makeHeader) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (!makeHeader) return;
    if (isDragging && scrollView.contentOffset.y < 0) {
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < -HEADER_HEIGHT * HEADER_SHOW_MARGIN_SCALAR) statsLabel.text = textRelease;  // User is scrolling above the header
        else statsLabel.text = textPull;                                                       // User is scrolling somewhere within the header
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!makeHeader) return;
    isDragging = NO;
    if (!isShowing) {
        if (scrollView.contentOffset.y <= -HEADER_HEIGHT * HEADER_SHOW_MARGIN_SCALAR) [self showStats];
    } else {
        if (scrollView.contentOffset.y >= -HEADER_HEIGHT * HEADER_HIDE_MARGIN_SCALAR) {
            [self hideStats];
        } else if (scrollView.contentOffset.y <= -HEADER_HEIGHT * HEADER_HIDE_MARGIN_SCALAR && scrollView.contentOffset.y >= -HEADER_HEIGHT) {
            [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, -HEADER_HEIGHT) animated:YES];
        }
    }
}

#pragma mark - Stats

- (void)showStats {
    isShowing = YES;
    [self disableCommonFunctionality];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.tableView.contentInset = UIEdgeInsetsMake(HEADER_HEIGHT, 0, 0, 0);
    statsLabel.text = textShowing;
    [UIView commitAnimations];
}

- (void)hideStats {
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
    statsLabel.text = textPull;
}

#pragma mark sublcass methods

- (void)enableCommonFunctionality {
    
}

- (void)disableCommonFunctionality {
    
}
@end