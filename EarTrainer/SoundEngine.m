#import "SoundEngine.h"
#import "Note.h"
#import "NoteCollection.h"

// TODO: Generate own sounds probably with audio queue services

@interface SoundEngine (Private)
-(SystemSoundID)loadSoundWithName:(NSString *)name;
-(void)playOnNewThread:(NSDictionary *)properties;
@end

static SoundEngine *inst = nil;

@implementation SoundEngine {
    BOOL _isAlive;
    BOOL _isPlaying;
}

#pragma mark Init

- (id)init {
    self = [super init];
    _isAlive = YES;
    _isPlaying = NO;
    return self;
}

#pragma mark - Shared instance

+ (SoundEngine *)sharedInstance {
    if (!inst)
        inst = [SoundEngine new];
    return inst;
}

+ (void)destroySharedInstance {
    inst = nil;
}

#pragma mark Engine status

- (void)setAlive:(BOOL)alive {
    _isAlive = alive;
}

#pragma mark - Threading

- (void)playOnNewThread:(NSDictionary *)properties {
    
    float tempo;
    switch ([[[properties objectForKey:@"keyProps"] objectAtIndex:1] intValue]) {
        case 0:
            tempo = 1.0;
            break;
        case 1:
            tempo = 0.6;
            break;
        case 2:
            tempo = 0.30;
            break;
    }
    
    if ([[[properties objectForKey:@"keyProps"] objectAtIndex:0] intValue] == 0) {          // Ascending
        for (Note *note in [properties objectForKey:@"keyNotes"]) {
            if (!_isAlive) break;
            [self playNote:note];
            [NSThread sleepForTimeInterval:tempo];
        }
    } else if ([[[properties objectForKey:@"keyProps"] objectAtIndex:0] intValue] == 1) {   // Descending
        for (int i = (((NSArray *)[properties objectForKey:@"keyNotes"]).count - 1); i >= 0; i--) {
            if (!_isAlive) break;
            Note *note = [[properties objectForKey:@"keyNotes"] objectAtIndex:i];
            [self playNote:note];
            [NSThread sleepForTimeInterval:tempo];
        }
    } else {                                                                                // Chord
        for (Note *note in [properties objectForKey:@"keyNotes"]) {
            if (!_isAlive) break;
            [self playNote:note];
        }
    }
    _isPlaying = NO;
}

#pragma mark - Play collection object

/* properties order:
 * playmode
 * tempo
*/
- (void)playCollection:(NoteCollection *)collection withProperties:(NSArray *)properties {
    if (!_isAlive || _isPlaying) return;
    _isPlaying = YES;
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:collection.notes, properties, nil]
                                                           forKeys:[NSArray arrayWithObjects:@"keyNotes",@"keyProps", nil]];
    [NSThread detachNewThreadSelector:@selector(playOnNewThread:) toTarget:self withObject:dictionary];
}

#pragma mark - Load and play sound

- (void)playNote:(Note *)note {
    [self playSoundWithMidiId:note.midiId];
}

- (void)playSoundWithMidiId:(NSInteger)midiId {
//    NSLog(@"playing with Id: %i",midiId);
    SystemSoundID note = [self loadSoundWithName:[NSString stringWithFormat:@"piano_%i",midiId]];
    AudioServicesPlaySystemSound(note);
}

/* Deprecated */
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