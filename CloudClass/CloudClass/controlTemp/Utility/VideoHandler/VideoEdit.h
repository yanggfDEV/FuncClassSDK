//
//  VideoEdit.h
//  SimpleAVPlayer
//
//  Created by DING FENG on 6/2/14.
//  Copyright (c) 2014 dinfeng. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SDAVAssetExportSession.h"

typedef void(^CompleteBlock)(BOOL success);
@interface VideoEdit:NSObject
@property(nonatomic,retain)AVAsset* firstAsset;
@property(nonatomic,retain)AVAsset* secondAsset;
@property(nonatomic,retain)AVAsset* audioAsset;
@property(nonatomic,strong)CompleteBlock  completeBlock;
@property(nonatomic,strong)AVAssetExportSession *exporter;
@property (nonatomic,strong) NSArray *subtileArray;

- (void)exportDidFinish:(AVAssetExportSession*)session;
- (void)MergeAndSaveInFileVideoPath:(NSString *)path1  AudioPath:(NSString *)path2  SaveAt:(NSString  *)savePath;
- (void)exportDidFinish;
+ (VideoEdit *)sharedInstance;
- (void)clearData;
@end
