//
//  FCTextChatTableViewCell.h
//  FunChatStudent
//
//  Created by 李灿 on 15/10/10.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@class FCChatMessageModel;
@interface FCTextChatTableViewCell : UITableViewCell <MBProgressHUDDelegate>
@property (nonatomic, strong) UIButton *videoButton;
@property (nonatomic, strong) UIView *cellView;
@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, assign) BOOL isHub;                           // 判断是否显示加载
@property (nonatomic, strong) FCChatMessageModel *messageModel;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;
@property (copy, nonatomic) void(^tapChatBlock)(void);
@property (strong, nonatomic) UIImageView *bubbleImageView;
@property (copy, nonatomic) void(^tapSendImage)(void);
@property (assign, nonatomic) BOOL isVideoPush;


@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf isFailed:(int)isFailed withPosition:(int)position;

- (UIView *)videoView:(NSString *)logntime from:(BOOL)fromSelf withPosition:(int)position;

- (UIImageView *)imageView:(CGFloat)width height:(CGFloat)height imageUrl:(NSString *)url from:(BOOL)fromSelf isFailed:(int)isFailed withPosition:(int)position;
@end
