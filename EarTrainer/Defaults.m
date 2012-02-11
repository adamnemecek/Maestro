#import "Defaults.h"

static Defaults *inst = nil;

@implementation Defaults

#pragma mark - Shared instance

+ (Defaults *)sharedInstance {
    if (!inst)
        inst = [Defaults new];
    return inst;
}

+ (void)destroySharedInstance {
    inst = nil;
}

#pragma mark - Saving defaults

- (void)savePlaymode:(NSInteger)playmode {
    [[NSUserDefaults standardUserDefaults] setInteger:playmode forKey:@"keyPlaymode"];
}

- (void)saveRootOctave:(NSInteger)octave {
    [[NSUserDefaults standardUserDefaults] setInteger:octave forKey:@"keyRootOctave"];
}

- (void)saveHighOctave:(NSInteger)octave {
    [[NSUserDefaults standardUserDefaults] setInteger:octave forKey:@"keyHighOctave"];
}

#pragma mark - Retrieving defaults

- (NSInteger)getPlaymode {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"keyPlaymode"];
}

- (NSInteger)getRootOctave {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"keyRootOctave"];
}

- (NSInteger)getHighOctave {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"keyHighOctave"];    
}

@end