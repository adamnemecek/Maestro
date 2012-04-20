#import "UIViewController+RoundedCorners.h"

@implementation UIViewController (RoundedCorners)

- (void)roundNavCorners {
    // Round the top left and right corners of navigation bar
    CALayer *capa = [self.navigationController navigationBar].layer;
    CGRect bounds = capa.bounds;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(5.0, 5.0)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    
    [capa addSublayer:maskLayer];
    capa.mask = maskLayer;
}

@end