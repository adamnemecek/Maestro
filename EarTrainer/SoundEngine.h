#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@class SoundEngine;

@interface SoundEngine : NSObject

// Shared Instance
+(SoundEngine *)sharedInstance;
+(void)destroySharedInstance;

// Load and play sound
- (void)playSoundWithName:(NSString *)name;

@end
