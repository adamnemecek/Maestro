#import "Chord.h"
#import "Note.h"

// TODO: Handle notes when augmented (i.e. G# not Ab) or diminished (i.e. Bbb not A)

@implementation Chord

@synthesize chord = _chord;

- (id)initChord:(CHORDS)chord {
    self = [self initChord:chord withRoot:[Note getRandomChordNote]];
    return self;
}

- (id)initChord:(CHORDS)chord withRoot:(Note *)root {
    self = [super initWithIndex:chord];
    
    INTERVALS spacing[12][3] = {
        {M3,m3,-1},                    // Major
        {m3,M3,-1},                    // Minor
        {M3,M3,-1},                    // Augmented
        {m3,m3,-1},                    // Diminished
        {M3,m3,M3},                    // Major 7th
        {m3,M3,m3},                    // Minor 7th
        {m3,M3,M3},                    // Minor-Major Seventh
        {M3,m3,m3},                    // Dominant 7th
        {M3,M3,m3},                    // Augmented-Major Seventh
        {M3,M3,M2},                    // Augmented Seventh    
        {m3,m3,M3},                    // Half-Diminished 7th
        {m3,m3,m3}                     // Diminished 7th
    };
    _chord = chord;
    self.shortName = [[Chord shortNames] objectAtIndex:_chord];
    self.longName = [[Chord longNames] objectAtIndex:_chord];
    
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
    return [NSArray arrayWithObjects:
            @"Major",
            @"Minor",
            @"Augmented",
            @"Diminished",
            @"Major Seventh",
            @"Minor Seventh",
            @"Minor-Major Seventh",
            @"Dominant Seventh",
            @"Augmented-Major Seventh",
            @"Augmented Seventh",
            @"Half-Diminished Seventh",
            @"Diminished Seventh",
            nil];
}

+ (NSArray *)shortNames {
    return [NSArray arrayWithObjects:
            @"Maj",
            @"Min",
            @"Aug",
            @"Dim",
            @"Maj7",
            @"Min7",
            @"MinMaj7",
            @"Dom7",
            @"AugMaj7",
            @"Aug7",
            @"1/2Dim7",
            @"Dim7",
            nil];
}
@end