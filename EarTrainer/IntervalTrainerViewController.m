#import "IntervalTrainerViewController.h"
#import "Defaults.h"
#import "Interval.h"

@implementation IntervalTrainerViewController

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    [self.navigationItem setTitle:@"Interval Trainer"];
    return self;
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Overide super

- (NSArray *)getAllSelections {
    return [Interval allIntervals];
}

- (NSArray *)getAllSelectionsAbbreviated {
    return [Interval allIntervalsAbbreviated];
}

- (void)setSelectionsAndChoices {
    switch ([[Defaults sharedInstance] getChallengeLevel]) {
        case 0:
            self.selections = [NSArray arrayWithObjects:@"U",@"M3",@"P4",@"P5",@"P8", nil];
                        self.subtitles = [NSArray arrayWithObjects:@"Unison",@"Major Third",@"Perfect Fourth",@"Perfect Fifth",@"Perfect Eighth", nil];
            self.choiceIndices = [NSArray arrayWithObjects:
                                  [NSNumber numberWithInteger:0],
                                  [NSNumber numberWithInteger:4],
                                  [NSNumber numberWithInteger:5],
                                  [NSNumber numberWithInteger:6], 
                                  [NSNumber numberWithInteger:11], nil];
            break;
        case 1:
            self.selections = [NSArray arrayWithObjects:@"U",@"M2",@"M3",@"P4",@"P5",@"M6",@"M7",@"P8", nil];
            self.subtitles = [NSArray arrayWithObjects:@"Unison",@"Major Second",@"Major Third",@"Perfect Fourth",@"Perfect Fifth",@"Major Sixth",@"Major Seventh",@"Perfect Eighth", nil];
            self.choiceIndices = [NSArray arrayWithObjects:
                                  [NSNumber numberWithInteger:0],
                                  [NSNumber numberWithInteger:2],
                                  [NSNumber numberWithInteger:4],
                                  [NSNumber numberWithInteger:5],
                                  [NSNumber numberWithInteger:6],
                                  [NSNumber numberWithInteger:8],
                                  [NSNumber numberWithInteger:10],
                                  [NSNumber numberWithInteger:11], nil];
            break;
        case 2:
            self.selections = [Interval allIntervalsAbbreviated];
            self.subtitles = [Interval allIntervals];
            self.choiceIndices = nil;
            break;
    }
}

- (PLAYMODE)getPlaymode {
    return [[Defaults sharedInstance] getPlaymode];
}

- (int)getTempo {
    return [[Defaults sharedInstance] getTempo];
}

- (void)savePlaymode:(PLAYMODE)playmode {
    [[Defaults sharedInstance] savePlaymode:playmode];
}

- (id)getRandomSelection {
//    return [Interval getRandomInterval];
    if (!self.choiceIndices) return [Interval getRandomInterval];
    else return [Interval getRandomIntervalFromChoices:self.choiceIndices];
}

- (id)getSelectionWithIndex:(NSInteger)index {
    return [[Interval alloc] initInterval:index];
}
@end