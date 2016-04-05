//
//  NIEPhotosViewerCollectionViewCell.h
//  NIESpider
//
//  Created by Liuyong on 15-1-19.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FZUIImageScrollView.h"

@interface FZPhotosViewerCollectionViewCell : UICollectionViewCell

@property (assign, nonatomic) NSUInteger index;
@property (copy, nonatomic) void(^imageCompletedBlock)(UIImage *image, NSUInteger index, NSString *url);
@property (copy, nonatomic) void(^didSelectBlock)(FZPhotosViewerCollectionViewCell *cell);
@property (copy, nonatomic) void (^longPressGestureBlock)(CGPoint point, UIGestureRecognizerState state);
@property (strong, nonatomic, readonly) NSString *iconURL;
@property (strong, nonatomic, readonly) UIImage *blurSourceImage;
@property (weak, nonatomic) IBOutlet FZUIImageScrollView *imageScrollView;

- (void)setBackgroundImageViewHidden:(BOOL)isHidden;
- (void)updateCellInfoForData:(id)data;

@end
