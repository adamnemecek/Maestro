#import "Note.h"
#import "Defaults.h"

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

+ (NSInteger)midiFromOctave:(OCTAVE)octave {
    NSInteger midi;
    switch (octave) {
        case C2:
            midi = 36;
            break;
        case C3:
            midi = 48;
            break;
        case C4:
            midi = 60;
            break;
        case C5:
            midi = 72;
            break;
    }
    return midi;
}

+ (Note *)getRandomNote {
    NSInteger lowNote =  [Note midiFromOctave:[[Defaults sharedInstance] getRootOctave]];
    NSInteger highNote = [Note midiFromOctave:[[Defaults sharedInstance] getHighOctave]];
    return [[Note alloc] initNoteWithMidi:((arc4random()%((highNote - lowNote) + 1)) + lowNote)];}

@end