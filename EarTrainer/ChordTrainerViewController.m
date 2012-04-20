#import "ChordTrainerViewController.h"
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
            self.selections = [NSArray arrayWithObjects:@"Min",@"Maj",@"Aug",@"Dim", nil];
            self.subtitles  = [NSArray arrayWithObjects:@"Minor",@"Major",@"Augmented",@"Diminished", nil];
            self.choiceIndices = [NSArray arrayWithObjects:
                                  [NSNumber numberWithInteger:min],
                                  [NSNumber numberWithInteger:maj],
                                  [NSNumber numberWithInteger:aug],
                                  [NSNumber numberWithInteger:dim], nil];
            break;
        case 1:
            self.selections = [NSArray arrayWithObjects:@"Min",@"Maj",@"Aug",@"Dim",@"Min7",@"Maj7",@"MinMaj7",@"Dom7", nil];
            self.subtitles  = [NSArray arrayWithObjects:@"Minor",@"Major",@"Augmented",@"Diminished",
                                                        @"Minor Seventh",@"Major Seventh",@"Minor-Major Seventh",@"Dominant Seventh", nil];
            self.choiceIndices = [NSArray arrayWithObjects:
                                  [NSNumber numberWithInteger:min],
                                  [NSNumber numberWithInteger:maj],
                                  [NSNumber numberWithInteger:aug],
                                  [NSNumber numberWithInteger:dim],
                                  [NSNumber numberWithInteger:min7],
                                  [NSNumber numberWithInteger:maj7],
                                  [NSNumber numberWithInteger:mM7],
                                  [NSNumber numberWithInteger:dom7], nil];
            break;
        case 2:
            self.selections = [Chord shortNames];
            self.subtitles = [Chord longNames];
            self.choiceIndices = nil;
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
    if (!self.choiceIndices) return [Chord getRandomChord];
    else return [Chord getRandomChordFromChoices:self.choiceIndices];
}

- (id)getSelectionWithIndex:(NSInteger)index {
    return [[Chord alloc] initChord:index];
}
@end