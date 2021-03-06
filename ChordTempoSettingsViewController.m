#import "ChordTempoSettingsViewController.h"

@implementation ChordTempoSettingsViewController

- (NSInteger)getTempo {
    return [[Defaults sharedInstance] getChordTempo];
}

- (void)saveTempo:(NSInteger)tempo {
    [[Defaults sharedInstance] saveChordTempo:tempo];
}
@end