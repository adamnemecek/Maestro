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
    
    [self saveChallengeLevel:0];
    [self savePlaymode:0];
    [self saveRootOctave:1];
    [self saveHighOctave:2];
    [self saveTempo:1];
    
    [self saveChallengeLevel:0];
    [self saveChordPlaymode:2];
    [self saveChordRootOctave:1];
    [self saveChordHighOctave:2];
    [self saveChordTempo:1];
}

#pragma mark - Saving defaults

- (void)saveHereBefore:(BOOL)hereBefore {
    [[NSUserDefaults standardUserDefaults] setBool:hereBefore forKey:@"keyHereBefore"];
}

- (void)saveShownOverlay:(BOOL)overlay {
    [[NSUserDefaults standardUserDefaults] setBool:overlay forKey:@"keyShownOverlay"];
}

#pragma mark Interval

- (void)saveChallengeLevel:(NSInteger)level {
    [[NSUserDefaults standardUserDefaults] setInteger:level forKey:@"keyIntervalChallengeLevel"];
}

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

- (void)saveChordChallengeLevel:(NSInteger)level {
    [[NSUserDefaults standardUserDefaults] setInteger:level forKey:@"keyChordChallengeLevel"];
}

- (void)saveChordPlaymode:(NSInteger)playmode {
    [[NSUserDefaults standardUserDefaults] setInteger:playmode forKey:@"keyChordPlaymode"];
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

- (BOOL)getShownOverlay {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"keyShownOverlay"];
}

#pragma mark Interval

- (NSInteger)getChallengeLevel {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"keyIntervalChallengeLevel"];
}

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

- (NSInteger)getChordChallengeLevel {
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"keyChordChallengeLevel"];
}

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