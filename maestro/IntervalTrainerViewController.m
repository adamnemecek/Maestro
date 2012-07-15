#import "IntervalTrainerViewController.h"
#import "Interval.h"
#import "Note.h"

@implementation IntervalTrainerViewController {
    Interval *lastInterval;
}

#pragma mark - Initialization
- (id)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.navigationItem.title = @"Interval Trainer";
        [FlurryAnalytics logPageView];
    }
    return self;
}

#pragma mark - Overide super
- (NSArray *)getAllSelections {
    return [Interval longNames];
}

- (NSArray *)getAllSelectionsAbbreviated {
    return [Interval shortNames];
}

- (void)setSelectionsAndChoices {
    switch ([[Defaults sharedInstance] getChallengeLevel]) {
        case 0:
            self.selections = [NSArray arrayWithObjects:@"U",@"M3",@"P4",@"P5",@"P8", nil];
            self.subtitles = [NSArray arrayWithObjects:@"Unison",@"Major Third",@"Perfect Fourth",@"Perfect Fifth",@"Perfect Eighth", nil];
            self.choiceIndices = [NSArray arrayWithObjects:
                                  [NSNumber numberWithInteger:U],
                                  [NSNumber numberWithInteger:M3],
                                  [NSNumber numberWithInteger:P4],
                                  [NSNumber numberWithInteger:P5], 
                                  [NSNumber numberWithInteger:P8], nil];
            break;
        case 1:
            self.selections = [NSArray arrayWithObjects:@"U",@"M2",@"M3",@"P4",@"P5",@"M6",@"M7",@"P8", nil];
            self.subtitles = [NSArray arrayWithObjects:@"Unison",@"Major Second",@"Major Third",@"Perfect Fourth",@"Perfect Fifth",@"Major Sixth",
                                                       @"Major Seventh",@"Perfect Eighth", nil];
            self.choiceIndices = [NSArray arrayWithObjects:
                                  [NSNumber numberWithInteger:U],
                                  [NSNumber numberWithInteger:M2],
                                  [NSNumber numberWithInteger:M3],
                                  [NSNumber numberWithInteger:P4],
                                  [NSNumber numberWithInteger:P5],
                                  [NSNumber numberWithInteger:M6],
                                  [NSNumber numberWithInteger:M7],
                                  [NSNumber numberWithInteger:P8], nil];
            break;
        case 2:
            self.selections = [Interval shortNames];
            self.subtitles = [Interval longNames];
            self.choiceIndices = nil;
            break;
    }
}

- (NSInteger)getDifficulty {
    return [[Defaults sharedInstance] getChallengeLevel];
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
    Interval *interval;
    if (!self.choiceIndices) {
        if (!lastInterval) {
            interval = [Interval getRandomInterval];
            lastInterval = interval;
        } else {
            interval = [Interval getRandomInterval];
            while (interval.interval == lastInterval.interval) {
                interval = [Interval getRandomInterval];
            }
            lastInterval = interval;
        }
    } else {
        if (!lastInterval) {
            interval = [Interval getRandomIntervalFromChoices:self.choiceIndices];
            lastInterval = interval;
        } else {
            interval = [Interval getRandomIntervalFromChoices:self.choiceIndices];
            while (interval.interval == lastInterval.interval) {
                interval = [Interval getRandomIntervalFromChoices:self.choiceIndices];
            }
            lastInterval = interval;
        }
    }
    return interval;
}

- (id)getSelectionWithIndex:(NSInteger)index andOctave:(NSInteger)octave {
    return [[Interval alloc] initInterval:index withRoot:[Note getRandomNoteInOctave:octave]];
}
@end