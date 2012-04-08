#import <Foundation/Foundation.h>

@class Defaults;

@interface Defaults : NSObject

+(Defaults *)sharedInstance;
+(void)destroySharedInstance;

-(void)initialDefaults;

-(void)saveHereBefore:(BOOL)hereBefore;
-(void)saveShownOverlay:(BOOL)overlay;
-(void)saveShowTips:(BOOL)show;

-(void)saveChallengeLevel:(NSInteger)level;
-(void)savePlaymode:(NSInteger)playmode;
-(void)saveRootOctave:(NSInteger)octave;
-(void)saveHighOctave:(NSInteger)octave;
-(void)saveTempo:(NSInteger)tempo;

-(void)saveChordChallengeLevel:(NSInteger)level;
-(void)saveChordPlaymode:(NSInteger)playmode;
-(void)saveChordRootOctave:(NSInteger)octave;
-(void)saveChordHighOctave:(NSInteger)octave;
-(void)saveChordTempo:(NSInteger)tempo;

-(BOOL)getHereBefore;
-(BOOL)getShownOverlay;
-(BOOL)getShowTips;

-(NSInteger)getChallengeLevel;
-(NSInteger)getPlaymode;
-(NSInteger)getRootOctave;
-(NSInteger)getHighOctave;
-(NSInteger)getTempo;

-(NSInteger)getChordChallengeLevel;
-(NSInteger)getChordPlaymode;
-(NSInteger)getChordRootOctave;
-(NSInteger)getChordHighOctave;
-(NSInteger)getChordTempo;
@end