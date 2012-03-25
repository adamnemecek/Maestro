#import "Chord.h"
#import "Note.h"

// TODO: Handle augmented with chords (i.e. G# not Ab) or diminished (i.e. Bbb not A)

@implementation Chord

@synthesize chord = _chord;

- (id)initChord:(CHORDS)chord {
    self = [super initWithIndex:chord];
    
    INTERVALS spacing[12][3] = {
        {m3,M3,-1},                    // Minor
        {M3,m3,-1},                    // Major
        {M3,M3,-1},                    // Augmented
        {m3,m3,-1},                    // Diminished
        {m3,M3,m3},                    // Minor 7th
        {M3,m3,M3},                    // Major 7th
        {m3,M3,M3},                    // Minor-Major Seventh
        {M3,m3,m3},                    // Dominant 7th
        {m3,m3,M3},                    // Half-Diminished 7th
        {m3,m3,m3},                    // Diminished 7th
        {M3,M3,m3},                    // Augmented-Major Seventh
        {M3,M3,M2}                     // Augmented Seventh    
    };
    _chord = chord;
    self.shortName = [[Chord shortNames] objectAtIndex:_chord];
    self.longName = [[Chord longNames] objectAtIndex:_chord];
    
    Note *root   = [Note getRandomChordNote];
    Note *third = [[Note alloc] initNoteWithMidi:(root.midiId + spacing[chord][0])];
    Note *fifth  = [[Note alloc] initNoteWithMidi:(third.midiId + spacing[chord][1])];
    Note *seventh = (spacing[chord][2] == -1) ? nil : [[Note alloc] initNoteWithMidi:(fifth.midiId + spacing[chord][2])];
    if (!seventh) self.notes = [NSArray arrayWithObjects:root, third, fifth, nil];
    else self.notes = [NSArray arrayWithObjects:root, third, fifth, seventh, nil];
    
    return self;
}

+ (Chord *)getRandomChord {
    return [[Chord alloc] initChord:(arc4random()%[[Chord shortNames] count])];
}

+ (Chord *)getRandomChordFromChoices:(NSArray *)choices {
    return [[Chord alloc] initChord:[[choices objectAtIndex:(arc4random()%[choices count])] integerValue]];
}

+ (NSArray *)longNames {
    return [NSArray arrayWithObjects:@"Minor",@"Major",@"Augmented",@"Diminished",
            @"Minor Seventh",@"Major Seventh",@"Minor-Major Seventh",@"Dominant Seventh",
            @"Half-Diminished Seventh",@"Diminished Seventh",@"Augmented-Major Seventh",@"Augmented Seventh", nil];
}

+ (NSArray *)shortNames {
    return [NSArray arrayWithObjects:@"Min",@"Maj",@"Aug",@"Dim",@"Min7",@"Maj7",@"MinMaj7",@"Dom7",@"1/2Dim7",@"Dim7",@"AugMaj7",@"Aug7", nil];
}
@end