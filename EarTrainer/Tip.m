#import "Tip.h"

@interface Tip (Private)
- (void)animateOut;
@end

@implementation Tip {
    BOOL isDragging;
}

@synthesize delegate;

@synthesize tipView;
@synthesize infoView;

#pragma mark - Convienience constructors

+ (Tip *)randomTip {
    NSDictionary *tipDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Tips" ofType:@"plist"]];
    NSArray *tips = [tipDict objectForKey:@"Tips"];
    NSString *info = [tips objectAtIndex:(arc4random()% tips.count)];
    return [[Tip alloc] initWithTipInfo:info];
}

+(Tip *)tipAtIndex:(NSInteger)index {
    NSDictionary *tipDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Tips" ofType:@"plist"]];
    NSArray *tips = [tipDict objectForKey:@"Tips"];
    NSString *info = [tips objectAtIndex:index];
    return [[Tip alloc] initWithTipInfo:info];
}

#pragma mark - Initialization

- (id)init {
    self = [super initWithFrame:CGRectMake(0, 0, 320, 640)];
    tipView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tip.png"]];
    tipView.frame = CGRectMake(22, 76, tipView.frame.size.width, tipView.frame.size.height);
    tipView.alpha = 0.8;
    [self addSubview:tipView];
    return self;
}

- (id)initWithTipInfo:(NSString *)tipInfo {
    self = [self init];
    infoView = [[UITextView alloc] initWithFrame:CGRectMake(0, 33, tipView.frame.size.width, tipView.frame.size.height - 33)];
    infoView.backgroundColor = [UIColor clearColor];
    [infoView setUserInteractionEnabled:NO];
    infoView.text = tipInfo;
    infoView.textColor = [UIColor whiteColor];
    infoView.textAlignment = UITextAlignmentCenter;
    infoView.font = [UIFont fontWithName:@"Helvetica" size:17.0];
    [tipView addSubview:infoView];
    return self;
}

#pragma mark - Reset tip info

- (void)resetTipInfo {
    NSDictionary *tipDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Tips" ofType:@"plist"]];
    NSArray *tips = [tipDict objectForKey:@"Tips"];
    NSString *info = [tips objectAtIndex:(arc4random()% tips.count)];
    infoView.text = info;
}

#pragma mark - Touch events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    isDragging = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    isDragging = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!isDragging) [self animateOut];
}

#pragma mark - Animation

- (void) animateOut {
    [UIView animateWithDuration:0.5 animations:^(){
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [delegate TipPresentationFinished:self];
    }];
}
@end