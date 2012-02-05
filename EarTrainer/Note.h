#import <Foundation/Foundation.h>

@interface Note : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic) NSInteger midiId;

-(id)initNoteWithMidi:(NSInteger)midiId;
+(Note *)getRandomNote;

@end