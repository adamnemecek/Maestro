#import "ChordDifficultySettingsViewController.h"
#import "Defaults.h"

@implementation ChordDifficultySettingsViewController

- (NSInteger)getDifficulty {
    return [[Defaults sharedInstance] getChordChallengeLevel];
}

- (void)saveDifficulty:(NSInteger)difficulty {
    if (difficulty == 1) return;
    [[Defaults sharedInstance] saveChordChallengeLevel:difficulty];
}
@end