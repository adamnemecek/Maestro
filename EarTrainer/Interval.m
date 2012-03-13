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
    
    INTERVALS spacing[12] = {0,1,2,3,4,5,7,8,9,10,11,12};
    NSArray *shortNames = [NSArray arrayWithObjects:@"U",@"m2",@"M2",@"m3",@"M3",@"P4",@"P5",@"m6",@"M6",@"m7",@"M7",@"P8", nil];
    NSArray *longNames = [NSArray arrayWithObjects:@"Unison",@"Minor 2",@"Major 2",@"Minor 3",@"Major 3",@"Perfect 4",@"Perfect 5",
                          @"Minor 6",@"Major 6",@"Minor 7",@"Major 7",@"Perfect 8", nil];
    
    _interval = interval;
    self.shortName = [shortNames objectAtIndex:_interval];
    self.longName = [longNames objectAtIndex:_interval];
    Note *nextNote = [[Note alloc] initNoteWithMidi:(rootNote.midiId + spacing[_interval])];
    self.notes = [NSArray arrayWithObjects:rootNote, nextNote, nil];
    
    return self;
}

+ (Interval *)getRandomInterval {
    return [[Interval alloc] initInterval:(arc4random()%12) withRoot:[Note getRandomNote]];
}
@end