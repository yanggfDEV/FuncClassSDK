//
//  FZRefreshTokenService.h
//  Pods
//
//  Created by huyanming on 15/8/20.
//
//

//#import "FZBaseService.h"
#import "FZLoginUser.h"


extern NSString *const kPostLogoutNotification;
extern NSString *const kRefreshTokenExpiredNotification;

@interface FZRefreshTokenService : NSObject

-(void)changeAcessTokenWithRefreshToken:(NSString *)refreshToken successBlock:(void(^)(id responseObject))successBlock failBlock:(void (^)( id responseObject, NSError * error))failBlock;

@end
