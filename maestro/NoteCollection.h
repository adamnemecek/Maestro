#import <Foundation/Foundation.h>

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