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
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@".caf"];
    NSURL *fileUrl = [NSURL fileURLWithPath:path];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileUrl,&soundID);
}

@end
