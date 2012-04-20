#import <UIKit/UIKit.h>

@interface MainMenuCell : UITableViewCell

#define MENU_CELL_HEIGHT 50.0

@property (weak, nonatomic) IBOutlet UILabel *viewTitle;

+(NSString *)nibName;
+(NSString *)reuseIdentifier;
@end