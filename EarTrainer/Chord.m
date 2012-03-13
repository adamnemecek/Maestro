#import "Chord.h"
#import "Note.h"

@implementation Chord

//@synthesize intervals = _intervals;
@synthesize chord = _chord;

- (id)initChord:(CHORDS)chord {
    self = [super initWithIndex:chord];
    
    INTERVALS spacing[4][2] = {{m3,M3},{M3,m3},{M3,M3},{m3,m3}};
    NSArray *shortNames = [NSArray arrayWithObjects:@"min",@"maj",@"aug",@"dim", nil];
    NSArray *longNames = [NSArray arrayWithObjects:@"minor",@"major",@"augmented",@"diminished", nil];
    _chord = chord;
    self.shortName = [shortNames objectAtIndex:_chord];
    self.longName = [longNames objectAtIndex:_chord];
    
    Note *rootNote   = [Note getRandomChordNote];
    Note *secondNote = [[Note alloc] initNoteWithMidi:(rootNote.midiId + spacing[chord][0])];
    Note *thirdNote  = [[Note alloc] initNoteWithMidi:(secondNote.midiId + spacing[chord][1])];
self.notes = [NSArray arrayWithObjects:rootNote, secondNote, thirdNote, nil];
    
//    Interval *rootInterval = [[Interval alloc] initInterval:spacing[_chord][0]];
//    Interval *nextInterval = [[Interval alloc] initInterval:spacing[_chord][1] withRoot:(Note *)[rootInterval.notes objectAtIndex:1]];
//    _intervals = [NSArray arrayWithObjects:rootInterval, nextInterval, nil];
//    self.notes = [NSArray arrayWithObjects:[[[_intervals objectAtIndex:0] notes] objectAtIndex:0],
//                                           [[[_intervals objectAtIndex:0] notes] objectAtIndex:1],
//                                           [[[_intervals objectAtIndex:1] notes] objectAtIndex:1], nil];
    return self;
}

+ (Chord *)getRandomChord {
    return [[Chord alloc] initChord:(arc4random()%4)];
}
@end