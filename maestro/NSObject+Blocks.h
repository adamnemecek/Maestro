//
//  NSObject+Blocks.h
//
//  Created by Brian Stewart on 7/13/12.
//  Copyright (c) 2012 PenguinSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Blocks)

-(void)performBlock:(void (^)(void))block afterTimeInterval:(NSTimeInterval)time;
-(void)performBlockInBackground:(void (^)(void))block afterTimeInterval:(NSTimeInterval)time;
@end