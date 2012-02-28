#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@class SoundEngine;
@class Note;
@class NoteCollection;
//@class Interval;

@interface SoundEngine : NSObject

+(SoundEngine *)sharedInstance;
+(void)destroySharedInstance;

-(void)playCollection:(NoteCollection *)collection;

//-(void)playInterval:(Interval *)interval;

-(void)playNote:(Note *)note;
-(void)playSoundWithMidiId:(NSInteger)midiId;
-(void)playSoundWithName:(NSString *)name;
@end