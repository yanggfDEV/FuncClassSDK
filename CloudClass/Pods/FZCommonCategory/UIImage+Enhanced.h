//
//  UIImage+BiSEnhanced.h


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GradualDirection){
    GRADUAL_HORIZONTAL, GRADUAL_VERTICAL
};
@interface UIImage (Enhanced)

+ (UIImage *)navigationBarBackgroundImage:(UIColor *)color height:(CGFloat)height;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)imageWithGradualColor1:(UIColor *)color1 color2:(UIColor *)color2 direction:(GradualDirection)direction size:(CGSize)size;

- (UIImage *)imageGradientFromOriengeToRedWithPercent:(CGFloat)percent;

-(UIImage *)imageAtRect:(CGRect)rect;

- (UIImage*)scaleToHalf;

- (UIImage*)mergeHorizontalImage:(UIImage*)image;

- (UIImage*)mergeHorizontalImage:(UIImage*)image space:(CGFloat)space;

- (UIImage *)convertToGrayscale;
- (UIImage *)convertToGrayscaleWithSize:(CGSize)size;

- (UIImage*)scaledToSize:(CGSize)newSize;

- (UIImage *)imageMaskedWithColor:(UIColor *)color;



// rect to rect
- (CGRect)bitmapRectFromImageRect:(CGRect)rect;
- (CGRect)imageRectFrombitmapRect:(CGRect)rect;


+ (UIImage *)imageFromPDF:(NSString *)fileNameWithoutExtension size:(CGSize)size;

@end
