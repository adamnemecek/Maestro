#import <Foundation/Foundation.h>

@interface Stats : NSObject

@property (nonatomic, readonly) NSInteger right;
@property (nonatomic, readonly) NSInteger wrong;
@property (nonatomic, readonly) NSInteger total;

-(void)addToStats:(BOOL)right;
-(CGFloat)getPercentRight;
-(CGFloat)getPercentWrong;
-(void)resetStats;
@end