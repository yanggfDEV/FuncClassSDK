//
//  NIEPhotosViewerCollectionViewCell.m
//  NIESpider
//
//  Created by Liuyong on 15-1-19.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "FZPhotosViewerCollectionViewCell.h"
#import "FZPhotosViewerModel.h"
#import "UIColor+Hex.h"
#import "FZTransitonAnimationImageView.h"

@interface FZPhotosViewerCollectionViewCell ()

@property (weak, nonatomic) IBOutlet FZTransitonAnimationImageView *backgroundImageView;
@property (assign, nonatomic) BOOL backgroundImageHidden;
@property (strong, nonatomic, readwrite) UIImage *blurSourceImage;
@property (strong, nonatomic, readwrite) NSString *iconURL;

@end

@implementation FZPhotosViewerCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    
    typeof(self) __weak weakSelf = self;
    self.imageScrollView.maxImageZoomScale = 2.f;
    self.imageScrollView.longPressGestureBlock = ^(CGPoint point, UIGestureRecognizerState state){
        if (weakSelf.longPressGestureBlock) {
            weakSelf.longPressGestureBlock(point, state);
        }
    };
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageScrollView setNeedsLayout];
}

- (void)setBackgroundImageViewHidden:(BOOL)isHidden {
    self.backgroundImageHidden = isHidden;
    if (!isHidden && !self.backgroundImageView.image && self.blurSourceImage) {
//        [self updateBackgroundImage:self.blurSourceImage];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundImageView.alpha = (isHidden ? 0 : 1);
    } completion:^(BOOL finished) {
 
    }];
}

- (void)updateCellInfoForData:(id)data {
    FZPhotosViewerModel *item = (FZPhotosViewerModel *)data;
    if (!item) {
        return;
    }
    
    self.imageScrollView.status = FZImageViewZoomStatusNormal;
    
    typeof(self) __weak weakSelf = self;
//    self.backgroundImageView.image = nil;
    NSURL *url = [NSURL URLWithString:item.icon];
    UIImage *placeholder = [UIImage imageNamed:@"common_default_image"];
    if (item.image) {
        url = nil;
        self.blurSourceImage = item.image;
        placeholder = item.image;
        if (weakSelf.imageCompletedBlock) {
            weakSelf.imageCompletedBlock(item.image, weakSelf.index, item.icon);
        }
    }
    
    self.iconURL = item.icon;
    self.imageScrollView.zoomScale = 1;
    [self.imageScrollView layoutIfNeeded];
    
    self.imageScrollView.imageView.contentMode = UIViewContentModeScaleAspectFit;
    if ([UIImage imageWithContentsOfFile:item.icon]) {
        [self.imageScrollView setImageWithURL:url placeholder:[UIImage imageWithContentsOfFile:item.icon] completedBlock:^(UIImage *image) {
            weakSelf.blurSourceImage = weakSelf.imageScrollView.image;
            
            if (weakSelf.imageCompletedBlock) {
                weakSelf.imageCompletedBlock(image, weakSelf.index, item.icon);
            }
        }];
    } else {
        [self.imageScrollView setImageWithURL:url placeholder:[UIImage imageNamed:@"pic_loading"] completedBlock:^(UIImage *image) {
            weakSelf.blurSourceImage = weakSelf.imageScrollView.image;
            
            if (weakSelf.imageCompletedBlock) {
                weakSelf.imageCompletedBlock(image, weakSelf.index, item.icon);
            }
        }];
    }
    

    
    self.imageScrollView.singleTapBlock = ^(void) {
        if (weakSelf.didSelectBlock) {
            weakSelf.didSelectBlock(weakSelf);
        }
    };
}

@end
