#import <Foundation/Foundation.h>

@class Defaults;

@interface Defaults : NSObject

+(Defaults *)sharedInstance;
+(void)destroySharedInstance;

@end
