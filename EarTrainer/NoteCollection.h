#import <Foundation/Foundation.h>

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

typedef enum {
    min,
    maj,
    aug,
    dim
}CHORDS;

@interface NoteCollection : NSObject

@property (nonatomic, strong) NSArray *notes;
@property (nonatomic, strong) NSString *shortName;
@property (nonatomic, strong) NSString *longName;
@property (nonatomic) NSInteger index; // General index, used with interval & chord

-(id)initWithIndex:(NSInteger)index;
-(NSString *)getNoteNames;
@end