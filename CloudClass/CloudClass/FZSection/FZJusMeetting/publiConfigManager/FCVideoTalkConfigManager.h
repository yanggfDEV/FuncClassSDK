//
//  FCVideoTalkConfigManager.h
//  Pods
//
//  Created by patty on 15/11/23.
//
//

#import <Foundation/Foundation.h>
//#import <MtcSessTimer.h>

@interface FCVideoTalkConfigManager : NSObject

//@property (nonatomic, strong) MtcSessTimer *sessTimer;

+ (FCVideoTalkConfigManager *)shareInstance;
- (NSUInteger)chatSeconds;


@end
