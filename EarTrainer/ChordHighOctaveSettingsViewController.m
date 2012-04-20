#import "ChordHighOctaveSettingsViewController.h"

@implementation ChordHighOctaveSettingsViewController

#pragma mark - Overide methods

- (NSInteger)getOctave {
    return [[Defaults sharedInstance] getChordHighOctave];
}

- (NSInteger)getOtherOctave {
    return [[Defaults sharedInstance] getChordRootOctave];
}

- (void)saveOctave:(NSInteger)octave {
    [[Defaults sharedInstance] saveChordHighOctave:octave];
}

@end