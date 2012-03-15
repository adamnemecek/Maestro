#import <UIKit/UIKit.h>

@interface MainMenuCell : UITableViewCell

#define MENU_CELL_HEIGHT 55.0
#define MENU_CELL_MARGIN 20.0

@property (weak, nonatomic) IBOutlet UILabel *viewTitle;

+(NSString *)nibName;
+(NSString *)reuseIdentifier;
@end