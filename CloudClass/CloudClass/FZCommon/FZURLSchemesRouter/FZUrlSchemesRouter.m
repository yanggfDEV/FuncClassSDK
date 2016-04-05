//
//  FZUrlSchemesRouter.m
//  EnglishTalk
//
//  Created by huyanming on 15/6/9.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import "FZUrlSchemesRouter.h"
#import "FZArrangeClassViewController.h"
//#import "FZHomePageViewController.h"
//#import "FZDubbingPublicViewController.h"
//#import "FZDubbingCommentViewController.h"




static FZUrlSchemesRouter *_manager = nil;


@implementation FZUrlSchemesRouter

+ (FZUrlSchemesRouter *)sharedUrlSchemesRouterManager
{
    @synchronized(self)
    {
        if (!_manager)
        {
            _manager = [[FZUrlSchemesRouter alloc] init];
        }
    }
    return _manager;
};

-(void)handleUrlSchemaMapNoTabView:(NSURL*)url navigation:(UINavigationController*)navigation
{
}


-(BOOL)handleUrlSchemaMap:(NSURL*)url  tabcontroller:(UITabBarController*)tabBarController
{

    controllerNavigation = (UINavigationController *)[tabBarController selectedViewController];
    urlString = url;
    NSString* pageUrl = [urlString host];
    //根据host返回具体的controller名称
    Class classType= [self getViewControllerFromprotocol:pageUrl];
    if (classType == nil) {
        return NO;
    }
    classTypeController = classType;
    NSString *myString = [urlString query];
    paramterDic = [self parseParmters:myString];
    [self pushOrPresentViewController:NO];
    return YES;
}


-(void)pushOrPresentViewController:(BOOL)isPresent
{
    UIViewController<FZUrlSchemesInitControllerDelegate> * controllerView=[[classTypeController alloc] initControllerWithParameters:paramterDic];

    if(!controllerView)
    {
        return;
    }
    
    if (!isPresent) {
        if ([classTypeController isSubclassOfClass:[FZArrangeClassViewController class]]) {
            controllerView.hidesBottomBarWhenPushed = NO;
        }
        [controllerNavigation pushViewController:controllerView animated:YES];
    }
    else{
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controllerView];
        navigationController.viewControllers=@[controllerView];
        [controllerNavigation presentViewController:navigationController animated:NO completion:NULL];
        
    }
}


-(NSDictionary*)parseParmters:(NSString*)parmStr
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [parmStr componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSMutableString * val=[NSMutableString stringWithCapacity:2];
        for (int i=1; i<[elements count]; i++) {
            [val appendString:[elements objectAtIndex:i]];
            if (i!=[elements count]-1) {
                [val appendString:@"="];
                
            }
        }
        [dict setObject:val forKey:key];
    }
    return dict;
};


-(Class)getViewControllerFromprotocol:(NSString*)protocolHost
{
    if ([protocolHost isEqualToString:@"play_course"]) {
//        return [FZDubbingPublicViewController class];
    }
    else if([protocolHost isEqualToString:@"play_album_course"]) {
//        return [FZDubbingPublicViewController class];
//    } else if([protocolHost isEqualToString:@"goto_sapce"]) {
//        return [OtherPeopleViewController class];
    }
    else if([protocolHost isEqualToString:@"play_dubbing_art"]){
//        return [FZDubbingCommentViewController class];
    }
    else {
        return nil;

    }
    return nil;
}



@end
