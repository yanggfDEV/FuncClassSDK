//
//  FWGIFImageView.h
//  FWImageViewPlayGIFDemo
//
//  Created by CyonLeu on 14-8-3.
//  Copyright (c) 2014年 CyonLeuInc. All rights reserved.
//

/**
 *  @brief Use UIImageView play GIF
 *      CADisplayLink and NSRunloop
 */


#import <UIKit/UIKit.h>


/** if animationRepeatCount = n (n>0)
 *  RepeatCount animation finished can receive this notification: kReapeatCountAnimationFinishedNotification
 */
extern  NSString *const kReapeatCountAnimationFinishedNotification;

typedef void(^FWGIFAnimationCompleteBlock)(BOOL finished);

@interface FWGIFImageView : UIImageView

/**
 *  @brief default runLoopMode is NSDefaultRunLoopMode 
 */
@property (nonatomic, copy) NSString *runLoopMode;
@property (nonatomic, readonly) NSUInteger currentFrameIndex;
@property (nonatomic, readonly) NSInteger frameCount;

- (id)initWithGIFPath:(NSString *)gifPath;
- (void)setGIFPath:(NSString *)gifPath;
- (void)startAnimatingWithCompleteBlock:(FWGIFAnimationCompleteBlock)completeBlock;
- (UIImage *)imageForFrameIndex:(NSUInteger)index;

@end
