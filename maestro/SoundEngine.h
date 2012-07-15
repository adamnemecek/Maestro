#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class NoteCollection;

@interface SoundEngine : NSObject <AVAudioPlayerDelegate>

+(SoundEngine *)sharedInstance;
+(void)destroySharedInstance;

-(void)startAudioSession;
-(void)endAudioSession;

-(void)playCollection:(NoteCollection *)collection
        withTempo:(float)tempo
        andPlayOrder:(PLAYMODE)playmode;

-(void)stop;

-(void)clearEngine;
@end