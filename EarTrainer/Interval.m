#import "Interval.h"
#import "Note.h"

@implementation Interval

@synthesize interval = _interval;

-(id)initInterval:(INTERVALS)interval {
    self = [self initInterval:interval withRoot:[Note getRandomNote]];
    return self;
}

- (id)initInterval:(INTERVALS)interval withRoot:(Note *)rootNote {
    self = [super initWithIndex:interval];
    
    _interval = interval;
    self.shortName = [[Interval shortNames] objectAtIndex:_interval];
    self.longName = [[Interval longNames] objectAtIndex:_interval];
    Note *nextNote = [[Note alloc] initNoteWithMidi:(rootNote.midiId + _interval)];
    self.notes = [NSArray arrayWithObjects:rootNote, nextNote, nil];
    
    return self;
}

+ (Interval *)getRandomInterval {
    return [[Interval alloc] initInterval:(arc4random()%[[Interval longNames] count]) withRoot:[Note getRandomNote]];
}

+ (Interval *)getRandomIntervalFromChoices:(NSArray *)choices {
    return [[Interval alloc] initInterval:[[choices objectAtIndex:(arc4random()%[choices count])] integerValue]
                                 withRoot:[Note getRandomNote]];
}

+ (NSArray *)longNames {
    return [NSArray arrayWithObjects:@"Unison",@"Minor Second",@"Major Second",@"Minor Third",@"Major Third",@"Perfect Fourth",@"Tri Tone",@"Perfect Fifth",
            @"Minor Sixth",@"Major Sixth",@"Minor Seventh",@"Major Seventh",@"Perfect Eighth", nil];
}

+ (NSArray *)shortNames {
    return [NSArray arrayWithObjects:@"U",@"m2",@"M2",@"m3",@"M3",@"P4",@"TT",@"P5",@"m6",@"M6",@"m7",@"M7",@"P8", nil];
}
@end