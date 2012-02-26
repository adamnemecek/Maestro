#import "ChordTrainerViewController.h"

@implementation ChordTrainerViewController

#pragma mark - Initialization and deallocation

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selections = [NSArray arrayWithObjects:@"minor-major seventh", nil];
}
@end