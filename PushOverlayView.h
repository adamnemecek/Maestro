#import <UIKit/UIKit.h>

@class PushOverlayView;

@protocol PushOverlayViewDelegate <NSObject>
-(void)tapEnded:(PushOverlayView *)view;
@end

@interface PushOverlayView : UIView

@property (nonatomic, weak) id <PushOverlayViewDelegate> delegate;

@end