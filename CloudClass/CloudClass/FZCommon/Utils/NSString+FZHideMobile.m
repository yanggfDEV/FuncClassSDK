//
//  NSString+FZHideMobile.m
//  KidDubbing
//
//  Created by Victor Ji on 15/11/27.
//  Copyright © 2015年 Feizhu Tech. All rights reserved.
//

#import "NSString+FZHideMobile.h"

@implementation NSString (FZHideMobile)

+ (NSString *)hideMobile:(NSString *)mobile {
    if (mobile.length != 11) {
        return mobile;
    } else {
        NSString *newString = [mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        return newString;
    }
}

@end
