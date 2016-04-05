//
//  FileDownLoad.h
//  EnglishTalk
//
//  Created by DING FENG on 7/30/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ProgressBlock)(float  rate);


@interface FileDownLoad : NSObject
+ (FileDownLoad *)sharedInstance;
-(void)downLoadFileUrl:(NSString  *)url  desPath:(NSString *)path   prgressBlock:(ProgressBlock)block;
-(void)downloadFile;
-(void)downloadCourse:(NSDictionary *)courseDict;
-(void)downloadFileFrom:(NSString *)fromUrl desPath:(NSString *)path;


@end