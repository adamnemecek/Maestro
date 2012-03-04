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
@property (weak, nonatomic) IBOutlet UILabel *playmodeDetail;
@property (weak, nonatomic) IBOutlet UILabel *rootOctaveDetail;
@property (weak, nonatomic) IBOutlet UILabel *highOctaveDetail;
@property (weak, nonatomic) IBOutlet UILabel *tempoDetail;

-(void)done:(id)sender;
@end