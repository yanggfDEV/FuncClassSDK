//
//  SegmentButtons.m
//  EnglishTalk
//
//  Created by DING FENG on 11/10/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import "SegmentButtons.h"

@interface SegmentButtons()
{
    UIView *targetBar;
}

@end

@implementation SegmentButtons

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        float  width = frame.size.width;
        float  height = frame.size.height;
        self.backgroundColor =[UIColor  whiteColor];
        _btn1  = [[UIButton  alloc]  initWithFrame:CGRectMake(0, 0, width/3., height)];
        _btn2  = [[UIButton  alloc]  initWithFrame:CGRectMake(1*width/3., 0, width/3., height)];
        _btn3  = [[UIButton  alloc]  initWithFrame:CGRectMake(2*width/3., 0, width/3., height)];
        [_btn1  setTitleColor:[UIColor colorWithRed:142./255 green:196./255 blue:56./255 alpha:1] forState:UIControlStateSelected];
        [_btn1  setTitleColor:[UIColor  grayColor] forState:UIControlStateNormal];
        [_btn2  setTitleColor:[UIColor colorWithRed:142./255 green:196./255 blue:56./255 alpha:1] forState:UIControlStateSelected];
        [_btn2  setTitleColor:[UIColor  grayColor] forState:UIControlStateNormal];
        [_btn3  setTitleColor:[UIColor colorWithRed:142./255 green:196./255 blue:56./255 alpha:1] forState:UIControlStateSelected];
        [_btn3  setTitleColor:[UIColor  grayColor] forState:UIControlStateNormal];
        [self addSubview:_btn1];
        [self addSubview:_btn2];
        [self addSubview:_btn3];
        
        targetBar = [[UIView  alloc]  initWithFrame:CGRectMake(0, self.frame.size.height-2, width/4., 1)];
        targetBar.backgroundColor = [UIColor colorWithRed:142./255 green:196./255 blue:56./255 alpha:1];
        [_btn1  addTarget:self action:@selector(_btnTap:) forControlEvents:UIControlEventTouchUpInside];
        [_btn2  addTarget:self action:@selector(_btnTap:) forControlEvents:UIControlEventTouchUpInside];
        [_btn3  addTarget:self action:@selector(_btnTap:) forControlEvents:UIControlEventTouchUpInside];
        _btn1.tag = 1;
        _btn2.tag = 2;
        _btn3.tag = 3;
        [self  addSubview:targetBar];
        
        [_btn1  setTitle:@"" forState:UIControlStateNormal];
        [_btn2  setTitle:@"" forState:UIControlStateNormal];
        [_btn3  setTitle:@"" forState:UIControlStateNormal];
        [_btn1.titleLabel  setFont:[UIFont  boldSystemFontOfSize:12]];
        [_btn2.titleLabel  setFont:[UIFont  boldSystemFontOfSize:12]];
        [_btn3.titleLabel  setFont:[UIFont  boldSystemFontOfSize:12]];

        
        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 1, frame.size.width, 1)];
        bottomLineView.backgroundColor = [UIColor colorWithRed:231./255 green:231./255 blue:231./255 alpha:1];
        [self addSubview:bottomLineView];
        
        [self  _btnTap:_btn1];
    }
    
    return self;
}


-(void)_btnTap:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 1:
        {
            _btn1.selected = YES;
            _btn2.selected = NO;
            _btn3.selected = NO;
            
            targetBar.center = CGPointMake(_btn1.center.x, targetBar .center.y);
            
            if (self.btn1Block)
            {
                self.btn1Block();
            }
            break;
        }
        case 2:
        {
            _btn1.selected = NO;
            _btn2.selected = YES;
            _btn3.selected = NO;
            targetBar.center = CGPointMake(_btn2.center.x,targetBar .center.y);
            
            if (self.btn2Block)
            {
                self.btn2Block();
            }
            break;
        }
        case 3:
        {
            _btn1.selected = NO;
            _btn2.selected = NO;
            _btn3.selected = YES;
            
            targetBar.center = CGPointMake(_btn3.center.x,targetBar .center.y);
            
            if (self.btn3Block)
            {
                self.btn3Block();
            }
            break;
        }
        default:
            break;
    }
}

@end
