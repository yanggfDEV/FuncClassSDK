//
//  FZPlaceholderTextView.m
//  EnglishTalk
//
//  Created by huyangming on 15/3/25.
//  Copyright (c) 2015年 ishowtalk. All rights reserved.
//

#import "FZPlaceholderTextView.h"

@implementation FZPlaceholderTextView


-(void)setTextViewText:(NSString *)text
{
    self.text=text;
    
    [self updateText];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (void)setup {
    // Initialization code
    CGRect  viewFrame = CGRectMake(5, 5, self.frame.size.width -10, 30);
    _placeholderLabel = [[UILabel alloc] initWithFrame:viewFrame];
    _placeholderLabel.numberOfLines=0;
    _placeholderLabel.textColor = [UIColor colorWithHexString:@"666666"];
    _placeholderLabel.font=[UIFont systemFontOfSize:15];
    _placeholderLabel.backgroundColor=[UIColor clearColor];
    [self addSubview:_placeholderLabel];
    
    // Add text changed notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholderLabel.text = placeholder;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    _placeholderLabel.textColor = placeholderColor;
}

- (NSString*)placeholder {
    return _placeholderLabel.text;
}

-(void)updateText
{
    if ([self.text length]>0) {
        _placeholderLabel.hidden=YES;
    }
    else
    {
        _placeholderLabel.hidden=NO;
    }
}

#pragma mark UITextViewTextDidChangeNotification

- (void)textChanged:(NSNotification *)notification {
    [self updateText];
}
-(void)dealloc
{
    self.placeholderLabel=nil;
    self.placeholder=nil;
    self.placeholderColor=nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//    self.placeholderLabel.frame = CGRectMake(5, 5, self.frame.size.width -10, 60);
//}

@end
