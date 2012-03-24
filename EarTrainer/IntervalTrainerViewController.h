#import <UIKit/UIKit.h>
#import "TrainerModelViewController.h"
#import "TutorialOverlayViewController.h"

@interface IntervalTrainerViewController : TrainerModelViewController <TutorialViewControllerDelegate>

@property (nonatomic, strong) TutorialOverlayViewController *tutorialOverlayViewController;

@end