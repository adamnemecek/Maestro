#import "Stats.h"

@implementation Stats

@synthesize right = _right;
@synthesize wrong = _wrong;
@synthesize total = _total;

- (void)addToStats:(BOOL)right {
    if (right) _right++;
    else _wrong++;
    _total++;
}

- (CGFloat)getPercentRight {
    return ((float)_right / (float)_total);
}

- (CGFloat)getPercentWrong {
    return ((float)_wrong / (float)_total);
}
@end