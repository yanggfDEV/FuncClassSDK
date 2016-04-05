//
//  NIEIconImageView.m
//
//
//  Created by Liuyong on 12/10/15.
//  Copyright (c) 2015 feizhu tech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FZIconImageViewStyle){
    FZIconImageViewStyleSquare,
    FZIconImageViewStyleRound,
    FZIconImageViewStyleCircle
};

@interface FZIconImageView : UIImageView

- (id)initWithFrame:(CGRect)frame iconStyle:(FZIconImageViewStyle)iconStyle;

/**
 *  icon style :Default is NIEIconImageViewStyleCircle
 */
@property (assign, nonatomic) FZIconImageViewStyle iconStyle;
@property (assign, nonatomic) NSInteger borderWidth; //default is 3.f when iconStyle is NIEIconImageViewStyleCircle
@property (strong, nonatomic) UIColor *borderColor;  //default is [UIColor colorWithWhite:1.f alpha:0.15f];
@property (strong, nonatomic, readonly) UIImage *currentImage;

@property (assign, nonatomic) BOOL shouldTransitionAnimation; //Default is NO, setImage: 需要过渡动画

- (instancetype)copyWithZone:(NSZone *)zone;
@end
