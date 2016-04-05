//
//  ProgressView.m
//  EnglishTalk
//
//  Created by DING FENG on 11/5/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import "ProgressView.h"
@implementation ProgressView
@synthesize plabel=_plabel;
- (id)init
{
    self = [super init];
    if (self)
    {
        self  = [[ProgressView   alloc]  initWithFrame:CGRectMake(0, 0, 200, 100)];
        self.backgroundColor =[UIColor colorWithRed:240./255 green:240./255 blue:240./255 alpha:1];
        self.layer.cornerRadius = 5;  // 将图层的边框设置为圆脚
        self.layer.masksToBounds = YES;
        _plabel = [[UILabel  alloc]  initWithFrame:CGRectMake(0, 0, 100, 30)];
        _plabel.center=CGPointMake(100, 50+10);
        _plabel.text=@"正在上传...";
        _plabel.textAlignment = NSTextAlignmentCenter;
        _plabel.font =[UIFont  boldSystemFontOfSize:12];
        [self  addSubview:_plabel];
       UIActivityIndicatorView * activityIndicatorView = [ [ UIActivityIndicatorView alloc ] initWithFrame:CGRectMake(250.0,20.0,30.0,30.0)];
        activityIndicatorView.center = CGPointMake(100, 50-15);
        activityIndicatorView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleGray;
        activityIndicatorView.hidesWhenStopped = YES;
        [self addSubview:activityIndicatorView ];
        [ activityIndicatorView startAnimating ];
    }
    return self;
}

@end
