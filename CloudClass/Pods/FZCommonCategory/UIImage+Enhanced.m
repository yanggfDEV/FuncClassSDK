//
//  UIImage+BiSEnhanced.m

#import "UIImage+Enhanced.h"

static NSMutableDictionary *_navigationBarBackgroundImages;

typedef NS_ENUM(NSInteger, PIXELS){
    ALPHA,
    BLUE,
    GREEN,
    RED
};

@implementation UIImage (Enhanced)

+ (UIImage *)navigationBarBackgroundImage:(UIColor *)color height:(CGFloat)height{
    if(_navigationBarBackgroundImages == nil)
        _navigationBarBackgroundImages = [@{} mutableCopy];
    if(_navigationBarBackgroundImages[@[color, @(height)]] == nil){
        CGSize size = CGSizeMake([[UIScreen mainScreen]bounds].size.width, height);
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
        [color setFill];
        UIRectFill(CGRectMake(0, 0, size.width, size.height));
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        _navigationBarBackgroundImages[@[color, @(height)]] = newImage;
    }
    return _navigationBarBackgroundImages[@[color, @(height)]];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [color setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageGradientFromOriengeToRedWithPercent:(CGFloat)percent
{
    UIImage *image = self;
    UIColor* bgColor = [UIColor colorWithRed:0xff/255.0 green:0xcc/255.0 blue:0 alpha:1];
    CGColorRef cgColor = [bgColor CGColor];
    CGFloat components[16] = {0xff/255.0,0xcc/255.0,0,0.2,217/255.0,80/255.0,81/255.0,0.2,215/255.0,59/255.0,95/255.0,0.3,0xf9/255.0,0x2d/255.0,0x67/255.0,0.5};
    
    CGFloat locations[4] = {0,0.33,0.66,1};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef colorGradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, (size_t)4);
    CGRect contextRect;
    contextRect.origin.x = 0.0f;
    contextRect.origin.y = 0.0f;
    contextRect.size = [image size];
    contextRect.size.width *= percent;
    UIImage *itemImage = image;
    CGSize itemImageSize = [itemImage size];
    UIGraphicsBeginImageContextWithOptions(contextRect.size, NO, self.scale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextBeginTransparencyLayer(c, NULL);
    CGContextScaleCTM(c, 1.0, -1.0);
    CGContextClipToMask(c, CGRectMake(0, 0, itemImageSize.width, -itemImageSize.height), [itemImage CGImage]);
    CGContextSetFillColorWithColor(c, cgColor);
    contextRect.size.height = -contextRect.size.height;
    CGContextFillRect(c, contextRect);
    CGContextDrawLinearGradient(c, colorGradient,CGPointZero,CGPointMake(contextRect.size.width,contextRect.size.height),0);
    CGContextSetFillColorWithColor(c, [UIColor blackColor].CGColor);
    CGContextFillRect(c, CGRectMake(contextRect.size.width, 0, image.size.width-contextRect.size.width, image.size.height));
    CGContextDrawLinearGradient(c, colorGradient,CGPointMake(contextRect.size.width,0),CGPointMake(image.size.width,image.size.height),0);
    CGContextEndTransparencyLayer(c);
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGColorSpaceRelease(colorSpace);
    CGGradientRelease(colorGradient);
    return resultImage;
}

-(UIImage *)imageAtRect:(CGRect)rect
{
    CGImageRef cropImage = CGImageCreateWithImageInRect(self.CGImage, [self bitmapRectFromImageRect:rect]);
    UIImage *newImage = [UIImage imageWithCGImage:cropImage scale:1.0 orientation:self.imageOrientation];
    CGImageRelease(cropImage);
    return newImage;
}

- (UIImage*)scaleToHalf
{
    return [self scaleToSize:CGSizeMake(self.size.width/2, self.size.height/2)];
}

-(UIImage*)scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 2);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (UIImage*)mergeHorizontalImage:(UIImage*)image
{
    @autoreleasepool {
        //        CGSize size = self.size;
        //        size.width += image.size.width;
        //        UIGraphicsBeginImageContextWithOptions(size, NO, image.scale);
        //
        //        [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
        //        [image drawInRect:CGRectMake(self.size.width, 0, image.size.width,self.size.height)];
        //        UIImage* retImg = UIGraphicsGetImageFromCurrentImageContext();
        //        UIGraphicsEndImageContext();
        return [self mergeHorizontalImage:image space:0];
    }
}

- (UIImage*)mergeHorizontalImage:(UIImage*)image space:(CGFloat)space
{
    @autoreleasepool {
        CGSize size = self.size;
        size.width += image.size.width + space;
        UIGraphicsBeginImageContextWithOptions(size, NO, image.scale);
        
        [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
        [image drawInRect:CGRectMake(self.size.width + space, 0, image.size.width,self.size.height)];
        UIImage* retImg = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return retImg;
    }
}

- (UIImage *)convertToGrayscale {
    int width = self.size.width;
    int height = self.size.height;
    
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
    
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
            
            // set the pixels to gray
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
    
    // we're done with image now too
    CGImageRelease(image);
    
    return resultUIImage;
}

- (UIImage *)convertToGrayscaleWithSize:(CGSize)size{
    int width = self.size.width;
    int height = self.size.height;
    
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
    
    for(int y = 0; y < size.height; y++) {
        for(int x = 0; x < size.width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * (int)size.width + x];
            
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
            
            // set the pixels to gray
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
    
    // we're done with image now too
    CGImageRelease(image);
    
    return resultUIImage;
}

+ (UIImage *)imageWithGradualColor1:(UIColor *)color1 color2:(UIColor *)color2 direction:(GradualDirection)direction size:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //绘制渐性渐变
    //创建色彩空间
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    //颜色组件，每四个一组
    CGFloat components[8];
    //    CGFloat red1, green1, blue1, alpha1;
    //    CGFloat red2, green2, blue2, alpha2;
    [color1 getRed:components green:components+1 blue:components+2 alpha:components+3];
    [color2 getRed:components+4 green:components+5 blue:components+6 alpha:components+7];
    //开始和结束的位置数组，以百分比来表示的
    CGFloat location[] = {0.0, 1.0};
    //创建渐变
    CGGradientRef gradinet = CGGradientCreateWithColorComponents(space, components, location, 2);
    //裁剪
    // CGContextClipToRect(context, CGRectMake(0, 20, 100, 100));
    //开始绘制
    CGContextDrawLinearGradient(context, gradinet, CGPointMake(0, 0), CGPointMake(0, size.height), kCGGradientDrawsAfterEndLocation);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //释放内容
    CGGradientRelease(gradinet);
    CGColorSpaceRelease(space);
    
    //    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)scaledToSize:(CGSize)newSize{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    //CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationNone);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


- (UIImage *)imageMaskedWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, self.scale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    [self drawInRect:rect];
    CGContextSetFillColorWithColor(c, [color CGColor]);
    CGContextSetBlendMode(c, kCGBlendModeSourceIn);
    CGContextFillRect(c, rect);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}


// rect to rect
- (CGAffineTransform)bitmapFromImageTransform {
    CGSize imageSize = self.size;
    CGAffineTransform t = CGAffineTransformMakeTranslation(-imageSize.width / 2.0, -imageSize.height / 2.0);
    switch (self.imageOrientation) {
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            t = CGAffineTransformConcat(t, CGAffineTransformMakeRotation(M_PI));
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            t = CGAffineTransformConcat(t, CGAffineTransformMakeRotation(M_PI_2));
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            t = CGAffineTransformConcat(t, CGAffineTransformMakeRotation(-M_PI_2));
            break;
        default:
            break;
    }
    switch (self.imageOrientation) {
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            t = CGAffineTransformConcat(t, CGAffineTransformMakeScale(-1.0, 1.0));
            break;
        default:
            break;
    }
    CGSize transfromSize = CGSizeApplyAffineTransform(imageSize, t);
    t = CGAffineTransformConcat(t, CGAffineTransformMakeTranslation(fabs(transfromSize.width / 2.0), fabs(transfromSize.height / 2.0)));
    t = CGAffineTransformConcat(CGAffineTransformConcat(CGAffineTransformMakeScale(1.0 / self.scale, 1.0 / self.scale), t), CGAffineTransformMakeScale(self.scale, self.scale));
    return t;
}

- (CGRect)bitmapRectFromImageRect:(CGRect)rect {
    return CGRectApplyAffineTransform(rect, [self bitmapFromImageTransform]);
}

- (CGRect)imageRectFrombitmapRect:(CGRect)rect {
    return CGRectApplyAffineTransform(rect, CGAffineTransformInvert([self bitmapFromImageTransform]));
}


+ (UIImage *)imageFromPDF:(NSString *)fileNameWithoutExtension size:(CGSize)size {
    
    // Determine if the device is retina.
    BOOL isRetina = [UIScreen instancesRespondToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] != 1.0f;
    
    UIImage *image;
    // Image doesn't exist so load the PDF and create it.
    
    // Get a reference to the PDF.
    NSString *pdfName = [NSString stringWithFormat:@"%@.pdf", fileNameWithoutExtension];
    CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), (__bridge CFStringRef)pdfName, NULL, NULL);
    CGPDFDocumentRef pdfDoc = CGPDFDocumentCreateWithURL((CFURLRef)pdfURL);
    CFRelease(pdfURL);
    
    if (isRetina) {
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
    } else {
        UIGraphicsBeginImageContext( size );
    }
    
    // Load the first page. You could have multiple pages if you wanted.
    CGPDFPageRef pdfPage = CGPDFDocumentGetPage(pdfDoc, 1);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // PDF page drawing expects a lower-left coordinate system,
    // flip the coordinate system before we start drawing.
    CGRect bounds = CGContextGetClipBoundingBox(context);
    CGContextTranslateCTM(context, 0, bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // Save the graphics state.
    CGContextSaveGState(context);
    
    // CGPDFPageGetDrawingTransform provides an easy way to get the transform
    // for a PDF page. It will scale down to fit, including any
    // base rotations necessary to display the PDF page correctly.
    CGRect transformRect = CGRectMake(0, 0, size.width, size.height);
    CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(pdfPage, kCGPDFCropBox, transformRect, 0, true);
    
    // And apply the transform.
    CGContextConcatCTM(context, pdfTransform);
    
    // Draw the page.
    CGContextDrawPDFPage(context, pdfPage);
    
    // Restore the graphics state.
    CGContextRestoreGState(context);
    
    // Generate the image.
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    CGPDFDocumentRelease(pdfDoc);
    return image;
}

@end
