//
//  UITableViewCell+horizontal.h
//
//  Created by DING FENG on 13-12-10.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>


@interface UITableViewCell (horizontal)
@property (nonatomic,strong) NSString* haveRotated;
-(void)rotateCoordinat;
@end
