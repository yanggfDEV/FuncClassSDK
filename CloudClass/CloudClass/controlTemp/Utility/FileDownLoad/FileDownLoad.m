//
//  FileDownLoad.m
//  EnglishTalk
//
//  Created by DING FENG on 7/30/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//
#import "FileDownLoad.h"
#import "AFNetworking.h"
@implementation FileDownLoad
- (id)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}
+ (FileDownLoad *)sharedInstance
{
    static FileDownLoad *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[FileDownLoad alloc] init];
    });
    return _sharedInstance;
}
-(void)downLoadFileUrl:(NSString *)url  desPath:(NSString *)path prgressBlock:(ProgressBlock)block
{

}
- (void)downloadFile
{
    NSURL *url = [NSURL URLWithString:@"http://115.29.250.230/Uploads/Download/2014-06-28/53ae6c62c7abf.mp4"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    NSString *fullPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[url lastPathComponent]];
    NSLog(@"%@",fullPath);
    
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:fullPath append:NO]];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        NSLog(@"bytesRead: %u, totalBytesRead: %lld, totalBytesExpectedToRead: %lld   %f", bytesRead, totalBytesRead, totalBytesExpectedToRead,(float)totalBytesRead/totalBytesExpectedToRead);
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"RES: %@", [[[operation response] allHeaderFields] description]);
        NSError *error;
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:&error];
        if (error) {
            NSLog(@"ERR: %@", [error description]);
        } else {
            NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
            long long fileSize = [fileSizeNumber longLongValue];
            NSLog(@"fileSize  %lld",fileSize);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERR: %@", [error description]);
    }];
    [operation start];
}

- (void)downloadFileFrom:(NSString *)fromUrl desPath:(NSString *)path
{
    NSURL *url = [NSURL URLWithString:fromUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    NSString *fullPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[url lastPathComponent]];
    NSString *fullPath = path;
    NSLog(@"%@",fullPath);
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:fullPath append:NO]];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//        NSLog(@"bytesRead: %u, totalBytesRead: %lld, totalBytesExpectedToRead: %lld   %f", bytesRead, totalBytesRead, totalBytesExpectedToRead,(float)totalBytesRead/totalBytesExpectedToRead);
    }];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"RES: %@", [[[operation response] allHeaderFields] description]);
        NSError *error;
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fullPath error:&error];
        if (error) {
            NSLog(@"ERR: %@", [error description]);
        } else {
            NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
            long long fileSize = [fileSizeNumber longLongValue];
            NSLog(@"fileSize  %lld",fileSize);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERR: %@", [error description]);
    }];
    [operation start];
}

-(void)downloadCourse:(NSDictionary *)courseDict
{

//    self.courseInfoDict{
//        "album_id" = 0;
//        audio = "http://115.29.250.230/Uploads/Download/2014-07-29/53d76d5fc4349.mp3";
//        "category_id" = 1;
//        "create_time" = "2014-07-23 17:29";
//        description = "\U53f2\U4e0a\U6700\U65e0\U804a\U7684\U89c6\U9891\Uff01\U4f60\U6562\U770b\U4e0d\Uff1f";
//        "dif_level" = 1;
//        editor = "";
//        id = 486;
//        "if_subtitle" = 0;
//        ishow = 0;
//        pic = "http://115.29.250.230/Uploads/Picture/2014-07-23/53cf805f6c226.png";
//        sort = "-1";
//        status = 1;
//        "subtitle_en" = "http://115.29.250.230/Uploads/Download/2014-07-21/53ccd8078c116.srt";
//        "subtitle_zh" = 0;
//        title = "\U578b\U7537\U7684\U5e7d\U9ed8";
//        top = 1;
//        video = "http://115.29.250.230/Uploads/Download/2014-07-18/53c8d2fe6be78.MP4";
//        views = 712;
//    }

    if (courseDict.count<1||![courseDict objectForKey:@"video"] ||![courseDict objectForKey:@"subtitle_en"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"课程信息不完整." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
    NSString *localCourse= [CachesDirectory stringByAppendingPathComponent:@"localCourse"];
    NSString *courseDir= [localCourse stringByAppendingPathComponent:[NSString  stringWithFormat:@"course%@",[courseDict objectForKey:@"id"]]];
    
//    NSLog(@"%@",localCourse);
//    NSLog(@"%@",courseDir);
    
    if ([[courseDict objectForKey:@"audio"]  isKindOfClass:[NSString  class]])
    {
        if ([[courseDict objectForKey:@"audio"]  isKindOfURL])
        {
            NSString *desPath= [courseDir stringByAppendingPathComponent:[NSString  stringWithFormat:@"%@.mp3",[courseDict objectForKey:@"id"]]];
            [self  downloadFileFrom:[courseDict objectForKey:@"audio"] desPath:desPath];
        }
    }
    
    if ([[courseDict objectForKey:@"audio"]  isKindOfClass:[NSString  class]])
    {
        if ([[courseDict objectForKey:@"audio"]  isKindOfURL])
        {
            NSString *desPath= [courseDir stringByAppendingPathComponent:[NSString  stringWithFormat:@"%@.mp3",[courseDict objectForKey:@"id"]]];
            [self  downloadFileFrom:[courseDict objectForKey:@"audio"] desPath:desPath];
        }
    }

}

@end
