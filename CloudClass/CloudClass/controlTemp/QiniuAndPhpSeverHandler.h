//
//  QiniuAndPhpSeverHandler.h
//  EnglishTalk
//
//  Created by DING FENG on 12/15/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QiniuSimpleUploader.h"


typedef void(^QiniuResultBlock)(BOOL result,NSString  *jsonString);

@interface QiniuAndPhpSeverHandler : NSObject<QiniuUploadDelegate>

@property (nonatomic,strong)   NSString *videoPath;
@property (nonatomic,strong)   NSString *videoName;
@property (nonatomic,strong)   NSString *mediaLenth;

@property (nonatomic,strong)   NSDictionary *courseInfoDict;
@property (nonatomic)   float completeRate;
@property (retain, nonatomic)QiniuSimpleUploader *sUploader;
@property (copy, nonatomic)NSString *filePath;
@property (copy, nonatomic)NSString *token;
@property (nonatomic)  BOOL hideUpLoadProgress;

@property (nonatomic,strong)  QiniuResultBlock  qiniuResultBlock;



-(void)upLoadToQiniu;
-(void)upLoadToQiniuWithToken:(NSString  *)token;



@end
