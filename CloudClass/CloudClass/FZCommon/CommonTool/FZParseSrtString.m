//
//  FZParseSrtString.m
//  EnglishTalk
//
//  Created by huyanming on 15/9/16.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import "FZParseSrtString.h"
#import <AFHTTPSessionManager.h>
#import "SrtPharse.h"
#import "NSString+plus.h"

@implementation FZParseSrtString


+(void)getSrtString:(NSString*)srtUrl complectBlock:(void(^)(NSArray* array) )complectBlok
{
    
    if (![srtUrl isKindOfClass:[NSString  class]])
    {
        if (complectBlok) {
            complectBlok(nil);
        }
        return;
    }
    if ([srtUrl isKindOfURL])
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/plain"]];
        
        NSString  *srtString = [NSString  stringWithFormat:@"%@",srtUrl];
        
        if (![(NSString *)srtString  isKindOfURL]) {
            if (complectBlok) {
                complectBlok(nil);
            }
            return ;
        }
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:srtString parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSString *srtString =[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            if (srtString==nil)
            {
                srtString =[[NSString alloc]initWithData:responseObject encoding:NSUnicodeStringEncoding];
            }
            if (srtString==nil)
            {
                srtString =[[NSString alloc]initWithData:responseObject encoding:NSASCIIStringEncoding];
            }
            NSArray* srtArray = [SrtPharse  pharseSrtString:srtString];
            if (complectBlok) {
                complectBlok(srtArray);
            }

        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (complectBlok) {
                complectBlok(nil);
            }
        }];
    }
    else{
        NSString *pathsrt =srtUrl;
        NSArray *array  =  [pathsrt componentsSeparatedByString:@"/"];
        if (!array || [array count] < 3) {
            if (complectBlok) {
                complectBlok(nil);
            }
            return;
        }
        
        pathsrt = [NSString  stringWithFormat:@"%@/%@/%@/%@",CachesDirectory,[array  objectAtIndex:(array.count-3)],[array  objectAtIndex:(array.count-2)],[array  objectAtIndex:(array.count   -1)]];
        NSString* content = [NSString stringWithContentsOfFile:pathsrt
                                                      encoding:NSUTF8StringEncoding
                                                         error:NULL];
        
        if (!content) {
            content = [NSString stringWithContentsOfFile:pathsrt
                                                encoding:NSUnicodeStringEncoding
                                                   error:NULL];
        }
        NSArray* srtArray = [SrtPharse  pharseSrtString:content];
        if (complectBlok) {
            complectBlok(srtArray);
        }
    }
}



@end
