//
//  FCCommonCreate.h
//  Pods
//
//  Created by patty on 15/11/5.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FCCommonCreate : NSObject

+ (UILabel *)createSmallLabel;

+ (UILabel *)createBigLabel;

+ (CGRect)getRectWithText:(NSString *)text withFont:(UIFont *)font withFrameWith:(CGFloat)width;

+ (CGSize)getRectWithtext:(NSString *)text withFont:(CGFloat)textFont withObject:(UILabel *)object;
@end