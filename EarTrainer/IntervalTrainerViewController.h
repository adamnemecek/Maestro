#import <UIKit/UIKit.h>

#import "SettingsViewController.h"

@class SoundEngine;

#define kSegue_Identifier_Open_Settings @"OpenSettings"

#define kImage_Playmode_Ascending   @"playmode_Ascending"
#define kImage_Playmode_Descending  @"playmode_Descending"
#define kImage_Playmode_Chord       @"playmode_Chord"

typedef enum {
    PLAYMODE_ASCENDING,
    PLAYMODE_DESCENDING,
    PLAYMODE_CHORD
}PLAYMODE;

@interface IntervalTrainerViewController : UITableViewController <SettingsViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *playmodeButton;

- (IBAction)changePlaymode:(id)sender;
- (IBAction)play:(id)sender;
- (IBAction)skip:(id)sender;
@end