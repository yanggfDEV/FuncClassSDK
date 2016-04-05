//
//  FZNavigationController.m
//  EnglishTalk
//
//  Created by CyonLeuPro on 15/5/25.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import "FZNavigationController.h"


@implementation FZNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setBarTintColor:[UIColor colorWithHexString:@"F7F7F7" withAlpha:0.97]];
}

+ (UIBarButtonItem *)createNavigationBarButton:(NSString *)title target:(id)target action:(SEL)action
{
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    return back;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
//    if([self.viewControllers count] > 0){
//        UIViewController *top = (UIViewController *)(self.viewControllers.lastObject);
//        if(top.navigationItem.backBarButtonItem == nil);
//        top.navigationItem.backBarButtonItem = [FZNavigationController createNavigationBarButton:@" " target:nil action:nil];
//    }
    // create navigation controller if needed.
    
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}


- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    UIViewController *controller = [super popViewControllerAnimated:animated];
    // TODO
    return controller;
}

//- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item{
//    if([self.viewControllers count]){
//        UIViewController *top = self.viewControllers.lastObject;
//        //hidden feature
//#pragma clang diagnostic push
//#pragma GCC diagnostic ignored "-Wundeclared-selector"
//        if([top respondsToSelector:@selector(willGoBack)]){
//            if([top performSelector:@selector(willGoBack)])
//#pragma clang diagnostic pop
//                return [super navigationBar:navigationBar shouldPopItem:item];
//            else
//                return NO;
//        }-//    }
//    return [super navigationBar:navigationBar shouldPopItem:item];
//}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    if ([self.visibleViewController respondsToSelector:@selector(preferredInterfaceOrientationForPresentation)]) {
        return [self.visibleViewController preferredInterfaceOrientationForPresentation];
    }
    return  UIInterfaceOrientationPortrait;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([self.visibleViewController respondsToSelector:@selector(supportedInterfaceOrientations)]) {
        return [self.visibleViewController supportedInterfaceOrientations];
    }
    return UIInterfaceOrientationMaskPortrait;//self.visibleViewController.supportedInterfaceOrientations;
}

- (BOOL)shouldAutorotate {
    if ([self.visibleViewController respondsToSelector:@selector(shouldAutorotate)]) {
        return [self.visibleViewController shouldAutorotate];
    }
    return NO;
}

@end

//对返回按钮做特殊处理,如果实现了单独的doBack方法，需要判断返回逻辑的部分，直接调用代理方法，否则默认返回上一页
@implementation FZNavigationController (ShouldPopOnBackButton)

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    UIViewController* vc = [self topViewController];
    
    //对于contact supplier成功页面做特殊处理
    if(([self.viewControllers count] < [navigationBar.items count])) {
        return YES;
    }
    
    //所有基类的处理方法,会调用doBack方法，如果有doBack方法
    if([vc isKindOfClass:[FZCommonViewController class]] &&  [vc respondsToSelector:@selector(doBack)]) {
        FZCommonViewController * viewControl=(FZCommonViewController *)vc;
        [viewControl doBack];
        return NO;
    }
    
    return YES;
}

@end