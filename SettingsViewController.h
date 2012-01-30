#import <UIKit/UIKit.h>

@class SettingsViewController;

@protocol SettingsViewControllerDelegate <NSObject>

-(void)SettingsViewControllerDidFinish:(SettingsViewController *)controller;

@end

@interface SettingsViewController : UITableViewController

@property (nonatomic, weak) id <SettingsViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;
@end
