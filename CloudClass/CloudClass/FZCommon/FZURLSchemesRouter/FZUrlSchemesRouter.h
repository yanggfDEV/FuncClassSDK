//
//  FZUrlSchemesRouter.h
//  EnglishTalk
//
//  Created by huyanming on 15/6/9.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol FZUrlSchemesInitControllerDelegate <NSObject>

@required
-(id)initControllerWithParameters:(NSDictionary*)parameters;

@end


@interface FZUrlSchemesRouter : NSObject
{
    Class classTypeController;
    NSURL * urlString;
    UINavigationController *controllerNavigation;
    NSDictionary* paramterDic;

}
+ (FZUrlSchemesRouter *)sharedUrlSchemesRouterManager;
-(BOOL)handleUrlSchemaMap:(NSURL*)url  tabcontroller:(UITabBarController*)tabBarController;
-(void)handleUrlSchemaMapNoTabView:(NSURL*)url navigation:(UINavigationController*)navigation;

@end
