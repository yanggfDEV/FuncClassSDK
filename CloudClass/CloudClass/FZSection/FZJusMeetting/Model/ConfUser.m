//
//  ConfUser.m
//  JusMeeting
//
//  Created by Cathy on 15/11/12.
//  Copyright © 2015年 juphoon. All rights reserved.
//

#import "ConfUser.h"


@interface ConfUser () {
    UIView *_renderView;
}

@end

@implementation ConfUser

- (void)setSuperView:(UIView *)view
{
    if (!view) {
        if (_renderView)
            [_renderView removeFromSuperview];
        return;
    } else {
        if (_renderView) {
            Zmf_VideoRenderStop((__bridge void *)_renderView);
            Zmf_VideoRenderRemoveAll((__bridge void *)_renderView);
            [_renderView removeFromSuperview];
        }
        
        _renderView = [[UIView alloc] initWithFrame:view.bounds];
        Zmf_VideoRenderStart((__bridge void *)(_renderView), ZmfRenderView);
        Zmf_VideoRenderAdd((__bridge void *)(_renderView), [_renderId UTF8String], 0, ZmfRenderFullScreen);
        [view insertSubview:_renderView atIndex:0];
    }
}

- (void)stopRender
{
    if(_renderView) {
        Zmf_VideoRenderStop((__bridge void *)_renderView);
        Zmf_VideoRenderRemoveAll((__bridge void *)_renderView);
        [_renderView removeFromSuperview];
        _renderView = nil;
    }
}

- (void)cameraSwitch:(ZCONST ZCHAR *)newRenderId
{
    if (_renderView) {
        Zmf_VideoRenderReplace((__bridge void *)(_renderView), [_renderId UTF8String], newRenderId);
    }
    _renderId = [NSString stringWithUTF8String:newRenderId];
}

@end
