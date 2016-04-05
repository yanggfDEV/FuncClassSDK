//
//  FZUILabel.m
//  Pods
//
//  Created by patty on 15/11/24.
//
//

#import "FZUILabel.h"

@implementation FZUILabel

- (id)initWithFrame:(CGRect)frame withTitle:(NSString *)title withTitleColor:(UIColor *)color withFontSize:(CGFloat)fontSize withTextAlignment:(NSTextAlignment)aligment
{
    self = [super initWithFrame:frame];
    if (self) {
        self.text = title;
        self.textColor = color;
        self.textAlignment = aligment;
        self.font = [UIFont systemFontOfSize:fontSize];
    }
    return self;
}

@end
