#import "NoteCollection.h"

@interface Chord : NoteCollection

//@property (nonatomic, strong) NSArray *intervals;
@property (nonatomic) CHORDS chord;

-(id)initChord:(CHORDS)chord;
+(Chord *)getRandomChord;
+(Chord *)getRandomChordFromChoices:(NSArray *)choices;
+(NSArray *)allChords;
+(NSArray *)allChordsAbbreviated;
@end