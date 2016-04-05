//
//  UITableViewCell+horizontal.m
//
//  Created by DING FENG on 13-12-10.
//

#import "UITableViewCell+horizontal.h"
static void * MyObjectMyCustomPorpertyKey = (void *)@"MyObjectMyCustomPorpertyKey";
@implementation UITableViewCell (horizontal)
@dynamic haveRotated;



-(NSString *)haveRotated
{
    return objc_getAssociatedObject(self, MyObjectMyCustomPorpertyKey);
}
-(void)setHaveRotated:(NSString*)haveRotated
{
    objc_setAssociatedObject(self, MyObjectMyCustomPorpertyKey, haveRotated, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)rotateCoordinat
{
    if (![self.haveRotated isEqualToString:@"haveRotated"])
    {
        self.transform  =CGAffineTransformMakeRotation(M_PI/2);
        self.haveRotated = @"haveRotated";

    }
}

@end
