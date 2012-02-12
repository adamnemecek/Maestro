#import <Foundation/Foundation.h>

@class Defaults;

@interface Defaults : NSObject

+(Defaults *)sharedInstance;
+(void)destroySharedInstance;

-(void)initialDefaults;

-(void)saveHereBefore:(BOOL)hereBefore;
-(void)savePlaymode:(NSInteger)playmode;
-(void)saveRootOctave:(NSInteger)octave;
-(void)saveHighOctave:(NSInteger)octave;

-(BOOL)getHereBefore;
-(NSInteger)getPlaymode;
-(NSInteger)getRootOctave;
-(NSInteger)getHighOctave;

@end