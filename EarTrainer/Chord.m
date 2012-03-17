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
    return self;
}

+ (Chord *)getRandomChord {
    return [[Chord alloc] initChord:(arc4random()%4)];
}

+ (Chord *)getRandomChordFromChoices:(NSArray *)choices {
    return [[Chord alloc] initChord:[[choices objectAtIndex:(arc4random()%[choices count])] integerValue]];
}

+ (NSArray *)longNames {
    return [NSArray arrayWithObjects:@"Minor", @"Major", @"Augmented", @"Diminished", nil];
}

+ (NSArray *)shortNames {
    return [NSArray arrayWithObjects:@"Min",@"Maj",@"Aug",@"Dim", nil];
}
@end