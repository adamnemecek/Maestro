#import <UIKit/UIKit.h>
#import "RootOctaveSettingsViewController.h"

@interface HighOctaveSettingsViewController : RootOctaveSettingsViewController

-(NSInteger)getOctave;
-(void)saveOctave:(NSInteger)octave;

@end
