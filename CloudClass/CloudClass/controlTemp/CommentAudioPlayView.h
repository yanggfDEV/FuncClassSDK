//
//  CommentAudioPlayView.h
//  EnglishTalk
//
//  Created by DING FENG on 12/16/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PlayDidFinishBlock)();
typedef void(^PlayDidStartBlock)();


@interface CommentAudioPlayView : UIView


@property  (nonatomic,strong)  NSString  *audioUrl;
@property  (nonatomic,strong)  NSString  *backImgName;
@property  (nonatomic,strong)  NSString  *wifi_static_string;
@property  (nonatomic,strong)  NSString  *wifi_gif_string;
@property  (nonatomic,strong)  NSString  *color_string;




@property  (nonatomic,strong)  UIImageView  *wifi_static;
@property  (nonatomic,strong)  UIImageView  *wifi_gif;

@property  (nonatomic,strong)  UILabel  *secendsLabel;

//

@property  (nonatomic,strong)  NSString  *audioLength;



@property  (nonatomic,strong)  PlayDidFinishBlock  playDidFinishBlock;
@property  (nonatomic,strong)  PlayDidStartBlock  playDidStartBlock;
@property (nonatomic)NSInteger widths;
@property (nonatomic) float  bubbleWidth;

@property (nonatomic,strong) UIImageView  *backImgView;




-(void)addUnreadSign;
-(void)removeUnreadSign;

- (id)initWithPointX:(NSInteger)pointX pointY:(NSInteger)pointY width:(NSInteger)width;



@end
