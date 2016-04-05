//
//  CommonWebViewController.h
//  EnglishTalk
//
//  Created by apple on 15/5/20.
//  Copyright (c) 2015年 ishowtalk. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FZCommonViewController.h"

@interface FZCommonWebViewController : FZCommonViewController<UIWebViewDelegate>

@property (nonatomic,strong) NSString *urlString;
@property (nonatomic,strong) NSString *titleStr;

@end
