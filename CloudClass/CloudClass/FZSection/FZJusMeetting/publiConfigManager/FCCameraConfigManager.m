//
//  FCCameraConfigManager.m
//  Pods
//
//  Created by patty on 15/11/23.
//
//

#import "FCCameraConfigManager.h"
#import "zmf.h"
//#import <MtcVideo.h>

@implementation FCCameraConfigManager

+ (FCCameraConfigManager *)shareInstance
{
    static FCCameraConfigManager *configManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configManager = [[FCCameraConfigManager alloc] init];
    });
    return configManager;
}

- (void)videoCaptureStart
{
    const char *pcCapture = NULL;
    switch (self.cameraVideo) {
        case CallVideoFrontCamera:
            pcCapture = ZmfVideoCaptureFront;
            break;
        case CallVideoRearCamera:
            pcCapture = ZmfVideoCaptureBack;
            break;
        case CallVideoCameraOff:
            pcCapture = self.frontCamera ? ZmfVideoCaptureFront : ZmfVideoCaptureBack;
            break;
        default:
            return;
    }
    unsigned int iVideoCaptureWidth;
    unsigned int iVideoCaptureHeight;
    unsigned int iVideoCaptureFrameRate;
    Mtc_MdmGetCaptureParms(&iVideoCaptureWidth, &iVideoCaptureHeight, &iVideoCaptureFrameRate);
//    if (MtcCallDelegateGetEnabled(kMagnifierEnabled)) {
//        Zmf_VideoCaptureStart(pcCapture, 1280, 720, iVideoCaptureFrameRate);
//    }else{
//        Zmf_VideoCaptureStart(pcCapture, 640, 480, 15);
//    }

}





@end
