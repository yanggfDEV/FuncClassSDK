//
//  CommentViews.h
//  EnglishTalk
//
//  Created by apple on 14-12-9.
//  Copyright (c) 2014年 ishowtalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol aboveViews <NSObject>

- (void)insertview;
- (void)dismissface;

@end

@interface CommentViews : UIView<UITextFieldDelegate,aboveViews,UIScrollViewDelegate>

@property (nonatomic,retain) UIView * backview;
@property (nonatomic,strong)UITextField * textfield;
@property (nonatomic,strong)UIButton * voiceButton;
@property (nonatomic,strong)UIButton * faceButton;
@property (nonatomic,weak)id<aboveViews>delegate;
- (void)showkeyBoard;
- (void)dismisskeyBoard;

@end
