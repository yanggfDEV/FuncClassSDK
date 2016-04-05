//
//  FZSignInStatus.m
//  Pods
//
//  Created by huyanming on 15/7/14.
//
//

#import "FZSignInStatus.h"
#import "NSDate+DateToDisplayString.h"

@implementation FZSignInStatus
+(BOOL)isAccessTokenValid
{
    
    BOOL isTimeOut = NO;
    
    //如果没有登陆,直接退出,不做置换
//    if (![[FZLoginManager sharedManager] hasLogin]) {
//        return YES;
//    }
    
    //否则判断有没有过期，做替换
    //token为空，视为未登陆，退出
    if (![FZLoginUser authToken]) {
        return NO;
    }
    
    if (![FZLoginUser authTokenExpire]) {
        isTimeOut = YES;
    }
    else {
        NSTimeInterval lastUpdateTime = [[FZLoginUser authTokenExpire] doubleValue];
        NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
        NSTimeInterval timeDistance = lastUpdateTime - nowTime;
        
//        NSString *lastDateString = [NSDate dateDetailStringForTimeIntervalSince1970:lastUpdateTime];
//        NSString *nowDateString = [NSDate dateDetailStringForTimeIntervalSince1970:nowTime];
//        NSLog(@"lastDate:%@---now:%@---dis:%f", lastDateString, nowDateString, timeDistance);
        //todo by liuyong 上线应该过期前一个小时趣刷新3600
        if (timeDistance <= 60) {
            //小于一个小时都会去刷新token
            isTimeOut = YES;
        }
        else {
            isTimeOut = NO;
        }
    }
    //过期，刷新token
    if (isTimeOut) {
        FZRefreshTokenService * RefreshInService=[[FZRefreshTokenService alloc] init];
        [RefreshInService changeAcessTokenWithRefreshToken:[FZLoginUser refreshToken] successBlock:^(id responseObject) {
        } failBlock:^(id responseObject, NSError *error) {
        }];
    }
    return !isTimeOut;
}

@end
