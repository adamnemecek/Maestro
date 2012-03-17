#import "NoteCollection.h"

@interface Chord : NoteCollection

@property (nonatomic) CHORDS chord;

-(id)initChord:(CHORDS)chord;
+(Chord *)getRandomChord;
+(Chord *)getRandomChordFromChoices:(NSArray *)choices;
@end