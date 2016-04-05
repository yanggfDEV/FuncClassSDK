
#import <UIKit/UIKit.h>

@interface FLUITapGestureRecognizer : UITapGestureRecognizer
@property(nonatomic,strong)id tapParameter;
@property(nonatomic,assign)float rate;
@property(nonatomic,assign)NSInteger tag;


@end
