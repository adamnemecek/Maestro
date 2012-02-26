#import "IntervalTrainerViewController.h"

@implementation IntervalTrainerViewController

#pragma mark - Initialization and deallocation

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selections = [NSArray arrayWithObjects:@"U",@"m2",@"M2",@"m3",@"M3",@"P4",@"P5",@"m6",@"M6",@"m7",@"M7",@"P8", nil];
}
@end