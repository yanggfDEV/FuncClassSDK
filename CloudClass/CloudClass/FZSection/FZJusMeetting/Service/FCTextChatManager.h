//
//  FCTextChatManager.h
//  Pods
//
//  Created by 刘滔 on 15/10/8.
//
//

#import <UIKit/UIKit.h>
#import "FCUserTalkTransferModel.h"
#import "FCChatMessageModel.h"

@interface FCTextChatManager : NSObject

// 保存视频通话信息
- (void)saveVideoTalkMessageWithTime:(NSInteger)timeSec isMy:(BOOL)isMy extraModel:(FCUserTextExtraModel *)extraModel;

// 发送文字
- (void)sendText:(NSString *)text extraModel:(FCUserTextExtraModel *)extraModel;

// 发送图片
- (void)sendPicture:(UIImage *)image extraModel:(FCUserTextExtraModel *)extraModel;

@end
