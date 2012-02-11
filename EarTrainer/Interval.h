#import <Foundation/Foundation.h>

@class Note;

typedef enum {
    U,
    m2,
    M2,
    m3,
    M3,
    P4,
    P5,
    m6,
    M6,
    m7,
    M7,
    P8
}INTERVALS;

@interface Interval : NSObject

@property (nonatomic, strong) NSArray *notes;
@property (nonatomic, strong) NSString *shortName;
@property (nonatomic, strong) NSString *longName;
@property (nonatomic) INTERVALS interval;       // index of interval, not spacing

-(id)initInterval:(INTERVALS)interval withRoot:(Note *)rootNote;
-(NSString *)getNoteNames;
+(Interval *)getRandomInterval;

@end