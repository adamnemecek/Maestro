#import "ChordTrainerViewController.h"
#import "Chord.h"
#import "Note.h"

@implementation ChordTrainerViewController {
    Chord *lastChord;
}

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    [self.navigationItem setTitle:@"Chord Trainer"];
    [FlurryAnalytics logAllPageViews:self];
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
            self.selections = [NSArray arrayWithObjects:@"Maj",@"Min",@"Aug",@"Dim", nil];
            self.subtitles  = [NSArray arrayWithObjects:@"Major",@"Minor",@"Augmented",@"Diminished", nil];
            self.choiceIndices = [NSArray arrayWithObjects:
                                  [NSNumber numberWithInteger:maj],
                                  [NSNumber numberWithInteger:min],
                                  [NSNumber numberWithInteger:aug],
                                  [NSNumber numberWithInteger:dim], nil];
            break;
        case 1:
            self.selections = [NSArray arrayWithObjects:@"Maj",@"Min",@"Aug",@"Dim",@"Maj7",@"Min7",@"MinMaj7",@"Dom7", nil];
            self.subtitles  = [NSArray arrayWithObjects:@"Major",@"Minor",@"Augmented",@"Diminished",
                                                        @"Major Seventh",@"Minor Seventh",@"Minor-Major Seventh",@"Dominant Seventh", nil];
            self.choiceIndices = [NSArray arrayWithObjects:
                                  [NSNumber numberWithInteger:maj],
                                  [NSNumber numberWithInteger:min],
                                  [NSNumber numberWithInteger:aug],
                                  [NSNumber numberWithInteger:dim],
                                  [NSNumber numberWithInteger:maj7],
                                  [NSNumber numberWithInteger:min7],
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

- (NSInteger)getDifficulty {
    return [[Defaults sharedInstance] getChordChallengeLevel];
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
    Chord *chord;
    if (!self.choiceIndices) {
        if (!lastChord) {
            chord = [Chord getRandomChord];
            lastChord = chord;
        } else {
            chord = [Chord getRandomChord];
            while (chord.chord == lastChord.chord) {
                chord = [Chord getRandomChord];
            }
            lastChord = chord;
        }
    } else {
        if (!lastChord) {
            chord = [Chord getRandomChordFromChoices:self.choiceIndices];
            lastChord = chord;
        } else {
            chord = [Chord getRandomChordFromChoices:self.choiceIndices];
            while (chord.chord == lastChord.chord) {
                chord = [Chord getRandomChordFromChoices:self.choiceIndices];
            }
            lastChord = chord;
        }
    }
    return chord;
}

- (id)getSelectionWithIndex:(NSInteger)index andOctave:(NSInteger)octave {
    return [[Chord alloc] initChord:index withRoot:[Note getRandomNoteInOctave:octave]];
}
@end