#import "NoteCollection.h"

@class Note;

@interface Chord : NoteCollection

@property (nonatomic) CHORDS chord;

-(id)initChord:(CHORDS)chord;
-(id)initChord:(CHORDS)chord withRoot:(Note *)root;
+(Chord *)getRandomChord;
+(Chord *)getRandomChordFromChoices:(NSArray *)choices;
@end