#import "ChordTrainerViewController.h"
#import "Defaults.h"
#import "Chord.h"

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