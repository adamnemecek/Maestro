#import "ChordTrainerViewController.h"
#import "Defaults.h"
#import "Chord.h"

@implementation ChordTrainerViewController

#pragma mark - Initialization and deallocation

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    [self.navigationItem setTitle:@"Chord Trainer"];
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selections = [NSArray arrayWithObjects:@"minor", @"major", @"augmented", @"diminished", nil];
}

#pragma mark - Defaults

- (PLAYMODE)getPlaymode {
    return PLAYMODE_CHORD;
}

- (void)savePlaymode:(PLAYMODE)playmode {
    
}

- (id)getRandomSelection {
    return [Chord getRandomChord];
}

- (id)getSelectionWithIndex:(NSInteger)index {
    return [[Chord alloc] initChord:index];
}
@end