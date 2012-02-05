#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@class SoundEngine;
@class Note;
@class Interval;

@interface SoundEngine : NSObject

// Shared Instance
+(SoundEngine *)sharedInstance;
+(void)destroySharedInstance;

// Intervals
-(void)playInterval:(Interval *)interval;

// Load and play sound
-(void)playNote:(Note *)note;
-(void)playSoundWithMidiId:(NSInteger)midiId;
-(void)playSoundWithName:(NSString *)name;
-(SystemSoundID)loadSoundWithName:(NSString *)name;

@end