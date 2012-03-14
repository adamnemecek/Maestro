//
//  PullRefreshTableViewController.m
//  Plancast
//
//  Created by Leah Culver on 7/2/10.
//  Copyright (c) 2010 Leah Culver
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <QuartzCore/QuartzCore.h>
#import "PullRefreshTableViewController.h"

#define REFRESH_HEADER_HEIGHT 82.0f

@interface PullRefreshTableViewController (Private)
-(void)setupStrings;
-(void)addPullToRefreshHeader;
@end

@implementation PullRefreshTableViewController {
    BOOL isDragging;
    BOOL isShowing;
}

@synthesize statsHeaderView;
@synthesize statsLabel;
@synthesize textPull;
@synthesize textRelease;
@synthesize textLoading;


- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    [self setupStrings];
    return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self addPullToRefreshHeader];
}

- (void)setupStrings{
  textPull = [[NSString alloc] initWithString:@"Pull down to see stats..."];
  textRelease = [[NSString alloc] initWithString:@"Release to see stats..."];
  textLoading = [[NSString alloc] initWithString:@"Stats..."];
}

- (void)addPullToRefreshHeader {
    statsHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
//    refreshHeaderView.backgroundColor = [UIColor clearColor];
    statsHeaderView.backgroundColor = [UIColor underPageBackgroundColor];

    statsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, REFRESH_HEADER_HEIGHT)];
    statsLabel.backgroundColor = [UIColor clearColor];
    statsLabel.font = [UIFont boldSystemFontOfSize:12.0];
    statsLabel.textAlignment = UITextAlignmentCenter;

    [statsHeaderView addSubview:statsLabel];
    [self.tableView addSubview:statsHeaderView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isShowing) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isShowing) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.tableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
            // User is scrolling above the header
            statsLabel.text = self.textRelease;
        } else { // User is scrolling somewhere within the header
            statsLabel.text = self.textPull;
        }
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isShowing) {
        if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT * 0.7)
            [self stopLoading];
    } else {    
        isDragging = NO;
        if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
            // Released above the header
            [self startLoading];
        }
    }
}

- (void)startLoading {
    isShowing = YES;

    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.tableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    statsLabel.text = self.textLoading;
    [UIView commitAnimations];
}

- (void)stopLoading {
    isShowing = NO;

    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    self.tableView.contentInset = UIEdgeInsetsZero;
    UIEdgeInsets tableContentInset = self.tableView.contentInset;
    tableContentInset.top = 0.0;
    self.tableView.contentInset = tableContentInset;
    [UIView commitAnimations];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    statsLabel.text = self.textPull;
}
@end