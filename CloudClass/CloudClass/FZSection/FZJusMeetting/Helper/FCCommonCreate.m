//
//  FCCommonCreate.m
//  Pods
//
//  Created by patty on 15/11/5.
//
//

#import "FCCommonCreate.h"

@implementation FCCommonCreate


+ (UILabel *)createBigLabel
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    
//    titleLabel.text = @"Learning How to Learn:Powerful mental tools to help you master tough subject";
    return titleLabel;
}

+ (UILabel *)createSmallLabel
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
//    titleLabel.text = @"Procrastination and Memory";
    return titleLabel;
}

+ (CGRect)getRectWithText:(NSString *)text withFont:(UIFont *)font withFrameWith:(CGFloat)width
{
    CGRect rect=[text boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    
    return rect;
}

+ (CGSize)getRectWithtext:(NSString *)text withFont:(CGFloat)textFont withObject:(UILabel *)object
{
    //行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:20];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, object.text.length)];
    //左右间距
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.headIndent = 15;//头部缩进，相当于左padding
    style.tailIndent = -15;//相当于右padding
    style.alignment = NSTextAlignmentLeft;//对齐方式
    style.firstLineHeadIndent = 15;//首行头缩进
    style.paragraphSpacingBefore = 15;
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, object.text.length)];
    object.attributedText = attributedString;
    
    CGSize size = CGSizeZero;
    UIFont *font = [UIFont systemFontOfSize:textFont];
    size = [text boundingRectWithSize:CGSizeMake(kScreenWidth, 100.0f)
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:@{NSFontAttributeName: font}
                              context:nil].size;
    return size;
}


@end
