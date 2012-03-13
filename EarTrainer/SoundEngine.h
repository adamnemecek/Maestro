#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@class Note;
@class NoteCollection;

@interface SoundEngine : NSObject

+(SoundEngine *)sharedInstance;
+(void)destroySharedInstance;

- (void)setAlive:(BOOL)alive;

-(void)playCollection:(NoteCollection *)collection withProperties:(NSArray *)properties;

-(void)playNote:(Note *)note;
-(void)playSoundWithMidiId:(NSInteger)midiId;
-(void)playSoundWithName:(NSString *)name;
@end