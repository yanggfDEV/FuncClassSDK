//
//  FCCameraConfigManager.h
//  Pods
//
//  Created by patty on 15/11/23.
//
// 处理摄像头

#import <Foundation/Foundation.h>

enum {
    CallVideoCurrent = -1,
    CallVideoFrontCamera,//0
    CallVideoRearCamera,//1
    CallVideoCameraOff,//2
    CallVideoVoiceOnly
};

@interface FCCameraConfigManager : NSObject

@property (nonatomic, assign)int cameraVideo;
@property (nonatomic, assign)BOOL frontCamera;

+ (FCCameraConfigManager *)shareInstance;

- (void)videoCaptureStart;

@end
