#import "Defaults.h"

static Defaults *inst = nil;

@implementation Defaults

#pragma mark - Shared instance

+ (Defaults *)sharedInstance {
    if (!inst)
        inst = [Defaults new];
    return inst;
}

+ (void)destroySharedInstance {
    inst = nil;
}

#pragma mark Saving defaults

@end
