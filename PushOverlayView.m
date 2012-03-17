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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark Touch handling

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
