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
-(id)initWithTipInfo:(NSString *)tipInfo;
-(void)resetTipInfo;
@end