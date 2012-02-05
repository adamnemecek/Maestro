#import "Note.h"

@implementation Note

@synthesize name = _name;
@synthesize midiId = _midiId;

- (id)initNoteWithMidi:(NSInteger)midiId {
    self = [super init];
    
    NSArray *notes = [NSArray arrayWithObjects:@"C",@"D\u266D",@"D",@"E\u266D",@"E",@"F",@"G\u266D",@"G",@"A\u266D",@"A",@"B\u266D",@"B", nil];
    
    _midiId = midiId;
    _name = [notes objectAtIndex:(midiId % 12)];
    
//    NSLog(@"%i",_midiId);
//    NSLog(@"%@",_name);
    
    return self;
}

+ (Note *)getRandomNote {
    // Last octave in random note selection not included
    // That octave is reserved for follow up notes
    return [[Note alloc] initNoteWithMidi:(arc4random()%48 + 36)];
}

@end