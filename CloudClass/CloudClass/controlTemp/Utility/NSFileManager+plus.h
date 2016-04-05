//
//  NSFileManager+plus.h
//  iShowVideoTalk
//
//  Created by DING FENG on 5/22/14.
//  Copyright (c) 2014 dinfeng. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSFileManager (plus)


-(void)listDocumentDir;//列出Documents 下的文件和文件夹
-(void)listCachesDir;
-(void)deletAllFilesOfDocumentDir;//删除Documents  文件夹下得所有文件
-(void)deletAllFilesOfTmpDir;
-(void)deletFile:(NSString *)filePath;
-(void)renameFile:(NSString *)filePath newname:(NSString *)newName;
-(void)deletAllFilesOfTheDir:(NSString *)DirPath;
-(NSString *)getFileSizeAtPath:(NSString *)filePath;
-(NSString *)getDocumentsDirPath;
-(NSArray *)listFilesByType:(NSString *)fileType  documentDir:(NSString *)dir;
-(NSString *)sizeOfFolder:(NSString *)folderPath;
-(NSString *)folderSize:(NSString *)folderPath;
-(NSString *) cacheFolderSize;
-(unsigned long long int)folderSize_int:(NSString *)folderPath;


@end
