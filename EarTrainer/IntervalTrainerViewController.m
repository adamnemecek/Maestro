#import "IntervalTrainerViewController.h"
#import "Defaults.h"
#import "Interval.h"

@implementation IntervalTrainerViewController

#pragma mark - Initialization and deallocation

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    [self.navigationItem setTitle:@"Interval Trainer"];
    return self;
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selections = [NSArray arrayWithObjects:@"U",@"m2",@"M2",@"m3",@"M3",@"P4",@"P5",@"m6",@"M6",@"m7",@"M7",@"P8", nil];
}

#pragma mark - Overide super

- (PLAYMODE)getPlaymode {
    return [[Defaults sharedInstance] getPlaymode];
}

- (void)savePlaymode:(PLAYMODE)playmode {
    [[Defaults sharedInstance] savePlaymode:playmode];
}

- (id)getRandomSelection {
    return [Interval getRandomInterval];
}

- (id)getSelectionWithIndex:(NSInteger)index {
    return [[Interval alloc] initInterval:index];
}
@end