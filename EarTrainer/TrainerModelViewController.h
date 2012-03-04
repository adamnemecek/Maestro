#import <UIKit/UIKit.h>
#import "ContainerViewController.h"

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

typedef enum {
    PLAYTYPE_TRAIN,
    PLAYTYPE_PRACTICE,
}PLAYTYPE;

@interface TrainerModelViewController : ContainerViewController <UIAlertViewDelegate>

@property (strong, nonatomic) UIBarButtonItem *playButton;
@property (strong, nonatomic) UIBarButtonItem *skipButton;
@property (strong, nonatomic) UIBarButtonItem *playmodeButton;
@property (strong, nonatomic) UIBarButtonItem *playTypeButton;

@property (strong, nonatomic) NSArray *selections;

- (PLAYMODE)getPlaymode;
- (void)savePlaymode:(PLAYMODE)playmode;
- (id)getRandomSelection;
- (id)getSelectionWithIndex:(NSInteger)index;

- (void)setupTrainingMode;
- (void)setupPracticeMode;

- (void)changePlaymode:(id)sender;
- (void)play:(id)sender;
- (void)skip:(id)sender;
- (void)changePlayType:(id)sender;
@end