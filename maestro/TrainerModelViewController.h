#import <UIKit/UIKit.h>
#import "ContainerViewController.h"

@class SoundEngine;
@class NoteCollection;

typedef enum {
    PLAYTYPE_TRAIN,
    PLAYTYPE_PRACTICE,
}PLAYTYPE;

@interface TrainerModelViewController : ContainerViewController<UIAlertViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) UIBarButtonItem *playButton;
@property (strong, nonatomic) UIBarButtonItem *skipButton;
@property (strong, nonatomic) UIBarButtonItem *playmodeButton;
@property (strong, nonatomic) UIBarButtonItem *playTypeButton;
@property (strong, nonatomic) UIBarButtonItem *octaveSelection;
@property (strong, nonatomic) UIBarButtonItem *flexSpace;
@property (strong, nonatomic) UIBarButtonItem *fixedSpace;

@property (strong, nonatomic) NSArray *selections;
@property (strong, nonatomic) NSArray *subtitles;
@property (strong, nonatomic) NSArray *choiceIndices;

- (void)playCollection:(NoteCollection *)collection;

- (NSArray *)getAllSelections;
- (NSArray *)getAllSelectionsAbbreviated;
- (void)setSelectionsAndChoices;
- (NSInteger)getDifficulty;
- (PLAYMODE)getPlaymode;
- (int)getTempo;
- (void)savePlaymode:(PLAYMODE)playmode;
- (id)getRandomSelection;
- (id)getSelectionWithIndex:(NSInteger)index andOctave:(NSInteger)octave;

- (void)setupTrainingMode;
- (void)setupPracticeMode;

- (void)changePlaymode:(id)sender;
- (void)play:(id)sender;
- (void)skip:(id)sender;
- (void)changePlayType:(id)sender;
@end