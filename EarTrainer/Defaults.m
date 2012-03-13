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

#pragma mark - Initial defaults

- (void)initialDefaults {
    [self saveHereBefore:YES];
    
    [self savePlaymode:0];
    [self saveRootOctave:1];
    [self saveHighOctave:2];
    [self saveTempo:1];
    
    [self saveChordPlaymode:2];
    [self saveChordRootOctave:1];
    [self saveChordHighOctave:2];
    [self saveChordTempo:1];
}

#pragma mark - Saving defaults

- (void)saveHereBefore:(BOOL)hereBefore {
    [[NSUserDefaults standardUserDefaults] setBool:hereBefore forKey:@"keyHereBefore"];
}

#pragma mark Interval

- (void)savePlaymode:(NSInteger)playmode {
    [[NSUserDefaults standardUserDefaults] setInteger:playmode forKey:@"keyIntervalPlaymode"];
}

- (void)saveRootOctave:(NSInteger)octave {
    [[NSUserDefaults standardUserDefaults] setInteger:octave forKey:@"keyIntervalRootOctave"];
}

- (void)saveHighOctave:(NSInteger)octave {
    [[NSUserDefaults standardUserDefaults] setInteger:octave forKey:@"keyIntervalHighOctave"];
}

- (void)saveTempo:(NSInteger)tempo {
    [[NSUserDefaults standardUserDefaults] setInteger:tempo forKey:@"keyIntervalTempo"];
}

#pragma mark Chord

- (void)saveChordPlaymode:(NSInteger)tempo {
    [[NSUserDefaults standardUserDefaults] setInteger:tempo forKey:@"keyChordPlaymode"];
}

- (void)saveChordRootOctave:(NSInteger)octave {
    [[NSUserDefaults standardUserDefaults] setInteger:octave forKey:@"keyChordRootOctave"];
}

- (void)saveChordHighOctave:(NSInteger)octave {
    [[NSUserDefaults standardUserDefaults] setInteger:octave forKey:@"keyChordHighOctave"];
}

- (void)saveChordTempo:(NSInteger)tempo {
    [[NSUserDefaults standardUserDefaults] setInteger:tempo forKey:@"keyChordTempo"];
}

#pragma mark - Retrieving defaults

- (BOOL)getHereBefore {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"keyHereBefore"];
}

#pragma mark Interval

- (NSInteger)getPlaymode {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"keyIntervalPlaymode"];
}

- (NSInteger)getRootOctave {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"keyIntervalRootOctave"];
}

- (NSInteger)getHighOctave {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"keyIntervalHighOctave"];    
}

- (NSInteger)getTempo {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"keyIntervalTempo"];
}

#pragma mark Chord

- (NSInteger)getChordPlaymode {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"keyChordPlaymode"];
}

- (NSInteger)getChordRootOctave {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"keyChordRootOctave"];
}

- (NSInteger)getChordHighOctave {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"keyChordHighOctave"];
}

- (NSInteger)getChordTempo {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"keyChordTempo"];
}
@end