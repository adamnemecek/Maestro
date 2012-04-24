#import <UIKit/UIKit.h>

#define kTipTag 99

typedef enum {
    TIP_QUICK,
    TIP_INTERVAL,
    TIP_CHORD
}TIP_TYPE;

#define kTipKeyText @"tip"
#define kTipKeyType @"type"

@interface Tip : UIView

@property (nonatomic, strong, readonly) UIImageView *tipView;
@property (nonatomic, strong, readonly) UITextView *infoView;
@property (nonatomic, readonly) TIP_TYPE type;

+(Tip *)randomTip;
+(Tip *)tipAtIndex:(NSInteger)index;
+(Tip *)tipWithType:(TIP_TYPE)tipType atIndex:(NSInteger)index;
-(id)initTip:(NSDictionary *)tip;
-(void)run;
-(void)close;
+(NSArray *)getGeneralTips;
+(NSArray *)getIntervalTips;
+(NSArray *)getChordTips;
+(NSArray *)getAllTips;
-(void)resetTipInfo;
@end