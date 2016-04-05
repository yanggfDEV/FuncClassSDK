//
//  FZParseSrtString.h
//  EnglishTalk
//
//  Created by huyanming on 15/9/16.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FZParseSrtString : NSObject

+(void)getSrtString:(NSString*)srtUrl complectBlock:(void(^)(NSArray* array) )complectBlok;


@end
