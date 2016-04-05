//
//  FWGIFImageView.m
//  FWImageViewPlayGIFDemo
//
//  Created by CyonLeu on 14-8-3.
//  Copyright (c) 2014年 CyonLeuInc. All rights reserved.
//

#import "FWGIFImageView.h"
#import <ImageIO/ImageIO.h>

@interface FWGIFImageView ()
{
    CGImageSourceRef    _gifSourceRef;
}

@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic) NSTimeInterval timestamp;
@property (nonatomic, readwrite) NSUInteger currentFrameIndex;
@property (nonatomic) NSUInteger repeatCount;
@property (nonatomic, readwrite) NSInteger frameCount;

@property (nonatomic, strong) FWGIFAnimationCompleteBlock completeBlock;

@end

@implementation FWGIFImageView


const NSTimeInterval kMaxTimeStep = 1;
NSString *const kReapeatCountAnimationFinishedNotification = @"kReapeatCountAnimationFinishedNotification";

@synthesize runLoopMode = _runLoopMode;

- (id)init
{
    self = [super init];
    if (self) {
        self.currentFrameIndex = 0;
    }
    return self;
}
#pragma mark - Public Method

- (id)initWithGIFPath:(NSString *)gifPath
{
    self = [self init];
    if (self) {
        if (gifPath) {
            [self setGIFPath:gifPath];
        }
    }
    
    return self;
}

- (void)setGIFPath:(NSString *)gifPath
{
    if (!gifPath) {
        return;
    }
    
    _gifSourceRef = CGImageSourceCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:gifPath], NULL);
    self.frameCount = CGImageSourceGetCount(_gifSourceRef);
}

- (void)startAnimatingWithCompleteBlock:(FWGIFAnimationCompleteBlock)completeBlock
{
    self.completeBlock = completeBlock;
    [self startAnimating];
}


#pragma mark - Private Method

- (CADisplayLink *)displayLink
{
    if (self.superview) {
        if (!_displayLink && _gifSourceRef) {
            _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateGIFContents:)];
            [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:self.runLoopMode];
        }
    } else {
        [_displayLink invalidate];
        _displayLink = nil;
    }
    return _displayLink;
}

- (NSString *)runLoopMode
{
    return _runLoopMode ? _runLoopMode : NSDefaultRunLoopMode;
}

- (void)setRunLoopMode:(NSString *)runLoopMode
{
    if (runLoopMode != _runLoopMode) {
        [self stopAnimating];
        
        NSRunLoop *runloop = [NSRunLoop mainRunLoop];
        if (_runLoopMode) {
            [self.displayLink removeFromRunLoop:runloop forMode:_runLoopMode];
        }
        
        [self.displayLink addToRunLoop:runloop forMode:runLoopMode];
        
        _runLoopMode = runLoopMode;
        
        [self startAnimating];
    }
}
- (BOOL)isAnimating
{
    return [super isAnimating] || (self.displayLink && !self.displayLink.isPaused);
}

- (void)stopAnimating
{
    self.repeatCount = 0;
    self.displayLink.paused = YES;
}

- (void)startAnimating
{
    if (self.isAnimating) {
        return;
    }
    if (self.currentFrameIndex >= self.frameCount) {
        self.currentFrameIndex = 0;
    }
    self.repeatCount = self.animationRepeatCount ?: NSUIntegerMax;
    
    self.displayLink.paused = NO;
}

- (float)frameDurationAtIndex:(size_t)index
{
    CFDictionaryRef dictRef = CGImageSourceCopyPropertiesAtIndex(_gifSourceRef, index, NULL);
    NSDictionary *dict = (__bridge NSDictionary *)dictRef;
    NSDictionary *gifDict = (dict[(NSString *)kCGImagePropertyGIFDictionary]);
    NSNumber *unclampedDelayTime = gifDict[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    NSNumber *delayTime = gifDict[(NSString *)kCGImagePropertyGIFDelayTime];
    CFRelease(dictRef);
    
    if (unclampedDelayTime.floatValue) {
        return unclampedDelayTime.floatValue;
    }else if (delayTime.floatValue) {
        return delayTime.floatValue;
    }else{
        return 1/24.0;
    }
}


- (void)updateGIFContents:(CADisplayLink *)displayLink
{
    if (self.currentFrameIndex >= self.frameCount) {
        return;
    }
    self.timestamp += fmin(displayLink.duration, kMaxTimeStep);
    
    while (self.timestamp >= [self frameDurationAtIndex:self.currentFrameIndex]) {
        self.timestamp -= [self frameDurationAtIndex:self.currentFrameIndex];
        if (++self.currentFrameIndex >= self.frameCount) {
            
            if (self.animationRepeatCount > 0) {
                if (--self.repeatCount == 0) {
                    
                    //Finish repeatCount
                    [self stopAnimating];
                    if (self.completeBlock) {
                        self.completeBlock(YES);
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:kReapeatCountAnimationFinishedNotification object:nil];
                    });
                    return;
                }
            }
            
            self.currentFrameIndex = 0;

        }//end of if (++self.currentFrameIndex
        
        self.currentFrameIndex = MIN(self.currentFrameIndex, self.frameCount - 1);
        CGImageRef ref = CGImageSourceCreateImageAtIndex(_gifSourceRef, self.currentFrameIndex, NULL);
        self.layer.contents = (__bridge id)(ref);
        CGImageRelease(ref);
        
    }//end of while()
}

- (UIImage *)imageForFrameIndex:(NSUInteger)index{
    if (index >= self.frameCount) {
        return nil;
    }
    
    UIImage *image = nil;
    if(_gifSourceRef){
        CGImageRef ref = CGImageSourceCreateImageAtIndex(_gifSourceRef, index, NULL);
        image = [UIImage imageWithCGImage:ref];
        CGImageRelease(ref);
    }
    return image;
}

@end
