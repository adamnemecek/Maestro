#import "PushOverlayView.h"

@implementation PushOverlayView {
    BOOL isDragging;
}

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
//    [self setBackgroundColor:[UIColor blackColor]];
//    [self setAlpha:0.4];
    isDragging = NO;
    return self;
}

#pragma mark - Touch handling
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    isDragging = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!isDragging) [delegate tapEnded:self];
    isDragging = NO;
}
@end
