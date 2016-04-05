//
//  UITableView+horizontal.h
//
//  Created by DING FENG on 13-12-10.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "UITableViewCell+horizontal.h"


@interface UITableView (horizontal)
@property (nonatomic, strong) NSString *direction;

- (id)initWithFrame:(CGRect)frame direction:(NSString *)direction;
@end
