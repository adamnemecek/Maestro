#import "Interval.h"
#import "Note.h"

@implementation Interval

@synthesize notes = _notes;
@synthesize shortName = _shortName;
@synthesize longName = _longName;
@synthesize interval = _interval;

- (id)initInterval:(INTERVALS)interval withRoot:(Note *)rootNote {
    self = [super init];
    
    NSArray *shorNames = [NSArray arrayWithObjects:@"U",@"m2",@"M2",@"m3",@"M3",@"P4",@"P5",@"m6",@"M6",@"m7",@"M7",@"P8", nil];
    NSArray *longNames = [NSArray arrayWithObjects:@"Unison",@"Minor 2",@"Major 2",@"Minor 3",@"Major 3",@"Perfect 4",@"Perfect 5",
                          @"Minor 6",@"Major 6",@"Minor 7",@"Major 7",@"Perfect 8", nil];
    
    _interval = interval;
    _shortName = [shorNames objectAtIndex:_interval];
    _longName = [longNames objectAtIndex:_interval];
    Note *nextNote = [[Note alloc] initNoteWithMidi:(rootNote.midiId + _interval)];
    _notes = [NSArray arrayWithObjects:rootNote, nextNote, nil];
    
    return self;
}

- (NSString *)getNoteNames {
    return [[((Note *)[_notes objectAtIndex:0]).name stringByAppendingString:@" - "] stringByAppendingString:((Note *)[_notes objectAtIndex:1]).name];
}

+ (Interval *)getRandomInterval {
    return [[Interval alloc] initInterval:(arc4random()%12) withRoot:[Note getRandomNote]];
}

@end