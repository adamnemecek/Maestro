#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@class Note;
@class NoteCollection;

@interface SoundEngine : NSObject

+(SoundEngine *)sharedInstance;
+(void)destroySharedInstance;

- (void)startAudioSession;
- (void)endAudioSession;

- (void)setAlive:(BOOL)alive;

-(void)playCollection:(NoteCollection *)collection withProperties:(NSArray *)properties;

-(void)playNote:(Note *)note;
-(void)playSoundWithMidiId:(NSInteger)midiId;
@end