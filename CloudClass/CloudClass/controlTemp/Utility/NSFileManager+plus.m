//
//  NSFileManager+plus.m
//  iShowVideoTalk
//
//  Created by DING FENG on 5/22/14.
//  Copyright (c) 2014 dinfeng. All rights reserved.
//

#import "NSFileManager+plus.h"

@implementation NSFileManager (plus)

-(void)listDocumentDir
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //在这里获取应用程序Documents文件夹里的文件及文件夹列表
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
    //    以下这段代码则可以列出给定一个文件夹里的所有子文件夹名
    NSMutableArray *dirArray = [[NSMutableArray alloc] init];
    BOOL isDir = NO;
    //在上面那段程序中获得的fileList中列出文件夹名
    for (NSString *file in fileList) {
        NSString *path = [documentDir stringByAppendingPathComponent:file];
        [fileManager fileExistsAtPath:path isDirectory:(&isDir)];
        if (isDir) {
            [dirArray addObject:file];
        }
        isDir = NO;
    }
    NSLog(@"Every Thing in the dir:%@",fileList);
    NSLog(@"All folders:%@",dirArray);
}


-(void)listCachesDir
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //在这里获取应用程序Documents文件夹里的文件及文件夹列表
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
    //    以下这段代码则可以列出给定一个文件夹里的所有子文件夹名
    NSMutableArray *dirArray = [[NSMutableArray alloc] init];
    BOOL isDir = NO;
    //在上面那段程序中获得的fileList中列出文件夹名
    for (NSString *file in fileList) {
        NSString *path = [documentDir stringByAppendingPathComponent:file];
        [fileManager fileExistsAtPath:path isDirectory:(&isDir)];
        if (isDir) {
            [dirArray addObject:file];
        }
        isDir = NO;
    }
    NSLog(@"Every Thing in the dir:%@",fileList);
    NSLog(@"All folders:%@",dirArray);
}


-(NSArray *)listFilesByType:(NSString *)fileType  documentDir:(NSString *)dir
{

    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:dir error:nil];
    NSString  *fltrStr = [NSString  stringWithFormat:@"self ENDSWITH '%@'",fileType];
    NSPredicate *fltr = [NSPredicate predicateWithFormat:fltrStr];
    NSArray *mp3s = [dirContents filteredArrayUsingPredicate:fltr];
    NSMutableArray *fullmp3s = [[NSMutableArray alloc] initWithCapacity:[mp3s count]];
    [mp3s enumerateObjectsUsingBlock:^(NSString *file, NSUInteger idx, BOOL *stop) {
        [fullmp3s addObject:[dir stringByAppendingPathComponent:file]];
    }];
    return fullmp3s;
}
-(void)deletAllFilesOfDocumentDir
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //在这里获取应用程序Documents文件夹里的文件及文件夹列表
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    NSError *error = nil;
    NSArray *fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
    //    以下这段代码则可以列出给定一个文件夹里的所有子文件夹名
    NSMutableArray *dirArray = [[NSMutableArray alloc] init];
    BOOL isDir = NO;
    //在上面那段程序中获得的fileList中列出文件夹名
    for (NSString *file in fileList) {
        NSString *path = [documentDir stringByAppendingPathComponent:file];
        [fileManager fileExistsAtPath:path isDirectory:(&isDir)];
        if (isDir) {
            [dirArray addObject:file];
            
        }
        isDir = NO;
    }
    NSLog(@"Every Thing in the dir:%@",fileList);
    NSLog(@"All folders:%@",dirArray);
    //delet
    for (NSString *file in fileList)
    {
        NSString  *pathTemp =[documentDir  stringByAppendingPathComponent:file];
        NSLog(@"delete:  %@",pathTemp);
        [self deletFile:pathTemp];
        
    }
}

-(void)deletAllFilesOfTmpDir
{
    NSFileManager* fileManager = [NSFileManager defaultManager];
    
    // get all files in the temp folder
    NSArray* files = [fileManager   contentsOfDirectoryAtPath:NSTemporaryDirectory() error:nil];
    // check if it contains my string
    for (int i=0; i<[files count]; i++)
    {
        NSString* fileName = [files objectAtIndex:i];
        [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@", NSTemporaryDirectory(), fileName] error:nil];
    }
}

-(void)deletAllFilesOfTheDir:(NSString *)DirPath
{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *dirToEmpty =DirPath;
    NSError *error = nil;
    NSArray *files = [manager contentsOfDirectoryAtPath:dirToEmpty
                                                      error:&error];

    if(error) {
        //deal with error and bail.
    }
    
    for(NSString *file in files) {
        [manager removeItemAtPath:[dirToEmpty stringByAppendingPathComponent:file]
                            error:&error];
        if(error) {
            //an error occurred...
        }
    }
}
-(void)deletFile:(NSString *)filePath
{
    NSError *error;
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:filePath]) {
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (!success) {
            NSLog(@"Error removing file at path: %@", error.localizedDescription);
        }
    }
}

-(void)renameFile:(NSString *)filePath newname:(NSString *)newName
{
    NSString *newPath = [[filePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:newName];
    [[NSFileManager defaultManager]   moveItemAtPath:filePath toPath:newPath error:nil];
}
-(NSString *)getDocumentsDirPath
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *DocumentsPath = [documentPaths objectAtIndex:0];
    return DocumentsPath;
}


- (NSArray*)getFilsByType:(NSString *)fileType
{
    //  Find all files in bundle
    NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:bundleRoot error:nil];
    NSPredicate *fltr = [NSPredicate predicateWithFormat:[NSString  stringWithFormat:@"self ENDSWITH '%@'",fileType]];
    NSArray *files = [dirContents filteredArrayUsingPredicate:fltr];
    //  Convert  to their full paths
    NSMutableArray *fullPaths = [[NSMutableArray alloc] initWithCapacity:[files count]];
    [files enumerateObjectsUsingBlock:^(NSString *file, NSUInteger idx, BOOL *stop) {
        [fullPaths addObject:[bundleRoot stringByAppendingPathComponent:file]];
    }];
    return fullPaths;
}


- (NSArray*)getMP3s {
    //  Find all mp3's in bundle
    NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:bundleRoot error:nil];
    NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '.mp3'"];
    NSArray *mp3s = [dirContents filteredArrayUsingPredicate:fltr];
    
    //  Convert mp3's to their full paths
    NSMutableArray *fullmp3s = [[NSMutableArray alloc] initWithCapacity:[mp3s count]];
    [mp3s enumerateObjectsUsingBlock:^(NSString *file, NSUInteger idx, BOOL *stop) {
        [fullmp3s addObject:[bundleRoot stringByAppendingPathComponent:file]];
    }];
    return fullmp3s;
}

- (NSString *)getFileSizeAtPath:(NSString *)filePath
{
    NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil];
    NSNumber *fileSizeNumber = [fileAttributes objectForKey:NSFileSize];
    long long fileSize = [fileSizeNumber longLongValue];
    NSString  *sizeS = [NSString  stringWithFormat:@"%lld",fileSize];
    return sizeS;
}

-(NSString *)sizeOfFolder:(NSString *)folderPath
{
    
    //  http://stackoverflow.com/questions/2188469/calculate-the-size-of-a-folder
    NSArray *contents = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *contentsEnumurator = [contents objectEnumerator];
    NSString *file;
    unsigned long long int folderSize = 0;
    
    while (file = [contentsEnumurator nextObject]) {
        NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:file] error:nil];
        folderSize += [[fileAttributes objectForKey:NSFileSize] intValue];
    }
    //This line will give you formatted size from bytes ....
    NSString *folderSizeStr = [NSByteCountFormatter stringFromByteCount:folderSize countStyle:NSByteCountFormatterCountStyleFile];
    return folderSizeStr;
}



- (NSString *)folderSize:(NSString *)folderPath
{
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    unsigned long long int fileSize = 0;
    
    while (fileName = [filesEnumerator nextObject]) {
        NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:fileName] error:nil];
        fileSize += [fileDictionary fileSize];
    }
    NSString *folderSizeStr = [NSByteCountFormatter stringFromByteCount:fileSize countStyle:NSByteCountFormatterCountStyleFile];
    return folderSizeStr;
}


-(unsigned long long int)folderSize_int:(NSString  *)folderPath{
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    unsigned long long int fileSize = 0;
    while (fileName = [filesEnumerator nextObject]) {
        NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:fileName] error:nil];
        fileSize += [fileDictionary fileSize];
    }
    return fileSize;
}




//-(unsigned long long int)folderSize_int:(NSString  *)folderPath{
//}


- (NSString *) cacheFolderSize {
    NSFileManager *_manager = [NSFileManager defaultManager];
    NSArray *_cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *_cacheDirectory = [_cachePaths objectAtIndex:0];
    NSArray *_cacheFileList;
    NSEnumerator *_cacheEnumerator;
    NSString *_cacheFilePath;
    unsigned long long int _cacheFolderSize = 0;
    _cacheFileList = [_manager subpathsAtPath:_cacheDirectory];
    _cacheEnumerator = [_cacheFileList objectEnumerator];
    while (_cacheFilePath = [_cacheEnumerator nextObject]) {
        NSDictionary *_cacheFileAttributes = [_manager attributesOfItemAtPath:[_cacheDirectory stringByAppendingPathComponent:_cacheFilePath] error:nil];
        _cacheFolderSize += [_cacheFileAttributes fileSize];
    }
    if(_cacheFolderSize<1024)
    {
        _cacheFolderSize = 0;
    }
    NSString *folderSizeStr = [NSByteCountFormatter stringFromByteCount:_cacheFolderSize countStyle:NSByteCountFormatterCountStyleFile];
    return folderSizeStr;
}



@end
