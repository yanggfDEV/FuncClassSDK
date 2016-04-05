//
//  EXPhotoViewer.h
//  EXPhotoViewerDemo
//
//  Created by Julio Carrettoni on 3/20/14.
//  Copyright (c) 2014 Julio Carrettoni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FZCommonViewController.h"

@interface EXPhotoViewer : FZCommonViewController <UIScrollViewDelegate>





+ (void) showImageFrom:(UIImageView*)imageView  index:(int)index  imgUrlArray:(NSArray  *)imgArraay;

@end
