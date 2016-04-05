//
//  NIEPhotosViewerViewController.h
//
//  Created by CyonLeu on 15/1/13.
//
/**
 *  @brief  图集查看器，基类支持通用的图片查看功能，如滑动切换，放大等
 */
#import <UIKit/UIKit.h>
#import "FZPhotosViewerModel.h"
#import "FCVideoTalkProtocol.h"

@interface FZPhotosViewerViewController : UIViewController

/**
 *  init
 *
 *  @param photos @[NIEPhotosViewerModel oject...`]
 *  @param index  start index
 *
 *  @return NIEPhotosViewerViewController
 */
- (instancetype)initWithPhotos:(NSArray *)photos currentIndex:(NSUInteger)index;
- (instancetype)initWithPhotos:(NSArray *)photos currentIndex:(NSUInteger)index shareData:(NSDictionary *)shareData;
- (instancetype)initWithEntryParams:(NSDictionary *)entryParams;

@property (nonatomic, assign) BOOL isEnglish;//是否显示英文
@property (strong, nonatomic) UICollectionView *collectionView;

@property (copy, nonatomic) NSString *photosID;//图集文章id
@property (strong, nonatomic) NSArray *photosArray;
@property (assign, nonatomic) NSUInteger currentIndex;//开始浏览的index

@property (copy, nonatomic) NSString *desc;//图集默认描述

@end
