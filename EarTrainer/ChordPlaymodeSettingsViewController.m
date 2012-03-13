#import "ChordPlaymodeSettingsViewController.h"
#import "Defaults.h"

@implementation ChordPlaymodeSettingsViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark - Overide

- (NSInteger)getPlaymode {
    return [[Defaults sharedInstance] getChordPlaymode];
}

- (void)savePlaymode:(NSInteger)playmode {
    [[Defaults sharedInstance] saveChordPlaymode:playmode];
}

@end