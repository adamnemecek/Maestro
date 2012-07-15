#import <Foundation/Foundation.h>

@interface Note : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSInteger midiId;

-(id)initNoteWithMidi:(NSInteger)midiId;
+(NSInteger)midiFromOctave:(OCTAVE)octave;
+(Note *)getRandomNoteInOctave:(NSInteger)octave;
+(Note *)getRandomNote;
+(Note *)getRandomChordNote;

@end