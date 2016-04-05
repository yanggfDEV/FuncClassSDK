//
//  FZRemoteNotificationParser.h
//  EnglishTalk
//
//  Created by 周咏 on 15/9/25.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//  通知解析器
//

#import <Foundation/Foundation.h>

@protocol FZRemoteNotificationParserDelegate <NSObject>

@required
-(instancetype)initControllerWithRemoteNotificationParameters:(NSDictionary*)parameters;

@end

@interface FZRemoteNotificationParser : NSObject

+ (instancetype)sharedRemoteNotificationParser;

-(void)handleRemoteNotification:(NSDictionary*)parameters  tabcontroller:(UITabBarController*)tabBarController;

-(void)handleRemoteNotification:(NSDictionary*)parameters;

@end
