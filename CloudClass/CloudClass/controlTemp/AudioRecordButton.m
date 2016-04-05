//
//  AudioRecordButton.m
//  EnglishTalk
//
//  Created by DING FENG on 12/12/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import "AudioRecordButton.h"


@interface AudioRecordButton()
{
    BOOL  touchInsideBtn;
    
    CGPoint oldLocationPoint;
}
@end
@implementation AudioRecordButton
- (id)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
   [super  touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [touch locationInView:self];
    BOOL isPointInsideView = [self pointInside:currentPosition withEvent:nil];
    
    
    BOOL isOldLocationPointInsideView = [self pointInside:oldLocationPoint withEvent:nil];

    if (isOldLocationPointInsideView &&!isPointInsideView) {
        if (self.currentTouchLocationChangeBlock) {
            self.currentTouchLocationChangeBlock(NO);
        }
    }else if (!isOldLocationPointInsideView &&isPointInsideView){
    
        if (self.currentTouchLocationChangeBlock) {
            self.currentTouchLocationChangeBlock(YES);
        }
    }
    
    
    oldLocationPoint =currentPosition;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (self.currentTouchLocationChangeBlock) {
        self.currentTouchLocationChangeBlock(YES);
    }

    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [touch locationInView:self];
    oldLocationPoint  = currentPosition;
    [super  touchesBegan:touches withEvent:event];
}


@end
