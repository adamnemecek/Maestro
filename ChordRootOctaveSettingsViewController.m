#import "ChordRootOctaveSettingsViewController.h"
#import "Defaults.h"

@implementation ChordRootOctaveSettingsViewController

#pragma mark - Overide methods

- (NSInteger)getOctaveSelection {
    return [[Defaults sharedInstance] getChordRootOctave];
}

- (NSInteger)getOtherOctave {
    return [[Defaults sharedInstance] getChordHighOctave];
}

- (void)saveOctaveSelection:(NSInteger)selection {
    [[Defaults sharedInstance] saveChordRootOctave:selection];
}

@end