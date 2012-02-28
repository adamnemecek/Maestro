#import "Interval.h"

@interface Chord : Interval

@property (nonatomic, strong) NSArray *intervals;
@property (nonatomic) CHORDS chord;

-(id)initChord:(CHORDS)chord;
+(Chord *)getRandomChord;
@end