
#import "FLUITapGestureRecognizer.h"

@implementation FLUITapGestureRecognizer
-(void)dealloc
{
    self.tapParameter=nil;
    self.rate = -1.0;
    self.tag  = 0;
}
@end
