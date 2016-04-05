//
//  FCTextChatTableViewCell.m
//  FunChatStudent
//
//  Created by 李灿 on 15/10/10.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import "FCTextChatTableViewCell.h"
#import <UIColor+Hex.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "FCChatMessageModel.h"
//#import <FZJusTalkConfig.h>
//#import "FZVideoTalkSDKLocalization.h"

@implementation FCTextChatTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self addAllCells];
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)addAllCells
{
    //self.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    self.longPressGesture = [[UILongPressGestureRecognizer alloc] init];
    [self addGestureRecognizer:_longPressGesture];
}

- (void)setMessageModel:(FCChatMessageModel *)messageModel
{
    if (messageModel.messageType == kChatMessageTypeOfText) {
        UIView *textView = [self bubbleView:messageModel.content from:messageModel.isMy isFailed:messageModel.isFailed messageType:messageModel.messageStutus withPosition:65 messageModel:messageModel];
        [self addSubview:textView];
    } else if (messageModel.messageType == kChatMessageTypeOfPic) {
        UIImageView *imageView = [self imageView:140 height:150 imageUrl:[messageModel thumbnailPicPath] from:messageModel.isMy isFailed:messageModel.isFailed messageType:messageModel.messageStutus withPosition:65];
        [self addSubview:imageView];
    } else if (messageModel.messageType == kChatMessageTypeOfVideo) {
        UIView *video = [self videoView:messageModel.content from:messageModel.isMy withPosition:65];
        [self addSubview:video];
    }
    _messageModel = messageModel;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    [super setHighlighted:highlighted animated:animated];
    
}
#pragma mark - 创建不同类型的聊天界面
//泡泡文本
- (UIView *)bubbleView:(NSString *)text from:(BOOL)fromSelf isFailed:(int)isFailed messageType:(kChatMessageStatus)messageType withPosition:(int)position messageModel:(FCChatMessageModel *)messageModel{
    
    //计算大小
    UIFont *font = [UIFont systemFontOfSize:14];
    CGRect rect = [self getRectwithString:text withFont:14 withWidth:[UIScreen mainScreen].bounds.size.width - 150];
     // build single chat bubble cell with given text
    self.cellView = [[UIView alloc] initWithFrame:CGRectZero];
    _cellView.backgroundColor = [UIColor clearColor];
    
    BOOL targert = YES;
    if ([messageModel.targetIDPrefix isEqualToString:@"老师"]) {
        targert = YES;
    } else {
        targert = NO;
    }
    //背影图片
   UIImage *bubble = [UIImage imageNamed:fromSelf?@"img_me_right":targert?@"img_teacher_left":@"img_student_left"];
    
    UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width/2) topCapHeight:floorf(30)]];
    self.bubbleImageView = bubbleImageView;
    
    //添加文本信息
    UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(fromSelf?12.5f:17.5f, fromSelf?10.0f:(10 + 10.0f), rect.size.width, rect.size.height+3.3)];
    bubbleText.backgroundColor = [UIColor clearColor];
    [bubbleText setTextColor:[UIColor colorWithHexString:@"333333"]];
    bubbleText.font = font;
    bubbleText.numberOfLines = 0;
    bubbleText.lineBreakMode = NSLineBreakByWordWrapping;
    bubbleText.text = text;
    
    bubbleImageView.frame = CGRectMake(0.0f, fromSelf?0.0f:(10 + 0.0f), bubbleText.frame.size.width+30.0f, bubbleText.frame.size.height+20.0f);
    
    if(fromSelf) {
        _cellView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-position-(bubbleText.frame.size.width+30.0f), 0.0f, bubbleText.frame.size.width+10.0f, bubbleText.frame.size.height + 10);
    } else {
        _cellView.frame = CGRectMake(position, fromSelf?0.0f:(10 + 0.0f), bubbleText.frame.size.width+10.0f, bubbleText.frame.size.height + 10);
    }
    UIButton *sendFailedButton = [[UIButton alloc] initWithFrame:CGRectMake(- 32.5 + _cellView.frame.origin.x, fromSelf?0.0f:(10 + 0.0f) + (_cellView.frame.size.height + _cellView.frame.origin.y - 21.5), 22.5, 22.5)];

    if (isFailed) {
        [sendFailedButton setBackgroundImage:[UIImage imageNamed:@"msg_error.png"] forState:UIControlStateNormal];
        [sendFailedButton addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
   
    [self addSubview:sendFailedButton];
    [_cellView addSubview:bubbleImageView];
    [_cellView addSubview:bubbleText];
    if (messageType == kChatMessageCreate) {
        [self startLoadingViewWithText:@"" sendButton:sendFailedButton];
    } else {
        [self stopLoadingView];
    }
    return _cellView;
}

// 显示通话时长
- (UIView *)videoView:(NSString *)logntime from:(BOOL)fromSelf withPosition:(int)position{
    UIImageView *image;
    CGRect rect = [self getRectwithString:[NSString stringWithFormat:@"%@", logntime] withFont:14 withWidth:[UIScreen mainScreen].bounds.size.width - 162];
    UIImage *backgroundImage = [UIImage imageNamed:fromSelf?@"text_box_blue_bg":@"text_boxleft_blue_bg"];
    if ([logntime isEqualToString:@"Call Missed"]) {
        backgroundImage = [UIImage imageNamed:@"text_box_white_bg"];
    }
    backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:floorf(30) topCapHeight:floorf(28)];

    // 根据显示视频文字长度
     self.videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if(fromSelf) {
        _videoButton.frame =CGRectMake([UIScreen mainScreen].bounds.size.width - rect.size.width  - position - 15, 0, rect.size.width, rect.size.height + 20);
        image = [[UIImageView alloc]initWithFrame:CGRectMake(-40, 0, rect.size.width + 54, rect.size.height + 20)];

    } else {
        _videoButton.frame =CGRectMake(position, 0, rect.size.width, rect.size.height + 20);
        image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width + 55, rect.size.height + 20)];
    }
    
    image.image = backgroundImage;
    
    self.bubbleImageView = image;
    //image偏移量
    UIEdgeInsets imageInsert;
    imageInsert.top = 0;
    imageInsert.left = fromSelf?_videoButton.frame.size.width/3:-_videoButton.frame.size.width/3;
    _videoButton.imageEdgeInsets = imageInsert;
//    [_videoButton setTitle:logntime forState:UIControlStateNormal];
    [_videoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _videoButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    _videoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    UILabel *videoLabel = [[UILabel alloc] initWithFrame:CGRectMake(fromSelf?0:44, 0, _videoButton.frame.size.width, _videoButton.frame.size.height)];
    videoLabel.text = logntime;
    videoLabel.font = [UIFont systemFontOfSize:14.0f];
    [videoLabel setTextColor:[UIColor whiteColor]];
   
    [videoLabel setTextAlignment:NSTextAlignmentCenter];
    videoLabel.numberOfLines = 0;
    
    UIImageView *imageVideo = [[UIImageView alloc]initWithFrame:CGRectMake(fromSelf?-30:15, (_videoButton.frame.size.height - 15.5) / 2, 24, 15.5)];
    imageVideo.image = [UIImage imageNamed:fromSelf?@"msg_title_video":@"call_duration"];
    if ([logntime isEqualToString:@"Call Missed"]) {
        [videoLabel setTextColor:[UIColor redColor]];
        imageVideo.image = [UIImage imageNamed:@"call_missed"];
    }
    [_videoButton addTarget:self action:@selector(oneChatMessageTapGesture:) forControlEvents:UIControlEventTouchUpInside];
    [_videoButton addSubview:image];
    [_videoButton addSubview:videoLabel];
    [_videoButton addSubview:imageVideo];
    return _videoButton;
}

- (UIImageView *)imageView:(CGFloat)width height:(CGFloat)height imageUrl:(NSString *)url from:(BOOL)fromSelf isFailed:(int)isFailed messageType:(kChatMessageStatus)messageType withPosition:(int)position{
    UIImage *cellImage = [UIImage imageWithContentsOfFile:url];

    width = cellImage.size.width/([UIScreen mainScreen].scale);
    height = cellImage.size.height/([UIScreen mainScreen].scale);

    if(fromSelf) {
        self.cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - position - width - 10, 3, width, height)];
    } else {
        self.cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(position + 10, 3, width, height)];
    }
    
    self.cellImageView.image = cellImage;
    UIButton *sendFailedButton = [[UIButton alloc] initWithFrame:CGRectMake(- 32.5 + _cellImageView.frame.origin.x, (self.cellImageView.frame.size.height + self.cellImageView.frame.origin.y - 31.5), 22.5, 22.5)];
    sendFailedButton.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    if (isFailed) {
        [sendFailedButton setBackgroundImage:[UIImage imageNamed:@"msg_error.png"] forState:UIControlStateNormal];
        [sendFailedButton addTarget:self action:@selector(sendButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    sendFailedButton.backgroundColor = [UIColor clearColor];
    //背影图片
    UIImage *image = [UIImage imageNamed:fromSelf?@"group_chatbox_right_my":@"group_chatbox_left"];
    UIImageView *imageImageView = [[UIImageView alloc] initWithImage:[image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(30)]];
    imageImageView.frame = CGRectMake(fromSelf?(-3.0f + _cellImageView.frame.origin.x) : (_cellImageView.frame.origin.x - 9.0), self.cellImageView.frame.origin.y - 3, _cellImageView.frame.size.width + 11, _cellImageView.frame.size.height+6);

    self.bubbleImageView = imageImageView;

    [self addSubview:imageImageView];
    [self addSubview:sendFailedButton];
    self.cellImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneChatMessageTapGesture:)];
    [self.cellImageView addGestureRecognizer:tapGesture];
   
    if (messageType == kChatMessageCreate) {
        [self startLoadingViewWithText:@"" sendButton:sendFailedButton];
    } else {
        [self stopLoadingView];
    }
    return self.cellImageView;
}

// 点击图片事件
- (void)oneChatMessageTapGesture:(UITapGestureRecognizer *)sender
{
    if (self.tapChatBlock) {
        self.tapChatBlock();
    }
}

- (void)sendButtonAction:(UIButton *)sender
{
    if (self.tapSendImage) {
        self.tapSendImage();
    }
}
// 为了响应长按事件
- (BOOL)canBecomeFirstResponder{
    return YES;
}

/**
 * @guangfu yang 15-12-29
 *
 *
 **/

- (CGRect)getRectwithString:(NSString *)string withFont:(CGFloat)font withWidth:(CGFloat)width
{
    CGRect rect=[string boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    
    return rect;
}

#pragma mark 发送状态
- (void)stopLoadingView{
//    [self.activityView stopAnimating];
//    [self.activityView removeFromSuperview];
//    self.activityView = nil;
}

- (void)startLoadingViewWithText:(NSString *)text sendButton:(UIButton *)sendButton
{
//    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithFrame:sendButton.frame];
//    activityView.activityIndicatorViewStyle = self.isVideoPush ? UIActivityIndicatorViewStyleWhite: UIActivityIndicatorViewStyleGray;
//    activityView.backgroundColor = [UIColor clearColor];
//    [self addSubview:activityView];
//    self.activityView = activityView;
//    [self.activityView startAnimating];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
