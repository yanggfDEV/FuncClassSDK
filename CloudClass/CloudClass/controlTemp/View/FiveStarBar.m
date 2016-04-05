//
//  FiveStarBar.m
//  EnglishTalk
//
//  Created by DING FENG on 6/18/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import "FiveStarBar.h"
#import "PublicMacros.h"
@interface FiveStarBar()
{
    NSMutableArray  *_imgeViewArray;
}
@end

@implementation FiveStarBar

@synthesize currentValue = _currentValue;

- (id)init
{
    self = [super init];
    if (self) {
        _imgeViewArray = [NSMutableArray arrayWithCapacity:0];
        float starSize = 13.3f;
        for (int i = 0; i < 5; i ++) {
            UIImageView *starImageView = [[UIImageView alloc] init];
            starImageView.tag = i + 10;
            starImageView.image  = [UIImage imageNamed:@"star-1.png"];
            [self addSubview:starImageView];
            [_imgeViewArray addObject:starImageView];
            ESWeakSelf;
            [starImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                ESStrongSelf;
                make.left.mas_equalTo((starSize * i));
                make.top.equalTo(_self);
                make.size.mas_equalTo(CGSizeMake(starSize, starSize));
            }];
        }
    }
    return self;
}

-(void)setCurrentValue:(int)currentValue
{
    for (UIImageView *starImageView in _imgeViewArray) {
        int index = (int )starImageView.tag - 9;
        if (index > currentValue) {
            starImageView.image = [UIImage imageNamed:@"star-1.png"];
        } else {
            starImageView.image = [UIImage imageNamed:@"star2.png"];
        }
    }
}

@end
