//
//  FZPasswordTextField.h
//  KidDubbing
//
//  Created by Victor Ji on 15/11/25.
//  Copyright © 2015年 Feizhu Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZPasswordTextField : UITextField

@property (assign, nonatomic) CGFloat leftMargin;
@property (assign, nonatomic) NSInteger minCharacterCount;
@property (assign, nonatomic) NSInteger maxCharacterCount;

@property (copy, nonatomic) void (^textChangeBlock)(NSString *, NSRange, NSString *);
@property (copy, nonatomic) void (^pressReturnBlock)(void);
@property (copy, nonatomic) void (^textLengthWrongBlock)(NSInteger);
@property (copy, nonatomic) void (^textCharacterWrongBlock)(void);

@end
