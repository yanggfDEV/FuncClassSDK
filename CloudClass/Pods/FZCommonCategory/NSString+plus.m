//
//  NSString+plus.m
//  EnglishTalk
//
//  Created by DING FENG on 6/7/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import "NSString+plus.h"

@implementation NSString (plus)


- (BOOL)isKindOfURL {
    NSURL *candidateURL = [NSURL URLWithString:self];
    if (candidateURL && candidateURL.scheme && candidateURL.host) {
        return YES;
    }
    return NO;
}


@end
