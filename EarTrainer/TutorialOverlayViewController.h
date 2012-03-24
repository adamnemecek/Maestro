#import <UIKit/UIKit.h>

@class TutorialOverlayViewController;

@protocol TutorialViewControllerDelegate <NSObject>

- (void)tutorialViewControllerDidFinishFading:(TutorialOverlayViewController *)controller;
@end

@interface TutorialOverlayViewController : UIViewController

@property (nonatomic, weak) id <TutorialViewControllerDelegate> delegate;

@end