//
//  FCViewRelation.h
//  FunChatStudent
//
//  Created by FZDubbing on 15/10/15.
//  Copyright © 2015年 Feizhu Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FCChatRoomModel.h"
#import "FCChatListModel.h"
#import "FCTeachInfoModel.h"

@protocol FCVideoTalkLogicHandlerDelegate;
@interface FCVideoTalkLogicHandler : NSObject

@property (weak, nonatomic) id <FCVideoTalkLogicHandlerDelegate> delegate;
@property (nonatomic,strong) FCTeachInfoModel *teachInfoModel;

- (void)startVideoTalkWithChatListModel:(FCChatListModel *)chatListModel;
/**
 *  @author Victor Ji, 15-12-16 16:12:11
 *
 *  用于提示后点击“继续通话”，正常情况下请勿调用此方法
 */
- (void)shouldContinueCall;

@end

@protocol FCVideoTalkLogicHandlerDelegate <NSObject>

- (UINavigationController *)currentNavigationViewController;
- (UIViewController *)superViewController;
- (void)showHintWithText:(NSString *)text;
- (void)startLoadingView:(NSString*)text;
- (void)stopLoadingView;
- (void)startLoadingViewWithText:(NSString *)text;
- (void)showAlterViewWithTime:(int)alterTime;
- (void)resetChatButtonStatus;

@end
