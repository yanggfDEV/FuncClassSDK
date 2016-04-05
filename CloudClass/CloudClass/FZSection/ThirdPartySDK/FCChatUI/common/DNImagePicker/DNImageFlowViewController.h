//
//  DNImageFlowViewController.h
//  ImagePicker
//
//  Created by DingXiao on 15/2/11.
//  Copyright (c) 2015年 Dennis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface DNImageFlowViewController : UIViewController
- (instancetype)initWithGroupURL:(NSURL *)assetsGroupURL;

/**
 * @guangfu yang 15-12-23
 * 相册多选
 */
- (void)getSelectImageArrayMethodTwo: (NSMutableArray *)array;

/**
 *  带有传值支持最大选择图片张数的初始化方法
 *
 *  @param assetsGroupURL 图片的地址
 *  @param imageCount     最大支持的图片张数
 *
 *  @return
 */
- (instancetype)initWithGroupURL:(NSURL *)assetsGroupURL maxImageCount:(NSUInteger)imageCount;

@end
