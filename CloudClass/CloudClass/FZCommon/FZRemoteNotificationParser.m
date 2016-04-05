//
//  FZRemoteNotificationParser.m
//  EnglishTalk
//
//  Created by 周咏 on 15/9/25.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//  通知解析器
//

#import "FZRemoteNotificationParser.h"
#import "FZArrangeClassViewController.h"
#import "FZCommonWebViewController.h"
//#import "ChatViewController_Systerm.h"
//#import "FZDubbingPublicViewController.h"
//#import "MySpecialAlbumViewController.h"

@interface FZRemoteNotificationParser()
@end

@implementation FZRemoteNotificationParser

+(instancetype)sharedRemoteNotificationParser{
    static FZRemoteNotificationParser *instance;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^(){
        instance = [[FZRemoteNotificationParser alloc] init];
    });
    return instance;
}

-(void)handleRemoteNotification:(NSDictionary*)parameters{
    
    if(!parameters && ![parameters objectForKey:@"type"]){
        return;
    }
    
    NSString *type = [parameters objectForKey:@"type"];
    
    if([type isEqualToString:@"version"]) {//版本更新
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:@"有新版本,更新一下?"
                           cancelButtonItem:[RIButtonItem itemWithLabel:@"不更新" action:^{
        }]
                           otherButtonItems:[RIButtonItem itemWithLabel:@"更新" action:^{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPSTOREURL]];
        }], nil] show];
    }else if([type isEqualToString:@"tchpass"]) {//老师通过审核
        //发送通知 通知老师界面刷新数据
        [[NSNotificationCenter defaultCenter] postNotificationName:Notice_Tag_ApplyForTeacherSuccess object:nil];
    }
}

-(void)handleRemoteNotification:(NSDictionary *)parameters tabcontroller:(UITabBarController *)tabBarController{
    
    if(!parameters && ![parameters objectForKey:@"type"]){
        return;
    }
    
    NSDictionary *dataDictionary = [parameters objectForKey:@"data"];
    Class classTypeController;
    NSString *type = [parameters objectForKey:@"type"];
    
    if ([type isEqualToString:@"system"]) {//系统消息
    }else if([type isEqualToString:@"version"]) {//版本更新
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPSTOREURL]];
    }else if([type isEqualToString:@"course"]) {//课程推荐
//        classTypeController = [FZDubbingPublicViewController class];
    }else if([type isEqualToString:@"album"]){//专辑推荐
//        classTypeController = [MySpecialAlbumViewController class];
    }else if([type isEqualToString:@"openapp"]){//打开app
        
    }else if([type isEqualToString:@"tchpass"]) {//老师通过审核
        //发送通知 通知老师界面刷新数据
//        [[NSNotificationCenter defaultCenter] postNotificationName:Notice_Tag_ApplyForTeacherSuccess object:nil];
    }else if([type isEqualToString:@"activity"]) {//新活动提示
//        classTypeController = [FZActivityListViewController class];
    }else if([type isEqualToString:@"go_url"]){//跳转url
//        classTypeController = [FZCommonWebViewController class];
    }

    if(!classTypeController){
        return;
    }
    [self pushOrPresentViewController:NO paramteres:dataDictionary classType:classTypeController tabcontroller:tabBarController];
}

/**
 *  跳转到对应的controller
 *
 *  @param isPresent
 *  @param paramteres
 *  @param classType
 *  @param tabBarController
 */
-(void)pushOrPresentViewController:(BOOL)isPresent paramteres:(NSDictionary*)paramteres classType:(Class)classType tabcontroller:(UITabBarController *)tabBarController;
{
    UIViewController<FZUrlSchemesInitControllerDelegate> * controllerView=[[classType alloc] initControllerWithRemoteNotificationParameters:paramteres];
    
    if(!controllerView)
    {
        return;
    }
    
    UINavigationController *controllerNavigation = (UINavigationController *)[tabBarController selectedViewController];
    
    if (!isPresent) {
        if ([classType isSubclassOfClass:[FZArrangeClassViewController class]]) {
            controllerView.hidesBottomBarWhenPushed = NO;
        }
        controllerView.hidesBottomBarWhenPushed = YES;
        [controllerNavigation pushViewController:controllerView animated:YES];
    }
    else{
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controllerView];
        navigationController.viewControllers=@[controllerView];
        [controllerNavigation presentViewController:navigationController animated:NO completion:NULL];
        
    }
}

@end
