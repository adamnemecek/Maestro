#import <Foundation/Foundation.h>

typedef enum {
    C2,
    C3,
    C4,
    C5
}OCTAVE;

@interface Note : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSInteger midiId;

-(id)initNoteWithMidi:(NSInteger)midiId;
+(NSInteger)midiFromOctave:(OCTAVE)octave;
+(Note *)getRandomNote;

@end