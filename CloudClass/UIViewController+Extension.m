//
//  UIViewController+FCMRViewController.m
//  FunChatStudent
//
//  Created by Asuna on 15/11/2.
//  Copyright © 2015年 Feizhu Tech. All rights reserved.
//

#import <objc/runtime.h>


@implementation NSObject(Extension)
/**
 *  交换两个类方法
 *
 *  @param class          类名称
 *  @param originSelector 原始方法名称
 *  @param otherSelector  交换的方法名称
 */
+ (void)swizzleClassMethod:(Class)class originSelector:(SEL)originSelector otherSelector:(SEL)otherSelector
{
    Method otherMehtod = class_getClassMethod(class, otherSelector);
    Method originMehtod = class_getClassMethod(class, originSelector);
    // 交换2个方法的实现
    
    if (class_addMethod(class, originSelector, method_getImplementation(otherMehtod), method_getTypeEncoding(otherMehtod))) {
        class_replaceMethod(class, otherSelector, method_getImplementation(originMehtod), method_getTypeEncoding(originMehtod));
    } else {
        method_exchangeImplementations(otherMehtod, originMehtod);
    }
}
/**
 *  交换两个对象方法
 *
 *  @param class          类名称
 *  @param originSelector 原始方法名称
 *  @param otherSelector  交换的方法名称
 */
+ (void)swizzleInstanceMethod:(Class)class originSelector:(SEL)originSelector otherSelector:(SEL)otherSelector
{
    Method otherMehtod = class_getInstanceMethod(class, otherSelector);
    Method originMehtod = class_getInstanceMethod(class, originSelector);
    // 交换2个方法的实现
    if (class_addMethod(class, originSelector, method_getImplementation(otherMehtod), method_getTypeEncoding(originMehtod))) {
        class_replaceMethod(class, otherSelector, method_getImplementation(originMehtod), method_getTypeEncoding(originMehtod));
    } else {
        method_exchangeImplementations(otherMehtod, originMehtod);
    }
}
@end
                
@implementation UIViewController (Extension)

+ (void)load
{
   [self swizzleInstanceMethod:self originSelector:@selector(viewWillAppear:) otherSelector:@selector(mr_viewWillAppear:)];
}
/**
 *  用来替换viewDidAppear,方便追踪
 *
 *  @param animated 是否有动画
 */
-(void)mr_viewWillAppear:(BOOL)animated;
{
    [self mr_viewWillAppear:YES];
    NSLog(@"我是好人 %@",self);
}
@end

@implementation NSArray(Extension)
+ (void)load
{
    [self swizzleInstanceMethod:self originSelector:@selector(objectAtIndex:) otherSelector:@selector(mr_objectAtIndex:)];
}
/**
 *  用来替换取出数组的元素的方法
 *
 *  @param index 数组下标
 *
 *  @return 返回取出的值,如果越界返回nil
 */
- (id)mr_objectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        return [self mr_objectAtIndex:index];
    } else {
        return nil;
    }
}


@end

