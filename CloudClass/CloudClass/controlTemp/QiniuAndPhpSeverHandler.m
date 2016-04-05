//
//  QiniuAndPhpSeverHandler.m
//  EnglishTalk
//
//  Created by DING FENG on 12/15/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import "QiniuAndPhpSeverHandler.h"


@interface QiniuAndPhpSeverHandler()
{
    UILabel  *_upLoadProgress;
    NSArray *activity;
    UIImage  *_courseCover;
    NSString  *_courseName;
    UIImageView  *tempIv;
    UITextView *   textView;
    UIButton *saveToAlbum;
    UIButton *upLoad;
    UIView *line;
    UILabel *label1;
    UILabel *label2;
    UIScrollView *_scrollView;
    BOOL  upLoaded;
    UIButton  *backButton;
}
@end


@implementation QiniuAndPhpSeverHandler

-(void)upLoadToQiniu
{
    
    
    
    if (!self.hideUpLoadProgress) {
        [ProgressHUD    show:@"正上传服务器，请稍候..."];
    }
    
    NSLog(@"%@",self.videoPath);
    _filePath=self.videoPath;
    if (_filePath == nil) {
        return;
    }
    self.token = [FZLoginUser uploadToken];
    
    if (self.token)
    {
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"erro"
                                                        message:@"token erro,对不起，请重新登录，来解决这个问题。"
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
        [ProgressHUD  dismiss];
        return;
    }
    NSLog(@"%@",self.token);    //
    self.sUploader = [QiniuSimpleUploader uploaderWithToken:self.token];
    self.sUploader.delegate = self;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *string = [NSString  stringWithFormat:@"%@",self.videoName];
    NSString  *filename = [string   stringByReplacingOccurrencesOfString:@"mergeVideo" withString:@"id"];
    NSString   *keyString = [NSString  stringWithFormat:@"%@/%@",currentDateStr,filename];
    
    
    
    NSLog(@"keyString  %@",keyString);
    [self.sUploader uploadFile:_filePath key:keyString extra:nil];
}


-(void)upLoadToQiniuWithToken:(NSString  *)token{


    if (!self.hideUpLoadProgress) {
        [ProgressHUD    show:@"正上传服务器，请稍候..."];
    }
    
    NSLog(@"%@",self.videoPath);
    _filePath=self.videoPath;
    if (_filePath == nil) {
        return;
    }
    self.token = token;
    
    if (self.token)
    {
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"erro"
                                                        message:@"token erro,对不起，请重新登录，来解决这个问题。"
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
        [ProgressHUD  dismiss];
        return;
    }
    NSLog(@"%@",self.token);    //
    self.sUploader = [QiniuSimpleUploader uploaderWithToken:self.token];
    self.sUploader.delegate = self;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *string = [NSString  stringWithFormat:@"%@",self.videoName];
    NSString  *filename = [string   stringByReplacingOccurrencesOfString:@"mergeVideo" withString:@"id"];
    NSString   *keyString = [NSString  stringWithFormat:@"%@/%@",currentDateStr,filename];
    
    
    
    NSLog(@"keyString  %@",keyString);
    [self.sUploader uploadFile:_filePath key:keyString extra:nil];
}




-(void)uploadInfoToPhpServerP:(NSString *)jsonInfo
{
}


- (void)uploadProgressUpdated:(NSString *)filePath percent:(float)percent
{
    NSString  *s = [NSString  stringWithFormat:@"%.1f%%",percent*100];
    if (!self.hideUpLoadProgress) {
        [ProgressHUD  show:[NSString  stringWithFormat:@"请稍等，已上传：%@",s]];
    }
    _upLoadProgress.text =s;
}
- (void)uploadSucceeded:(NSString *)filePath ret:(NSDictionary *)ret
{
    if (!self.hideUpLoadProgress) {
        [ProgressHUD  showSuccess:@""];
    }
    
    NSString *jsonString;
    if ([NSJSONSerialization isValidJSONObject:ret])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:ret options:NSJSONWritingPrettyPrinted error:&error];
        jsonString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (self.qiniuResultBlock) {
            self.qiniuResultBlock(YES,jsonString);
        }
        
        
    }else
    {
        
        if (self.qiniuResultBlock) {
            self.qiniuResultBlock(NO,jsonString);
        }

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"上传文件信息失败！"
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    }
}
- (void)uploadFailed:(NSString *)filePath error:(NSError *)error
{
    NSLog(@"文件失败！%@  \n  %@",filePath,error);
    
    if (self.qiniuResultBlock) {
        self.qiniuResultBlock(NO,@"上传失败");
    }
    NSString *message=[NSString  stringWithFormat:@"上传失败： %@",error];
    
    
    if (!self.hideUpLoadProgress) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:nil];
        [alert show];
    }
    [ProgressHUD   dismiss];
}




@end
