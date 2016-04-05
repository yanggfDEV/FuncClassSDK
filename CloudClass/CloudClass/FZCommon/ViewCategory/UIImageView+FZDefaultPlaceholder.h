//
//  UIImageView+FZDefaultPlaceholder.h
//  Pods
//
//  Created by CyonLeuPro on 15/6/25.
//
//

#import <UIKit/UIKit.h>

@interface UIImageView (FZDubbingDefaultPlaceholder)

#pragma mark - Default Dubbing Image

/**
 *  默认趣配音图片
 *
 *  @param url  url
 *  @param size 需要默认图片的大小
 */
- (void)fz_setImageWithDefaultPlaceholderWithURL:(NSURL *)url placeholderSize:(CGSize)size;

/**
 *  默认趣配音图片加载
 *
 *  @param url   图片url
 *  @param size  需要默认图片的大小
 *  @param completedBlock
 */
- (void)fz_setImageWithDefaultPlaceholderWithURL:(NSURL *)url placeholderSize:(CGSize)size completed:(SDWebImageCompletionBlock)completedBlock;

/**
 *  默认趣配音图片加载
 *
 *  @param url            图片url
 *  @param size  需要默认图片的大小
 *  @param progressBlock  加载进度
 *  @param completedBlock
 */
- (void)fz_setImageWithDefaultPlaceholderWithURL:(NSURL *)url placeholderSize:(CGSize)size progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;

/**
 *  需要单独设置默认图片
 *
 *  @param url            图片url
 *  @param image          默认图片
 *  @param completedBlock
 */
- (void)fz_setImageWithURL:(NSURL *)url placeholder:(UIImage *)image completed:(SDWebImageCompletionBlock)completedBlock;

#pragma mark - Avatar Image

/**
 *  默认头像图片
 *
 *  @param url  url
 *  @param size 默认头像大小
 */
- (void)fz_setImageWithAvatarDefaultPlaceholderWithURL:(NSURL *)url placeholderSize:(CGSize)size;

/**
 *  默认头像图片加载
 *
 *  @param url            头像url
 *  @param size  需要默认图片的大小
 *  @param completedBlock
 */
- (void)fz_setImageWithAvatarDefaultPlaceholderWithURL:(NSURL *)url placeholderSize:(CGSize)size completed:(SDWebImageCompletionBlock)completedBlock;


@end
