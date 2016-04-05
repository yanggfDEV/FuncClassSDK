//
//  FZUIButton.m
//  EnglishTalk
//
//  Created by huyangming on 15/3/29.
//  Copyright (c) 2015年 ishowtalk. All rights reserved.
//

#import "FZUIButton.h"
#import <UIImageScale.h>
#import "UIColor+Hex.h"
#import <UIColor+Hex.h>

@implementation FZUIButton

-(void)dealloc
{
    self.tapParameter=nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (void)setup {
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    UIColor* normalImageColor = [UIColor colorWithHex:0x439cf4];
    UIColor* highlightImageColor = [UIColor colorWithHex:0x439ce0];
    UIImage* normalImage = [UIImage createImageWithColor:normalImageColor];
    UIImage* highlightImage = [UIImage createImageWithColor:highlightImageColor];
    [self setBackgroundImage:normalImage forState:UIControlStateNormal];
    [self setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    //描边
//    CGColorRef cgColor = [UIColor colorWithHexString:@"89ca30"].CGColor;
//    [self.layer setBorderColor:cgColor];
    [self.layer setCornerRadius:5]; //设置矩形四个圆角半径
//    [self.layer setBorderWidth:1]; //边框宽度
    self.layer.masksToBounds = YES;

    [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
}

- (id)initMoreTimeButtonWithFrame:(CGRect)frame title:(NSString*)title target:(id)target action:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHexString:@"3885d2"] forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    
        
        UIColor* beforeClickColor =[UIColor colorWithHexString:@"ffffff"];
        UIColor* afterClickColor = [UIColor colorWithHexString:@"dfdfdf"];
        UIImage* image15 = [UIImage createImageWithColor:beforeClickColor];
        UIImage* image30 = [UIImage createImageWithColor:afterClickColor];
        [self setBackgroundImage:image15 forState:UIControlStateNormal];
        [self setBackgroundImage:image30 forState:UIControlStateHighlighted];
        
//        CGColorRef cgColor = [UIColor colorWithHexString:@"23cc71"].CGColor;
//        [self.layer setBorderColor:cgColor];
        [self.layer setCornerRadius:5]; //设置矩形四个圆角半径
//        [self.layer setBorderWidth:1]; //边框宽度
        self.layer.masksToBounds = YES;
        [self addTarget:target  action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (id)initALiOrangeButtonWithFrame:(CGRect)frame title:(NSString*)title target:(id)target action:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHexString:@"89ca30"] forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        UIColor* beforeClickColor = [UIColor whiteColor];
        UIColor* afterClickColor = [UIColor colorWithHexString:@"dddddd"];
        UIImage* image15 = [UIImage createImageWithColor:beforeClickColor];
        UIImage* image30 = [UIImage createImageWithColor:afterClickColor];
        [self setBackgroundImage:image15 forState:UIControlStateNormal];
        [self setBackgroundImage:image30 forState:UIControlStateHighlighted];
        
        //描边
        CGColorRef cgColor = [UIColor colorWithHexString:@"89ca30"].CGColor;
        //CGColorRef cgColor = [UIColor greenColor].CGColor;
        //CGColorSpaceRef colorSpace = CGColorGetColorSpace(cgColor);
        //CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
        [self.layer setBorderColor:cgColor];
        [self.layer setCornerRadius:2.5]; //设置矩形四个圆角半径
        [self.layer setBorderWidth:1]; //边框宽度
        [self.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self addTarget:target  action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (id)initWithPairButtonWithFrame:(CGRect)frame title:(NSString*)title target:(id)target action:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:18]];
        
        
        UIColor* beforeClickColor =[UIColor colorWithHexString:@"3d9af7"];
        UIImage* image15 = [UIImage createImageWithColor:beforeClickColor];
        [self setBackgroundImage:image15 forState:UIControlStateNormal];
      
       // CGColorRef cgColor = [UIColor colorWithHexString:@"23cc71"].CGColor;
     //   [self.layer setBorderColor:cgColor];
        [self.layer setCornerRadius:25]; //设置矩形四个圆角半径
      //  [self.layer setBorderWidth:1]; //边框宽度
        self.layer.masksToBounds = YES;
        [self addTarget:target  action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;

}

- (id)initSignInButtonWithFrame:(CGRect)frame title:(NSString*)title target:(id)target action:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:19]];
        
        UIColor* normalClickColor =[UIColor colorWithHexString:@"439cf4"];
        UIColor* highlightClickColor = [UIColor colorWithHexString:@"3e8fe0"];
        UIColor* disableClickColor = [UIColor colorWithHexString:@"aebece"];
        UIImage* imageNormal = [UIImage createImageWithColor:normalClickColor];
        UIImage* imageHighlight = [UIImage createImageWithColor:highlightClickColor];
        UIImage* imageDisable = [UIImage createImageWithColor:disableClickColor];
        [self setBackgroundImage:imageNormal forState:UIControlStateNormal];
        [self setBackgroundImage:imageHighlight forState:UIControlStateHighlighted];
        [self setBackgroundImage:imageDisable forState:UIControlStateDisabled];
        
//        CGColorRef cgColor = [UIColor colorWithHexString:@"23cc71"].CGColor;
//        [self.layer setBorderColor:cgColor];
//        [self.layer setBorderWidth:1]; //边框宽度
        [self.layer setCornerRadius:5]; //设置矩形四个圆角半径
        self.layer.masksToBounds = YES;
        [self addTarget:target  action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (id)initDepositButtonWithFrame:(CGRect)frame title:(NSString*)title target:(id)target action:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:18]];
       // self.backgroundColor = [UIColor colorWithHexString:@"23cc71"];//2ecc71
        
        UIColor* beforeClickColor =[UIColor colorWithHexString:@"3d9af7"];
      //  UIColor* afterClickColor = [UIColor colorWithHexString:@"ff4400"];
        UIImage* image15 = [UIImage createImageWithColor:beforeClickColor];
       // UIImage* image30 = [UIImage createImageWithColor:afterClickColor];
        [self setBackgroundImage:image15 forState:UIControlStateNormal];
        //[self setBackgroundImage:image30 forState:UIControlStateHighlighted];
        //[self setBackgroundColor:[UIService getFobColor]];
        
//        CGColorRef cgColor = [UIColor colorWithHexString:@"2ecc71"].CGColor;
     //   [self.layer setBorderColor:cgColor];
        [self.layer setCornerRadius:4]; //设置矩形四个圆角半径
       // [self.layer setBorderWidth:1]; //边框宽度
        self.layer.masksToBounds = YES;
        [self addTarget:target  action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (id)initForgotButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHexString:@"3885d2"] forState:UIControlStateNormal];
        [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:15]];
      
        [self addTarget:target  action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;

}

- (id)initNewUpdateButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        
        self.layer.cornerRadius = frame.size.width/2;
        self.layer.masksToBounds = YES;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor colorWithHexString:@"f94427"];
        
        [self addTarget:target  action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (id)initNewMessageButtonWithFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self) {
        
        if(title.integerValue > 0){
            [self setTitle:title forState:UIControlStateNormal];
        }
        
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        
        self.layer.cornerRadius = self.frame.size.width/2;
        self.layer.masksToBounds = YES;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor colorWithHexString:@"f94427"];
        
        
        [self addTarget:target  action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}


- (id)initWithRightButtonItemwithTitle:(NSString *)title target:(id)target action:(SEL)action

{
    self = [super initWithFrame:CGRectMake(0, 0, 44, 44)];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHexString:@"439cf4"] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        
        [self addTarget:target  action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (id)initWithLeftButtonItemwithTitle:(NSString *)title target:(id)target action:(SEL)action

{
    self = [super initWithFrame:CGRectMake(0, 0, 44, 44)];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHexString:@"439cf4"] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        
        [self addTarget:target  action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (id)initWithBottomLeftButtonwithwithFrame:(CGRect)frame Title:(NSString *)title target:(id)target action:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHexString:@"3885d2"] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:20];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        
        [self setImage:[UIImage imageNamed:@"img_unselect"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"img_select"] forState:UIControlStateSelected];
        
        self.imageEdgeInsets = UIEdgeInsetsMake(8, 10, 8, 30);
        self.titleEdgeInsets = UIEdgeInsetsMake(8, 20, 8, 0);
        [self addTarget:target  action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (id)initWithBottomRightButtonwithwithFrame:(CGRect)frame Title:(NSString *)title target:(id)target action:(SEL)action
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHexString:@"3885d2"] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:20];
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        
        [self addTarget:target  action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame withFont:(CGFloat)fontSize withTitle:(NSString *)title withTitleColor:color target:(id)target action:(SEL)action
{
    self = [super initWithFrame:frame];
    if(self){
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:color forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        
        [self addTarget:target  action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withImage:(NSString *)imageName target:(id)target action:(SEL)action
{
    self = [super initWithFrame:frame];
    if(self){
        [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [self addTarget:target  action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (id)initGuideButtonWithFrame:(CGRect)frame withTitle:(NSString *)title  target:(id)target action:(SEL)action
{
    self = [super initWithFrame:frame];
    if(self){
        [self setTitle:title forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithHexString:@"439cf4"];
        [self addTarget:target  action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

@end
