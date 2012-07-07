#import "Tip.h"

@interface Tip (Private)
-(UIView *)viewToDisable;
-(UIImage *)tipImageForType:(TIP_TYPE)tipType;
@end

@implementation Tip {
    BOOL isDragging;
}

@synthesize tipView;
@synthesize infoView;
@synthesize type;

#pragma mark - Convienience constructors
+ (Tip *)randomTip {
    NSArray *tips = [Tip getAllTips];
    NSDictionary *info = [tips objectAtIndex:(arc4random()% tips.count)];
    return [[Tip alloc] initTip:info];
}

+(Tip *)tipAtIndex:(NSInteger)index {
    NSDictionary *info = [[Tip getAllTips] objectAtIndex:index];
    return [[Tip alloc] initTip:info];
}

+(Tip *)tipWithType:(TIP_TYPE)tipType atIndex:(NSInteger)index {
    NSString *tipText;
    switch (tipType) {
        case TIP_QUICK:
            tipText = [[self getGeneralTips] objectAtIndex:index];
            break;
        case TIP_INTERVAL:
            tipText = [[self getIntervalTips] objectAtIndex:index];
            break;
        case TIP_CHORD:
            tipText = [[self getChordTips] objectAtIndex:index];
            break;
    }
    return [[Tip alloc] initTip:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:tipType],kTipKeyType,tipText,kTipKeyText, nil]];
}

#pragma mark - Initialization
- (id)initTip:(NSDictionary *)tip {
    self = [super initWithFrame:CGRectMake(0, 0, 320, 640)];
    self.tag = kTipTag;
    
    type = (TIP_TYPE)[[tip objectForKey:kTipKeyType] intValue];
    
    tipView = [[UIImageView alloc] initWithImage:[self tipImageForType:type]];
    tipView.frame = CGRectMake(22, 76, tipView.frame.size.width, tipView.frame.size.height);
    tipView.alpha = 0.8;
    infoView = [[UITextView alloc] initWithFrame:CGRectMake(0, 33, tipView.frame.size.width, tipView.frame.size.height - 33)];
    infoView.backgroundColor = [UIColor clearColor];
    [infoView setUserInteractionEnabled:NO];
    infoView.text = [tip objectForKey:kTipKeyText];
    infoView.textColor = [UIColor whiteColor];
    infoView.textAlignment = UITextAlignmentCenter;
    infoView.font = [UIFont fontWithName:@"Helvetica" size:17.0];
    
    [self addSubview:tipView];
    [tipView addSubview:infoView];
    return self;
}

- (UIImage *)tipImageForType:(TIP_TYPE)tipType {
    NSString *image;
    switch (tipType) {
        case TIP_QUICK:
            image = @"tip.png";
            break;
        case TIP_INTERVAL:
            image = @"tip_interval.png";
            break;
        case TIP_CHORD:
            image = @"tip_chord.png";
            break;
        default:
            image = @"tip.png";
            break;
    }
    return [UIImage imageNamed:image];
}

#pragma mark - Get tips
+ (NSArray *)getGeneralTips {
    NSDictionary *tipDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Tips" ofType:@"plist"]];
    return [tipDict objectForKey:@"Quick Tips"];
}

+ (NSArray *)getIntervalTips {
    NSDictionary *tipDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Tips" ofType:@"plist"]];
    return [tipDict objectForKey:@"Interval Tips"];
}

+ (NSArray *)getChordTips {
    NSDictionary *tipDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Tips" ofType:@"plist"]];
    return [tipDict objectForKey:@"Chord Tips"];
}

+ (NSArray *)getAllTips {
    NSDictionary *tipDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Tips" ofType:@"plist"]];
    return [tipDict objectForKey:@"Tips"];
}

#pragma mark - Reset tip info
- (void)resetTipInfo {
    NSArray *tips = [Tip getAllTips];
    NSInteger randomTip = arc4random()% tips.count;
    NSString *info = [[tips objectAtIndex:randomTip] objectForKey:kTipKeyText];
    type = (TIP_TYPE)[[[tips objectAtIndex:randomTip] objectForKey:kTipKeyType] intValue];
    [tipView setImage:[self tipImageForType:type]];
    infoView.text = info;
}

#pragma mark - View to disable
- (UIView *)viewToDisable {
    return [UIApplication sharedApplication].keyWindow.rootViewController.view;
}

#pragma mark - Run & close
- (void)run {
    self.alpha = 0.0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [[self viewToDisable] setUserInteractionEnabled:NO];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1.0;
    } completion:nil];
}

- (void)close {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [[self viewToDisable] setUserInteractionEnabled:YES];
        [self removeFromSuperview];
    }];
}

#pragma mark - Touch events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    isDragging = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    isDragging = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!isDragging) [self close];
}
@end