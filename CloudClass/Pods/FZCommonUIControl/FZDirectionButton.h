//
//  FZDirectionButton.h
//  //  Created by Liuyong on 14-12-29.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FZDirectionButtonLayout) {
    FZDirectionButtonLayoutNone,      //Default
    FZDirectionButtonLayoutVerticalImageUp,
    FZDirectionButtonLayoutVerticalImageDown,
    FZDirectionButtonLayoutHorizontalImageLeft,
    FZDirectionButtonLayoutHorizontalImageRight
};


@interface FZDirectionButton : UIButton

/**
 *  Default: FZDirectionButtonLayoutNone
 */
@property (nonatomic, readwrite) FZDirectionButtonLayout layoutDirection;

/**
 *  The space is between image and title : default is 5.f;
 */
@property (nonatomic, readwrite) CGFloat betweenSpace;

@end
