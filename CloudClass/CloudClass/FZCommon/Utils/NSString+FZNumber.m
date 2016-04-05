//
//  NSString+FZNumber.m
//  EnglishTalk
//
//  Created by 周咏 on 15/10/15.
//  Copyright © 2015年 Feizhu Tech. All rights reserved.
//

#import "NSString+FZNumber.h"

@implementation NSString (FZNumber)

//判断是否为整形
- (BOOL)isPureInt{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：
- (BOOL)isPureFloat{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

@end
