#import <Foundation/Foundation.h>

typedef enum {
    U,
    m2,
    M2,
    m3,
    M3,
    P4,
    TT,
    P5,
    m6,
    M6,
    m7,
    M7,
    P8
}INTERVALS;

typedef enum {
    min,
    maj,
    aug,
    dim,
    min7,
    maj7,
    mM7,
    dom7,
    hDim7,
    dim7,
    augM7,
    aug7
}CHORDS;

@interface NoteCollection : NSObject

@property (nonatomic, strong) NSArray *notes;
@property (nonatomic, strong) NSString *shortName;
@property (nonatomic, strong) NSString *longName;
@property (nonatomic) NSInteger index; // General index, used with interval & chord

-(id)initWithIndex:(NSInteger)index;
-(NSString *)getNoteNames;
+(NSArray *)longNames;
+(NSArray *)shortNames;
@end