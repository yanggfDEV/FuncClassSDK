//
//  FZSignInStatus.h
//  Pods
//
//  Created by huyanming on 15/7/14.
//
//

#import <Foundation/Foundation.h>
#import "FZLoginUser.h"
#import "FZRefreshTokenService.h"
//#import "FCSignSever.h"

@interface FZSignInStatus : NSObject
+(BOOL)isAccessTokenValid;//目前没有确保，只会返回YES，不妨碍后续的步骤；

@end
