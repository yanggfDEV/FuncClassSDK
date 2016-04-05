//
//  UIImageView+FZDefaultPlaceholder.m
//  Pods
//
//  Created by CyonLeuPro on 15/6/25.
//
//

#import "UIImageView+FZDefaultPlaceholder.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation UIImageView (FZDefaultPlaceholder)

#pragma mark - Default Dubbing Image

- (void)fz_setImageWithDefaultPlaceholderWithURL:(NSURL *)url placeholderSize:(CGSize)size {
    [self fz_setImageWithDefaultPlaceholderWithURL:url placeholderSize:size progress:nil completed:nil];
}

- (void)fz_setImageWithDefaultPlaceholderWithURL:(NSURL *)url placeholderSize:(CGSize)size completed:(SDWebImageCompletionBlock)completedBlock {
    [self fz_setImageWithDefaultPlaceholderWithURL:url placeholderSize:size progress:nil completed:completedBlock];
}


- (void)fz_setImageWithDefaultPlaceholderWithURL:(NSURL *)url placeholderSize:(CGSize)size progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock {
    
    [self sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"mainPageDefaultImg"] options:SDWebImageRetryFailed progress:progressBlock completed:completedBlock];
}

- (void)fz_setImageWithURL:(NSURL *)url placeholder:(UIImage *)image completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:image completed:completedBlock];
}

#pragma mark - Avatar Image

- (void)fz_setImageWithAvatarDefaultPlaceholderWithURL:(NSURL *)url placeholderSize:(CGSize)size {
    [self fz_setImageWithAvatarDefaultPlaceholderWithURL:url placeholderSize:size completed:nil];
}

- (void)fz_setImageWithAvatarDefaultPlaceholderWithURL:(NSURL *)url completed:(SDWebImageCompletionBlock)completedBlock {
    [self sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_avatar"] completed:completedBlock];
}

- (void)fz_setImageWithAvatarDefaultPlaceholderWithURL:(NSURL *)url placeholderSize:(CGSize)size completed:(SDWebImageCompletionBlock)completedBlock {
    [self fz_setImageWithURL:url placeholder:[UIImage imageNamed:@"default_avatar"]  completed:completedBlock];
}


@end
