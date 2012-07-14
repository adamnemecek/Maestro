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
    if (_total == 0)    // We can't divide by zero so return nothing
        return 0.0;
    else
    return ((float)_right / (float)_total);
}

- (CGFloat)getPercentWrong {
    if (_total == 0)
        return 0.0;
    else
        return ((float)_wrong / (float)_total);
}

- (void)resetStats {
    _right = 0;
    _wrong = 0;
    _total = 0;
}
@end