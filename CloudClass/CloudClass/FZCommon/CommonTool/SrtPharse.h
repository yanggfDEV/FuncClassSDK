//
//  SrtPharse.h
//  SimpleAVPlayer
//
//  Created by DING FENG on 5/26/14.
//  Copyright (c) 2014 dinfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SrtPharse : NSObject

+(NSArray *)pharseSrtFilePath:(NSString *)pathString;
+(NSArray *)pharseSrtString:(NSString *)srtString;

@end
