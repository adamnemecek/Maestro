#import <UIKit/UIKit.h>

@class SettingsViewController;

typedef enum {
    SECTION_INTERVAL,
    SECTION_CHORD
}SECTIONS;

@protocol SettingsViewControllerDelegate <NSObject>
-(void)SettingsViewControllerDidFinish:(SettingsViewController *)controller;
@end

@interface SettingsViewController : UITableViewController

@property (nonatomic, weak) id <SettingsViewControllerDelegate> delegate;

-(void)done:(id)sender;
@end