#import "SoundEngine.h"
#import "Note.h"
#import "NoteCollection.h"

static SoundEngine *inst = nil;

@implementation SoundEngine {
    BOOL _isAlive;
    BOOL _isPlaying;
    AVAudioPlayer *_note;
}

#pragma mark Init
- (id)init {
    self = [super init];
    [[AVAudioSession sharedInstance] setDelegate:self];
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

#pragma mark - Session
- (void)startAudioSession {
    dbgLog(@"Audio session start");
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    
    if (error)
        dbgLog(@"%@",error.description);
}

- (void)endAudioSession {
    dbgLog(@"Audio session end");
    NSError *error = nil;
    [[AVAudioSession sharedInstance] setActive:NO error:&error];
    
    if (error)
        dbgLog(@"%@",error.description);
}

#pragma mark - Play collection object
- (void)playCollection:(NoteCollection *)collection withTempo:(float)tempo andPlayOrder:(NSInteger)playOrder {    
    dbgLog(@"playing: %@",collection.shortName);
    dbgLog(@"%@",[collection getNoteNames]);
}

#pragma mark - Play audio
- (void)playNote:(Note *)note {
    _note = [self loadNoteWithMidiId:note.midiId];
    if (_note)
        [_note play];
}

#pragma mark - Load audio
- (AVAudioPlayer *)loadNoteWithMidiId:(NSInteger)midiId {
    NSError *error = nil;
    NSURL *url = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"piano_%i",midiId] withExtension:@"aiff"];
    AVAudioPlayer *note = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if (error)
        dbgLog(@"error loading sound: %@",error.description);
    
    [note prepareToPlay];
    
    note.volume = 0.3;
    
    return note;
}

#pragma mark - AVAudioPlayer delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    dbgLog(@"Sound finished");
}
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    dbgLog(@"Interruption began");
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player {
    dbgLog(@"Interruption ended");
}
@end