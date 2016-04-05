//
//  NIEIconImageView.m
//  niespider
//
//  Created by Liuyong on 12/10/14.
//  Copyright (c) 2014 netease. All rights reserved.
//

#import <Masonry/Masonry.h>

#import "FZIconImageView.h"

@interface FZIconImageView ()

@property (strong, nonatomic) UIImageView *contentImageView;
@property (strong, nonatomic) CALayer *borderLayer;

@end

@implementation FZIconImageView

- (id)initWithFrame:(CGRect)frame iconStyle:(FZIconImageViewStyle)iconStyle
{
    self = [self initWithFrame:frame];
    if (self) {
        self.iconStyle = iconStyle;
    }
    
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone{
    FZIconImageView *another = [[FZIconImageView allocWithZone:zone]init];
    another.frame = self.frame;
    another.layer.masksToBounds = self.layer.masksToBounds;
    another.layer.cornerRadius = self.layer.cornerRadius;
    another.layer.borderWidth = self.layer.borderWidth;
    another.layer.borderColor = self.layer.borderColor;
    another.shouldTransitionAnimation = self.shouldTransitionAnimation;
    another.image = self.image;
    another.tag = self.tag;
    
    another.contentImageView = [self.contentImageView copy];
    
    CALayer *borderLayer = [CALayer layer];
    //    borderLayer.backgroundColor = [UIColor blueColor].CGColor;
    borderLayer.masksToBounds = YES;
    borderLayer.borderColor = [UIColor colorWithWhite:1 alpha:0.15f].CGColor;
    borderLayer.borderWidth = self.borderWidth;
    borderLayer.cornerRadius = self.borderLayer.cornerRadius;
    borderLayer.frame = self.bounds;
    
    another.borderLayer = borderLayer;
    another.borderWidth = self.borderWidth;
    another.borderColor = self.borderColor;
    another.iconStyle = self.iconStyle;
    
    return another;
}

- (void)setup
{
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    self.iconStyle = FZIconImageViewStyleCircle;
    self.borderWidth = 3.f;
    self.borderColor = [UIColor colorWithWhite:1.f alpha:0.15f];
    
    CALayer *borderLayer = [CALayer layer];

    borderLayer.masksToBounds = YES;
    borderLayer.borderColor = [UIColor colorWithWhite:1 alpha:0.15f].CGColor;
    borderLayer.borderWidth = self.borderWidth;
    borderLayer.frame = self.bounds;

    [self.layer addSublayer:borderLayer];
    
    [self.layer insertSublayer:borderLayer atIndex:0];
    
    self.borderLayer = borderLayer;
    
    if (!self.contentImageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.clipsToBounds = YES;
        imageView.backgroundColor = [UIColor clearColor];
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderWidth = 0;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
        self.contentImageView = imageView;
    }
    self.clipsToBounds = YES;
  
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
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

- (void)setContentImageView:(UIImageView *)contentImageView {
    if (_contentImageView != contentImageView) {
        _contentImageView = contentImageView;
        [self addSubview:contentImageView];
        [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self).offset(self.borderWidth);
            make.trailing.equalTo(self).offset(-self.borderWidth);
            make.top.equalTo(self).offset(self.borderWidth);
            make.bottom.equalTo(self).offset(-self.borderWidth);
        }];
    }
}

- (void)setBorderLayer:(CALayer *)borderLayer {
    if (_borderLayer != borderLayer) {
        _borderLayer = borderLayer;
        [self.layer insertSublayer:borderLayer atIndex:0];
    }
}

- (void)setIconStyle:(FZIconImageViewStyle)iconStyle
{
    _iconStyle = iconStyle;
    switch (iconStyle) {
        case FZIconImageViewStyleSquare:
        {
            self.layer.cornerRadius = 0.f;
        }
            break;
        case FZIconImageViewStyleRound:
        {
            self.layer.cornerRadius = 9.f;
            self.contentImageView.layer.cornerRadius = 9.0f;
        }
            break;
        case FZIconImageViewStyleCircle:
        {
            self.layer.cornerRadius = CGRectGetWidth(self.bounds) / 2.f;
            self.borderLayer.frame = self.bounds;
            self.contentImageView.layer.cornerRadius = CGRectGetWidth(self.contentImageView.bounds) / 2.f;
            self.borderLayer.cornerRadius = CGRectGetWidth(self.borderLayer.bounds)/2.f;
        }
            break;
            
        default:
            break;
    }
    [self setNeedsDisplay];
}

- (void)setBorderWidth:(NSInteger)borderWidth {
    _borderWidth = borderWidth;
    self.borderLayer.borderWidth = borderWidth;
    [self.contentImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(self.borderWidth);
        make.trailing.equalTo(self).offset(-self.borderWidth);
        make.top.equalTo(self).offset(self.borderWidth);
        make.bottom.equalTo(self).offset(-self.borderWidth);
    }];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self setIconStyle:_iconStyle];
}

- (void)setNeedsLayout
{
    [super setNeedsLayout];
    
    [self setIconStyle:_iconStyle];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setIconStyle:_iconStyle];
}

- (void)setImage:(UIImage *)image {
    [super setImage:nil];
    [self.contentImageView setImage:image];
    if (self.shouldTransitionAnimation) {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.7f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        [self.layer addAnimation:transition forKey:nil];
    }

}

- (UIImage *)currentImage {
    return self.contentImageView.image;
}

//- (UIImage *)image {
//    return nil;//self.contentImageView.image;
//}


@end