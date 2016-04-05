//
//  ALIUIBarButtonItem.m
//  EnAlibaba
//
//  Created by joy on 14-3-12.
//  Copyright (c) 2014年 com.alibaba.test. All rights reserved.
//

#import "FZUIBarButtonItem.h"
#import "UIImageView+WebCache.h"
#import "UIImageScale.h"
#import "UIColor+Hex.h"

#define OSVERSION [[UIDevice currentDevice].systemVersion intValue]

@implementation FZUIBarButtonItem

-(id) initImageWithImageUrl:(NSString *)urlString target:(id)target action:(SEL)action
{

    UIImageView * imageV=[[UIImageView alloc] init];
    
    [imageV sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    }];
    imageV.frame = CGRectMake(0, 0, imageV.image.size.width, imageV.image.size.height);
    
    imageV.userInteractionEnabled=YES;
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [imageV addGestureRecognizer:tap];

    self=[super initWithCustomView:imageV];
    
    return self;
}


-(id) initImageWithName:(NSString *)title target:(id)target action:(SEL)action
{
    if (OSVERSION>=7) {
        self=[super initWithImage:[UIImage imageNamed:title] style:UIBarButtonItemStylePlain target:target action:action];
        if (self) {
            self.tintColor=[UIColor whiteColor];
        }
    }
    else
    {
        UIImageView * imageV=[[UIImageView alloc] init];
        imageV.image = [UIImage imageNamed:title];
        imageV.frame = CGRectMake(0, 0, imageV.image.size.width, imageV.image.size.height);
        
        imageV.userInteractionEnabled=YES;
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:target action:action];
        [imageV addGestureRecognizer:tap];
        
        self=[super initWithCustomView:imageV];
    }
    return self;
}

-(id) initCustomViewWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    if (OSVERSION>=7) {
        self=[super initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
        if (self) {
            self.tintColor=[UIColor colorWithHexString:@"3484e0"];
        }
    }
    else
    {
        CGSize constraintSize;
        constraintSize.width = 300;
        constraintSize.height=300.0f;
        CGSize titleSize = [title sizeWithFont:[UIFont fontWithName:@"Helvetica-Light" size:15]
                             constrainedToSize:constraintSize  lineBreakMode:NSLineBreakByWordWrapping];
        UILabel * label=[[UILabel alloc] initWithFrame:CGRectMake(0, 30, titleSize.width+2, 20)];
        [label setText:title];
        label.font=[UIFont fontWithName:@"Helvetica-Light" size:15];
        label.textColor=[UIColor colorWithHexString:@"3484e0"];
        label.backgroundColor=[UIColor clearColor];
        label.userInteractionEnabled=YES;
        
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:target action:action];
        [label addGestureRecognizer:tap];
        
        self=[super initWithCustomView:label];
        if (self) {
        }
    }

    return self;
}
-(id) initBackButtonItemWithFrame:(CGRect)frame target:(id)target action:(SEL)action
{
    
    UIImageView * imageV=[[UIImageView alloc] init];
    imageV.image=[UIImage imageNamed:@"naviBack"];
    imageV.frame = CGRectMake(-10, 0, imageV.image.size.width, imageV.image.size.height);
    
    imageV.userInteractionEnabled=YES;
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [imageV addGestureRecognizer:tap];
    
    self=[super initWithCustomView:imageV];
    
    
    return self;
}

-(id) initCustomOrangeButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(10, 0, 60, 30);
    if (OSVERSION>=7){
        btn.tintColor=[UIColor whiteColor];
    }
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:4.0]; //设置矩形四个圆角半径
    [btn.layer setBorderWidth:1.0]; //边框宽度
    [btn.layer setBorderColor:[UIColor clearColor].CGColor]; //边框宽度
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font=[UIFont fontWithName:@"Helvetica-Light" size:16];
    UIImage *fobImg			= [UIImage createImageWithColor:[UIColor colorWithRed:1.0000 green:0.4000 blue:0.0000 alpha:1.0000]];
    UIImage *whiteImg			= [UIImage createImageWithColor:[UIColor colorWithRed:1.0000 green:0.4000 blue:0.0000 alpha:0.3]];
    [btn setBackgroundImage:fobImg forState:UIControlStateNormal];
    [btn setBackgroundImage:whiteImg forState:UIControlStateDisabled];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    self = [[FZUIBarButtonItem alloc] initWithCustomView:btn];
    return self;
}


@end
