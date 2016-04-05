//
//  FZRefreshTokenService.m
//  Pods
//
//  Created by huyanming on 15/8/20.
//
//

#import "FZRefreshTokenService.h"
#import "FZAPIGenerate.h"
#import "FZNetWorkManager.h"

/**
 *  过期登录，发送通知
 */
NSString *const kPostLogoutNotification = @"kPostLogoutNotification";
NSString *const kRefreshTokenExpiredNotification = @"kRefreshTokenExpiredNotification";


@implementation FZRefreshTokenService
-(void)changeAcessTokenWithRefreshToken:(NSString *)refreshToken successBlock:(void(^)(id responseObject))successBlock failBlock:(void (^)( id responseObject, NSError * error))failBlock
{
    if (!refreshToken) {
        return ;
    }
    NSMutableDictionary * dic=[NSMutableDictionary dictionaryWithCapacity:2];
    [dic setValue:refreshToken forKey:@"refresh_token"];
    [dic setValue:[FZLoginUser userID] forKey:@"uid"];
    
    NSString *urlString = [[FZAPIGenerate sharedInstance] API:@"user_auth_login"];
    FZNetWorkManager *manager = [FZNetWorkManager sharedInstance];
    [manager GETWithNoDefaultParam:urlString parameters:dic responseDtoClassType:nil success:^(id responseObject) {
        NSDictionary* dicParam = responseObject;
        NSNumber* codeStautsNumber = [dicParam objectForKey:@"status"];
        NSInteger stautscode = [codeStautsNumber integerValue];
        NSDictionary* dataDic = [dicParam objectForKey:@"data"];
        if ((stautscode == 1)&&dataDic) {
            NSString* token = [dataDic objectForKey:@"auth_token"];
            NSString* exprietimeStr = [dataDic objectForKey:@"endtime"];
            NSString* refreshtoken = [dataDic objectForKey:@"refresh_token"];
            [FZLoginUser setAuthToken:token];
            [FZLoginUser setRefreshToken:refreshtoken];
            [FZLoginUser setAuthTokenExpire:exprietimeStr];
            successBlock(nil);
        }
        if (stautscode == 0) {
            NSString *message = dicParam[@"msg"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshTokenExpiredNotification object:message userInfo:nil];
        }
        
    } failure:^(id responseObject, NSError *error) {

        failBlock(nil,nil);
    }];
    
}

@end
