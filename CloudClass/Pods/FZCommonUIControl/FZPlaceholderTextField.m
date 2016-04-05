//
//  FZPlaceholderTextField.m
//  Pods
//
//  Created by Patty on 15/7/8.
//
//

#import "FZPlaceholderTextField.h"

@implementation FZPlaceholderTextField

-(void)setTextFieldText:(NSString *)text
{
    self.text=text;
    
    [self updateText];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGRect  viewFrame = CGRectMake(10, -4, frame.size.width, 45);
        _placeholderLabel = [[UILabel alloc] initWithFrame:viewFrame];
        _placeholderLabel.numberOfLines=0;
        _placeholderLabel.textColor = [UIColor colorWithHexString:@"666666"];
        _placeholderLabel.font=[UIFont systemFontOfSize:15];
        _placeholderLabel.backgroundColor=[UIColor clearColor];
       // [self addSubview:_placeholderLabel];
        
        
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
        self.leftView = paddingView;
        self.leftViewMode = UITextFieldViewModeAlways;
        
        // Add text changed notification
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextFieldTextDidChangeNotification object:nil];
        
    }
    return self;
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
   // [self updateText];
}
-(void)dealloc
{
    self.placeholderLabel=nil;
    self.placeholder=nil;
    self.placeholderColor=nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}


@end
