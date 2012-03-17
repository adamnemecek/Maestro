#import "ChordTrainerViewController.h"
#import "Defaults.h"
#import "Chord.h"

@implementation ChordTrainerViewController

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    [self.navigationItem setTitle:@"Chord Trainer"];
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Overide super

- (NSArray *)getAllSelections {
    return [Chord longNames];
}

- (NSArray *)getAllSelectionsAbbreviated {
    return [Chord shortNames];
}

- (void)setSelectionsAndChoices {
    switch ([[Defaults sharedInstance] getChordChallengeLevel]) {
        case 0:
            self.selections = [Chord shortNames];
            self.subtitles = [Chord longNames];
            self.choiceIndices = [NSArray arrayWithObjects:
                                  [NSNumber numberWithInteger:0],
                                  [NSNumber numberWithInteger:1],
                                  [NSNumber numberWithInteger:2],
                                  [NSNumber numberWithInteger:3], nil];
            break;
        case 1:
            break;
        case 2:
            break;
    }
}

- (PLAYMODE)getPlaymode {
    return [[Defaults sharedInstance] getChordPlaymode];
}

- (int)getTempo {
    return [[Defaults sharedInstance] getChordTempo];
}

- (void)savePlaymode:(PLAYMODE)playmode {
    [[Defaults sharedInstance] saveChordPlaymode:playmode];
}

- (id)getRandomSelection {
//    return [Chord getRandomChord];
    if (!self.choiceIndices) return [Chord getRandomChord];
    else return [Chord getRandomChordFromChoices:self.choiceIndices];
}

- (id)getSelectionWithIndex:(NSInteger)index {
    return [[Chord alloc] initChord:index];
}
@end