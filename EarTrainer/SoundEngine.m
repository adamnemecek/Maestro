#import "SoundEngine.h"

#import "Note.h"
#import "Interval.h"

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

#pragma mark - Intervals

- (void)playInterval:(Interval *)interval {
    Note *rootNote = (Note *)[interval.notes objectAtIndex:0];
    Note *nextNote = (Note *)[interval.notes objectAtIndex:1];
    
    [self playNote:rootNote];
    [NSThread sleepForTimeInterval:0.5];
    [self playNote:nextNote];
}

#pragma mark - Load and play sound

- (void)playNote:(Note *)note {
    [self playSoundWithMidiId:note.midiId];
}

- (void)playSoundWithMidiId:(NSInteger)midiId {
    NSLog(@"playing with Id: %i",midiId);
    SystemSoundID note = [self loadSoundWithName:[NSString stringWithFormat:@"piano_%i",midiId]];
    AudioServicesPlaySystemSound(note);
}

- (void)playSoundWithName:(NSString *)name {
    SystemSoundID note = [self loadSoundWithName:name];
    AudioServicesPlaySystemSound(note);
}

- (SystemSoundID)loadSoundWithName:(NSString *)name {
    SystemSoundID note;
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"aiff"];
	CFURLRef url = (__bridge CFURLRef) [NSURL fileURLWithPath:path];
	AudioServicesCreateSystemSoundID(url, &note);
    return note;
}

@end