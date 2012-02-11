#import <Foundation/Foundation.h>

@class Defaults;

@interface Defaults : NSObject

+(Defaults *)sharedInstance;
+(void)destroySharedInstance;

-(void)savePlaymode:(NSInteger)playmode;
-(void)saveRootOctave:(NSInteger)octave;
-(void)saveHighOctave:(NSInteger)octave;

-(NSInteger)getPlaymode;
-(NSInteger)getRootOctave;
-(NSInteger)getHighOctave;

@end