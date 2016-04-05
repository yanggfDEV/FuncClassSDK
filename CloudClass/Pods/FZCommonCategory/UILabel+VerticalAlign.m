//
//  UILabel+VerticalAlign.m
//  EnAlibaba
//
//  Created by joy on 13-10-11.
//  Copyright (c) 2013年 com.alibaba.test. All rights reserved.
//

#import "UILabel+VerticalAlign.h"

@implementation UILabel (VerticalAlign)
//- (void)alignTop {
//    CGSize fontSize = [self.text sizeWithFont:self.font];
//    double finalHeight = fontSize.height * self.numberOfLines;
//    double finalWidth = self.frame.size.width;    //expected width of label
//    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
//    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
//    for(int i=0; i<newLinesToPad; i++)
//        self.text = [self.text stringByAppendingString:@"\n "];
//}

- (void)alignTop
{
    NSMutableString *resultStr =[self.text mutableCopy];
    NSArray *array = [resultStr componentsSeparatedByString:@"\n"];
    NSInteger temp = 0;
    
    NSInteger lines = self.lineBreakMode;
    
    for (int j=0; j <array.count; j++) {
        NSString *str = array[j];
        if([str isEqualToString:@""]){
            temp --;
        }
        
        if(str.length > 50){
            temp ++;
        }
    }
    
    for (int i=0; i< (lines -array.count-temp+1); i++) {
        [resultStr appendString:@"\n "];
    }
    self.text = resultStr;
}

- (void)alignBottom {
    CGSize fontSize = [self.text sizeWithFont:self.font];
    double finalHeight = fontSize.height * self.numberOfLines;
    double finalWidth = self.frame.size.width;    //expected width of label
    CGSize theStringSize = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(finalWidth, finalHeight) lineBreakMode:self.lineBreakMode];
    int newLinesToPad = (finalHeight  - theStringSize.height) / fontSize.height;
    for(int i=0; i<newLinesToPad; i++)
        self.text = [NSString stringWithFormat:@" \n%@",self.text];
}

- (void) setHighLabel:(NSString *)string
						 Font:(UIFont *)font
					   StartX:(CGFloat)x
					   StartY:(CGFloat)y
						Width:(CGFloat)width
                        Color:(UIColor *)color
{
	CGSize constraintSize;
	constraintSize.width = width;
	constraintSize.height = MAXFLOAT;
	CGSize titleSize = [string sizeWithFont:font
                          constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    [self setFrame: CGRectMake(x, y, titleSize.width, titleSize.height)];
	self.lineBreakMode = NSLineBreakByWordWrapping;
	self.numberOfLines = 0;
    self.textAlignment=NSTextAlignmentLeft;
	[self setFont:font];
	[self setText:string];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setTextColor:color];
    
    CGRect r=self.frame;
    r.size.height=titleSize.height;
    self.frame=r;
}

- (void) setHighLabel:(NSString *)string
                 Font:(UIFont *)font
               StartX:(CGFloat)x
               StartY:(CGFloat)y
                Width:(CGFloat)width
                Color:(UIColor *)color
              MaxLine:(int) line
{
	CGSize constraintSize;
	constraintSize.width = width;
	constraintSize.height = MAXFLOAT;
	CGSize titleSize = [string sizeWithFont:font
                          constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    [self setFrame: CGRectMake(x, y, titleSize.width, titleSize.height)];
	self.lineBreakMode = NSLineBreakByTruncatingTail;
	self.numberOfLines = line;
    self.textAlignment=NSTextAlignmentLeft;
	[self setFont:font];
	[self setText:string];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setTextColor:color];
    [self sizeToFit];
    //    CGRect r=self.frame;
//    r.size.height=titleSize.height;
//    self.frame=r;
}

-(void)setLabelListWithFrame:(CGRect)frame line:(NSInteger)line font:(UIFont*)font color:(UIColor*)color
{
    self.frame=frame;
    [self setFont:font];
    [self setLineBreakMode:NSLineBreakByTruncatingTail];
    self.autoresizingMask=UIViewAutoresizingFlexibleWidth;
    [self setTextColor:color];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setNumberOfLines:line];
}

-(void )setLabelWithLink:(NSString *)string Font:(UIFont *)font StartX:(CGFloat)x StartY:(CGFloat)y Width:(CGFloat)width target:(id)_target action:(SEL)_action
{
    
    CGSize constraintSize;
	constraintSize.width = width;
	constraintSize.height = MAXFLOAT;
	CGSize titleSize = [string sizeWithFont:font
                          constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
	
	
	[self setFrame:CGRectMake(x, y, titleSize.width, titleSize.height)];
	self.lineBreakMode = NSLineBreakByWordWrapping;
	self.numberOfLines = 1000;
	[self setFont:font];
	[self setText:string];
    
    //默认的字体颜色状态
    self.textColor=[UIColor colorWithRed:0.0000 green:0.4000 blue:0.8000 alpha:1.0000];
    self.backgroundColor=[UIColor clearColor];
    
    //添加动作
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:_target action:_action];
    [self addGestureRecognizer:tapGesture];
    self.userInteractionEnabled=YES;
}
- (void) setHighLabelWithNoLimited:(NSString *)string
                                      Font:(UIFont *)font
                                    StartX:(CGFloat)x
                                    StartY:(CGFloat)y
                                     Width:(CGFloat)width
                                     Color:(UIColor*)color
{
	CGSize constraintSize;
	constraintSize.width = width;
    constraintSize.height=100000000000.0f;
	CGSize titleSize = [string sizeWithFont:font
                          constrainedToSize:constraintSize  lineBreakMode:NSLineBreakByWordWrapping];
	

	self.frame=CGRectMake(x, y, titleSize.width, titleSize.height+2);
	self.lineBreakMode = NSLineBreakByWordWrapping;
	self.numberOfLines = 0;
	[self setFont:font];
	[self setText:string];
    [self setTextColor:color];
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void) setHighLabelWithNoLimitedWidth:(NSString *)string
                              Font:(UIFont *)font
                            StartX:(CGFloat)x
                            StartY:(CGFloat)y
                             Width:(CGFloat)width
                             Color:(UIColor*)color
{
    CGSize constraintSize;
    constraintSize.width = width;
    constraintSize.height=100000000000.0f;
    CGSize titleSize = [string sizeWithFont:font
                          constrainedToSize:constraintSize  lineBreakMode:NSLineBreakByWordWrapping];
    
    
    self.frame=CGRectMake(x, y, width, titleSize.height+2);
    self.lineBreakMode = NSLineBreakByWordWrapping;
    self.numberOfLines = 0;
    [self setFont:font];
    [self setText:string];
    [self setTextColor:color];
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void) setNormLabel:(NSString *)string
						 Font:(UIFont *)font
					   StartX:(CGFloat)x
					   StartY:(CGFloat)y
                        Width:(CGFloat)width Color:(UIColor *)color
{
	CGSize constraintSize;
	constraintSize.width = MAXFLOAT;
	constraintSize.height = MAXFLOAT;
	CGSize titleSize = [string sizeWithFont:font
						  constrainedToSize:constraintSize lineBreakMode:NSLineBreakByTruncatingTail];
	
	CGFloat realwidth = (titleSize.width > width)?width:titleSize.width;
	
	self.frame=CGRectMake(x, y, realwidth+2, titleSize.height+2);
	self.lineBreakMode = NSLineBreakByTruncatingTail;
	self.numberOfLines = 1;
	[self setFont:font];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setTextColor:color];
	[self setText:string];
}
- (void) setNormLabel:(NSString *)string
						 Font:(UIFont *)font
					   StartX:(CGFloat)x
					   StartY:(CGFloat)y
						Width:(CGFloat)width
{
	CGSize constraintSize;
	constraintSize.width = MAXFLOAT;
	constraintSize.height = MAXFLOAT;
	CGSize titleSize = [string sizeWithFont:font
						  constrainedToSize:constraintSize lineBreakMode:NSLineBreakByTruncatingTail];
	
	CGFloat realwidth = (titleSize.width > width)?width:titleSize.width;
	
	[self setFrame:CGRectMake(x, y, realwidth, titleSize.height)];
	self.lineBreakMode = NSLineBreakByTruncatingTail;
	self.numberOfLines = 1;
	[self setFont:font];
    [self setBackgroundColor:[UIColor clearColor]];
	[self setText:string];
}
- (void) setLabel:(NSString *)string
                        Font:(UIFont *)font
                      StartX:(CGFloat)x
                      StartY:(CGFloat)y
                       Width:(CGFloat)width
                       Color:(UIColor *)color
{
		
	[self setFrame:CGRectMake(x, y, width, 20)];
	[self setFont:font];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setTextColor:color];
	[self setText:string];
}



@end

