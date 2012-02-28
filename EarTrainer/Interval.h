#import "NoteCollection.h"

@class Note;

@interface Interval : NoteCollection

@property (nonatomic) INTERVALS interval;       // Index of interval, not spacing

-(id)initInterval:(INTERVALS)interval;
-(id)initInterval:(INTERVALS)interval withRoot:(Note *)rootNote;
+(Interval *)getRandomInterval;
@end