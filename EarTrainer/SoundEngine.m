#import "SoundEngine.h"

static SoundEngine *inst = nil;

@implementation SoundEngine

#pragma mark - Shared instance

+ (SoundEngine *)sharedInstance {
    if (!inst)
        inst = [SoundEngine new];
    return inst;
}

+ (void)destroySharedInstance {
    inst = nil;
}

#pragma mark - Load and play sound

- (void)playSoundWithName:(NSString *)name {
    
    SystemSoundID note;
	
	NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"aiff"];
	CFURLRef url = (__bridge CFURLRef) [NSURL fileURLWithPath:path];
	AudioServicesCreateSystemSoundID(url, &note);
    AudioServicesPlaySystemSound(note);
}

@end
