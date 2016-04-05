//
//  NSAttributedString+Height.m
//
//
#import "NSAttributedString+Height.h"

@implementation NSAttributedString (Height)

+ (CGFloat)heightForAttributtedStringlines:(NSInteger)lineCount attributes:(NSDictionary *)attributes options:(NSStringDrawingOptions)options context:(NSStringDrawingContext *)context {
    
    CGRect attributesRect = [NSAttributedString rectForAttributtedStringlines:lineCount attributes:attributes options:options context:context];
    
    return attributesRect.size.height;
}

+ (CGRect)rectForAttributtedStringlines:(NSInteger)lineCount attributes:(NSDictionary *)attributes options:(NSStringDrawingOptions)options context:(NSStringDrawingContext *)context {
    if (lineCount <= 0) {
        return CGRectZero;
    }
    
    NSMutableString *string = [@"" mutableCopy];
    for (int i = 0; i < lineCount; i ++) {
        [string appendString:@"line"];
        if (i < lineCount - 1) {
            [string appendString:@"\n"];
        }
    }
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributeString addAttributes:attributes range:NSMakeRange(0, [attributeString length])];
    CGRect attributedRect = [attributeString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:options context:context];
    
    return attributedRect;
}

- (CGRect)fz_boundingRectWithSize:(CGSize)size options:(NSStringDrawingOptions)options context:(NSStringDrawingContext *)context {
    NSRange range = NSMakeRange(0, self.length);
    NSDictionary *attributes = [self attributesAtIndex:0 effectiveRange:&range];
    CGFloat singleLineHeight = [NSAttributedString heightForAttributtedStringlines:1 attributes:attributes options:options context:context];
    CGFloat twoLinesHeight = [NSAttributedString heightForAttributtedStringlines:2 attributes:attributes options:options context:context];
    CGRect fakeRect = [self boundingRectWithSize:size options:options context:context];
    CGFloat fakeHeight = fakeRect.size.height;
    
    CGFloat trueHeight;
    if (fakeHeight < twoLinesHeight) {
        trueHeight = singleLineHeight;
    } else {
        trueHeight = fakeHeight;
    }
    
    CGRect trueRect = CGRectMake(fakeRect.origin.x, fakeRect.origin.y, fakeRect.size.width, trueHeight);
    return trueRect;
}

- (CGFloat)fz_estimatedHeight:(CGFloat)width numberOfLines:(NSUInteger)numberOfLines {
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0.0f, 0.0f, width, CGFLOAT_MAX)];
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, self.length), path.CGPath, nil);
    CFArrayRef lines = CTFrameGetLines(frame);
    
    CGFloat retval = 0.0f;
    if (numberOfLines == 0 || CFArrayGetCount(lines) <= numberOfLines || numberOfLines == 1) {
        if (CFArrayGetCount(lines) == 1 || numberOfLines == 1) {
            CGFloat a, d, l;
            CTLineGetTypographicBounds(CFArrayGetValueAtIndex(lines, 0), &a, &d, &l);
            retval = a + d + l;
        } else {
            CGRect rect = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:0];
            retval = CGRectGetHeight(rect);
        }
        
    } else {
        CFRange range = CTLineGetStringRange(CFArrayGetValueAtIndex(lines, numberOfLines - 1));
        NSUInteger length = range.length + range.location;
        if ([[self.string substringWithRange:NSMakeRange(range.location + range.length - 1, 1)] isEqualToString:@"\n"]) {
            --length;
        }
        
        NSAttributedString *substring = [self attributedSubstringFromRange:NSMakeRange(0, length)];
        
        CGRect rect = [substring boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:0];
        retval =  CGRectGetHeight(rect);
    }
    
    CFRelease(framesetter);
    CFRelease(frame);
    
    return retval;
}


@end
