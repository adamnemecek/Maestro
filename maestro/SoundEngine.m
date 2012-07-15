#import "SoundEngine.h"
#import "Note.h"
#import "NoteCollection.h"

static SoundEngine *inst = nil;

@implementation SoundEngine {
    NSMutableArray *_notes;
    BOOL _playing;
    BOOL _stop;
}

#pragma mark Init
- (id)init {
    self = [super init];
    _notes = [NSMutableArray array];
    _playing = NO;
    _stop = NO;
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
- (void)playCollection:(NoteCollection *)collection withTempo:(float)tempo andPlayOrder:(NSInteger)playmode {    
    if (_playing) return;
    
    dbgLog(@"playing: %@",collection.shortName);
    dbgLog(@"%@",[collection getNoteNames]);
    dbgLog(@"tempo: %f",tempo);
    dbgLog(@"playmode: %i",playmode);
    
    _playing = YES;
    _stop = NO;
    
    if (_notes.count <= 0)
        _notes = [self loadNotes:collection.notes];
    
    NSArray *notes = [NSArray arrayWithArray:_notes];
    
    
    if (playmode == PLAYMODE_DESCENDING) { // Reverse the array for descending order
        notes = (NSMutableArray *)[[_notes reverseObjectEnumerator] allObjects];
    } else if (playmode == PLAYMODE_CHORD) {
        tempo = 0.0;
    }
    
    // Play notes on separate thread
    [self performBlockInBackground:^{
        for (AVAudioPlayer *note in notes) {
            if (_stop) break;
            [note play];
            [NSThread sleepForTimeInterval:tempo];
        }
        
        // Give the last note time to finish playing before we end
        [self performBlock:^{
            _playing = NO;
        } afterTimeInterval:0.17];
        
    } afterTimeInterval:0.11];
}

#pragma mark - Clear notes
- (void)clearEngine {
    if (_playing) return; // Engine CANNOT be cleared while we are playing
    [_notes removeAllObjects];
}

#pragma mark - Load audio
- (NSMutableArray *)loadNotes:(NSArray *)notes {
    NSMutableArray *array = [NSMutableArray array];
    for (Note *note in notes) {
        AVAudioPlayer *player = [self loadNoteWithMidiId:note.midiId];
        [array addObject:player];
    }
    return array;
}

- (AVAudioPlayer *)loadNoteWithMidiId:(NSInteger)midiId {
    NSError *error = nil;
    NSURL *url = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"piano_%i",midiId] withExtension:@"aiff"];
    AVAudioPlayer *note = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    
    if (error)
        dbgLog(@"error loading sound: %@",error.description);
    
//    [note prepareToPlay];
//    note.volume = 0.3;
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