//
//  NSObject+Blocks.m
//
//  Created by Brian Stewart on 7/13/12.
//  Copyright (c) 2012 PenguinSoft. All rights reserved.
//

#import "NSObject+Blocks.h"

@implementation NSObject (Blocks)

- (void)performBlock:(void (^)(void))block afterTimeInterval:(NSTimeInterval)time {
    double delayInSeconds = (double)time;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        block();
    });
}

- (void)performBlockInBackground:(void (^)(void))block afterTimeInterval:(NSTimeInterval)time {
    int64_t delta = (int64_t)(1.0e9 * time);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
}
@end