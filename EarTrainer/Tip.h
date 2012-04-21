#import <UIKit/UIKit.h>

@class Tip;

@protocol TipDelegate <NSObject>
-(void)TipPresentationFinished:(Tip *)tip;
@end

@interface Tip : UIView

@property (nonatomic, weak) id <TipDelegate> delegate;

@property (nonatomic, strong, readonly) UIImageView *tipView;
@property (nonatomic, strong, readonly) UITextView *infoView;

+(Tip *)randomTip;
+(Tip *)tipAtIndex:(NSInteger)index;
-(id)initWithTipInfo:(NSString *)tipInfo;
+(NSArray *)getAllTips;
-(void)resetTipInfo;
@end