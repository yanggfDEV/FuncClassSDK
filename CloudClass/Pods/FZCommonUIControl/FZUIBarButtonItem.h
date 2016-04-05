

#import <UIKit/UIKit.h>

@interface FZUIBarButtonItem : UIBarButtonItem
-(id) initCustomViewWithTitle:(NSString *)title target:(id)target action:(SEL)action;
-(id) initBackButtonItemWithFrame:(CGRect)frame target:(id)target action:(SEL)action;
-(id) initImageWithName:(NSString *)title target:(id)target action:(SEL)action;
-(id) initImageWithImageUrl:(NSString *)urlString target:(id)target action:(SEL)action;
-(id) initCustomOrangeButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;
@end
