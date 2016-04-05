//
//  FZDirectionButton.m
//  //  Created by Liuyong on 14-12-29.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import "FZDirectionButton.h"

@implementation FZDirectionButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.layoutDirection = FZDirectionButtonLayoutHorizontalImageLeft;
    self.betweenSpace = 5.0f;
    
}

- (void)setLayoutDirection:(FZDirectionButtonLayout)layoutDirection {
    _layoutDirection = layoutDirection;
    [self updateInsets];
}

- (void)setBetweenSpace:(CGFloat)betweenSpace {
    _betweenSpace = betweenSpace;
    [self updateInsets];
}

//- (void)setImage:(UIImage *)image forState:(UIControlState)state {
//    [super setImage:image forState:state];
//    [self updateInsets];
//}
//
//- (void)setTitle:(NSString *)title forState:(UIControlState)state {
//    [super setTitle:title forState:state];
//    [self updateInsets];
//}
//
//- (void)setAttributedTitle:(NSAttributedString *)title forState:(UIControlState)state {
//    [super setAttributedTitle:title forState:state];
//    [self updateInsets];
//}

- (void)updateInsets {
//    UIEdgeInsets titleInsets = UIEdgeInsetsZero;
//    UIEdgeInsets imageInsets = UIEdgeInsetsZero;
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    if (![self imageForState:UIControlStateNormal] || self.titleLabel.text.length == 0) {
        return;
    }
    
    CGSize imageSize = [self imageForState:UIControlStateNormal].size;
    //CGSize titleSize = self.titleLabel.intrinsicContentSize;
    switch (self.layoutDirection) {
        case FZDirectionButtonLayoutNone:
        break;
        case FZDirectionButtonLayoutHorizontalImageLeft:
        {
            //titleInsets = [self edgeInsetsWithXOffset:self.betweenSpace yOffset:0.0f];
            contentInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, self.betweenSpace);
        }
        break;
        case FZDirectionButtonLayoutHorizontalImageRight:
        {
//            titleInsets = [self edgeInsetsWithXOffset:-imageSize.width yOffset:0.0f];
//            imageInsets = [self edgeInsetsWithXOffset:titleSize.width + self.betweenSpace yOffset:0.0f];
            contentInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, self.betweenSpace);
        }
        break;
        case FZDirectionButtonLayoutVerticalImageDown:
        {
//            titleInsets = [self edgeInsetsWithXOffset:-imageSize.width yOffset:0.0f];
//            imageInsets = [self edgeInsetsWithXOffset:(titleSize.width - imageSize.width) / 2.0f yOffset:imageSize.height + self.betweenSpace];
            contentInsets = UIEdgeInsetsMake(0.0f, 0.0f, imageSize.height + self.betweenSpace, -imageSize.width);
        }
        break;
        case FZDirectionButtonLayoutVerticalImageUp:
        {
//            titleInsets = [self edgeInsetsWithXOffset:-imageSize.width yOffset:0.0f];
//            imageInsets = [self edgeInsetsWithXOffset:(titleSize.width - imageSize.width) / 2.0f yOffset:-imageSize.height - self.betweenSpace];
            contentInsets = UIEdgeInsetsMake(imageSize.height + self.betweenSpace, 0.0f, 0.0f, -imageSize.width);
        }
        break;
    }
    
//    self.titleEdgeInsets = titleInsets;
//    self.imageEdgeInsets = imageInsets;
    self.contentEdgeInsets = contentInsets;
    [self setNeedsLayout];
    [self invalidateIntrinsicContentSize];
}

- (UIEdgeInsets)edgeInsetsWithXOffset:(CGFloat)x yOffset:(CGFloat)y {
    return UIEdgeInsetsMake(y, x, -y, -x);
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (![self imageForState:UIControlStateNormal] || self.titleLabel.text.length == 0) {
        return;
    }
    
    if (self.layoutDirection == FZDirectionButtonLayoutNone) {
        return;
    }
    
    CGSize imageSize = self.imageView.intrinsicContentSize;
    CGSize titleSize = self.titleLabel.intrinsicContentSize;
    CGPoint titlePosition = CGPointZero, imagePosition = CGPointZero;
    
//    if((CGRectGetWidth(self.bounds) - imageSize.width - self.betweenSpace) < titleSize.width){
//        titleSize.width = (CGRectGetWidth(self.bounds) - imageSize.width - self.betweenSpace);
//    }
    
    switch (self.layoutDirection) {
        case FZDirectionButtonLayoutNone:
            break;
        case FZDirectionButtonLayoutHorizontalImageLeft:
        {
            imagePosition = CGPointMake((CGRectGetWidth(self.bounds) - imageSize.width - titleSize.width - self.betweenSpace) / 2.0f, (CGRectGetHeight(self.bounds) - imageSize.height) / 2.0f);
            titlePosition = CGPointMake(imagePosition.x + self.betweenSpace + imageSize.width, (CGRectGetHeight(self.bounds) - titleSize.height) / 2.0f);
        }
            break;
        case FZDirectionButtonLayoutHorizontalImageRight:
        {
            titlePosition = CGPointMake((CGRectGetWidth(self.bounds) - imageSize.width - titleSize.width - self.betweenSpace) / 2.0f, (CGRectGetHeight(self.bounds) - titleSize.height) / 2.0f);
            imagePosition = CGPointMake(titlePosition.x + self.betweenSpace + titleSize.width, (CGRectGetHeight(self.bounds) - imageSize.height) / 2.0f);
        }
            break;
        case FZDirectionButtonLayoutVerticalImageUp:
        {
            imagePosition = CGPointMake((CGRectGetWidth(self.bounds) - imageSize.width) / 2.0f, (CGRectGetHeight(self.bounds) - self.betweenSpace - imageSize.height - titleSize.height) / 2.0f);
            titlePosition = CGPointMake((CGRectGetWidth(self.bounds) - titleSize.width) / 2.0f, imagePosition.y + self.betweenSpace + imageSize.height);
        }
            break;
        case FZDirectionButtonLayoutVerticalImageDown:
        {
            titlePosition = CGPointMake((CGRectGetWidth(self.bounds) - titleSize.width) / 2.0f, (CGRectGetHeight(self.bounds) - self.betweenSpace - imageSize.height - titleSize.height) / 2.0f);
            imagePosition = CGPointMake((CGRectGetWidth(self.bounds) - imageSize.width) / 2.0f, titlePosition.y + self.betweenSpace + titleSize.height);
        }
            break;
    }
    
    self.imageView.frame = CGRectMake(imagePosition.x, imagePosition.y, imageSize.width, imageSize.height);
    self.titleLabel.frame = CGRectMake(titlePosition.x, titlePosition.y, titleSize.width, titleSize.height);
}




@end
