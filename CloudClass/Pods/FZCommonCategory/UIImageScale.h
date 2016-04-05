//
//  UIImage+UIImageScale.h
//  Pods
//
//  Created by FZ on 14-6-16.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (UIImageScale)
-(UIImage*)getSubImage:(CGRect)rect;
-(UIImage*)scaleToSize:(CGSize)size;
+ (UIImage *) createImageWithColor: (UIColor *) color;
@end
