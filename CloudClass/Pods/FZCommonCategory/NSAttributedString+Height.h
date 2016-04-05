//
//  NSAttributedString+Height.h

#import <CoreText/CoreText.h>

@interface NSAttributedString (Height)

+ (CGFloat)heightForAttributtedStringlines:(NSInteger)lineCount attributes:(NSDictionary *)attributes options:(NSStringDrawingOptions)options context:(NSStringDrawingContext *)context;

/**
 * 此方法用来处理当NSAttributtedString有且只有一行，且其中包含中文时boundingRectWithSize计算出的正方形高度会包含行间距的问题
 * 此方法仅用于NSAttributedString中所有字符的attributes统一的情况下
 */
- (CGRect)fz_boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options context:(NSStringDrawingContext *)context;

- (CGFloat)fz_estimatedHeight:(CGFloat)width numberOfLines:(NSUInteger)numberOfLines;

@end
