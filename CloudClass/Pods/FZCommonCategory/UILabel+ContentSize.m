//
//  UILabel+ContentSize.m
//  Pods
//
//  Created by patty on 15/10/30.
//
//

#import "UILabel+ContentSize.h"

@implementation UILabel (ContentSize)

- (CGSize)setcontentSize {
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = self.lineBreakMode;
    paragraphStyle.alignment = self.textAlignment;
    
    NSDictionary * attributes = @{NSFontAttributeName : self.font,
                                  NSParagraphStyleAttributeName : paragraphStyle};
    
    CGSize contentSize = [self.text boundingRectWithSize:self.frame.size
                                                 options:(NSStringDrawingUsesLineFragmentOrigin)
                                              attributes:attributes
                                                 context:nil].size;
    return contentSize;
}
//|NSStringDrawingUsesFontLeading)

@end
