//
//  UITableView+horizontal.m
//
//  Created by DING FENG on 13-12-10.
//

#import "UITableView+horizontal.h"
static void * MyObjectMyCustomPorpertyKey = (void *)@"MyObjectMyCustomPorpertyKey";

@implementation UITableView (horizontal)
@dynamic direction;
-(NSString *)direction
{
    return objc_getAssociatedObject(self, MyObjectMyCustomPorpertyKey);
}
-(void)setDirection:(NSString *)direction
{
    objc_setAssociatedObject(self, MyObjectMyCustomPorpertyKey, direction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}




- (id)initWithFrame:(CGRect)frame direction:(NSString *)direction;
{
    
    self.direction =direction;
    if ([self.direction  isEqualToString:@"horizontal"]) {
        CGRect  frameOriginal;
        frameOriginal.size.height=frame.size.width;
        frameOriginal.size.width=frame.size.height;
        frameOriginal.origin.x = frame.origin.x+(frame.size.width-frame.size.height)/2;
        frameOriginal.origin.y = frame.origin.y+frame.size.height-(frame.size.width+frame.size.height)/2;
        UITableView *tableViewOriginal = [self initWithFrame:frameOriginal];
        tableViewOriginal.transform  =CGAffineTransformMakeRotation(-M_PI/2);
        UITableView *tableViewRotated  =tableViewOriginal;
        return tableViewRotated;
    }
    else
    {
        UITableView *tableView = [self initWithFrame:frame];
        return tableView;
    }
}



@end
