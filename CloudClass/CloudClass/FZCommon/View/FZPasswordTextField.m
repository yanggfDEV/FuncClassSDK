//
//  FZPasswordTextField.m
//  KidDubbing
//
//  Created by Victor Ji on 15/11/25.
//  Copyright © 2015年 Feizhu Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FZPasswordTextField.h"

@interface FZPasswordTextField () <UITextFieldDelegate>


@end

@implementation FZPasswordTextField

#pragma mark - init

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupWithFrame:CGRectZero];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupWithFrame:CGRectZero];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupWithFrame:frame];
    }
    return self;
}

- (void)setupWithFrame:(CGRect)rect {
    self.delegate = self;
    self.keyboardType = UIKeyboardTypeASCIICapable;
    self.secureTextEntry = YES;
    self.returnKeyType = UIReturnKeyNext;
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.minCharacterCount = 0;
    self.maxCharacterCount = 0;
    self.font = [UIFont fontWithName:@"Courier" size:17.0f];
}

#pragma mark - setters

- (void)setLeftMargin:(CGFloat)leftMargin {
    _leftMargin = leftMargin;
    
    UIView *lefView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftMargin, 1)];
    self.leftView = lefView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

#pragma mark - text field delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length > 1 || (self.maxCharacterCount > 0 && textField.text.length == self.maxCharacterCount && ![string isEqualToString:@""])) {
        return NO;
    } else if (string.length == 0) {
        if (self.textChangeBlock) {
            self.textChangeBlock(self.text, range, string);
        }
        if ([self isSecureTextEntry]) {
            NSString *originString = textField.text;
            NSString *newString = [originString stringByReplacingCharactersInRange:range withString:string];
            textField.text = newString;
            return NO;
        } else {
            return YES;
        }
    } else {
        if (!([[NSCharacterSet decimalDigitCharacterSet] characterIsMember:[string characterAtIndex:0]] || [[NSCharacterSet lowercaseLetterCharacterSet] characterIsMember:[string characterAtIndex:0]] || [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:[string characterAtIndex:0]] || [string isEqualToString:@"\n"])) {
            if (self.textCharacterWrongBlock) {
                self.textCharacterWrongBlock();
            }
            return NO;
        } else {
            if ([string isEqualToString:@"\n"]) {
                [self resignFirstResponder];
                if (self.pressReturnBlock) {
                    self.pressReturnBlock();
                }
                return NO;
            } else {
                if (self.textChangeBlock) {
                    self.textChangeBlock(self.text, range, string);
                }
                if ([self isSecureTextEntry]) {
                    NSString *originString = textField.text;
                    NSString *newString = [originString stringByReplacingCharactersInRange:range withString:string];
                    textField.text = newString;
                    return NO;
                } else {
                    return YES;
                }
            }
        }
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSInteger textLength = textField.text.length;
    if (self.minCharacterCount > 0 && self.maxCharacterCount > 0 && (textLength < self.minCharacterCount || textLength > self.maxCharacterCount)) {
        if (self.textLengthWrongBlock) {
            self.textLengthWrongBlock(textLength);
        }
    }
    return YES;
}

#pragma mark - override

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(selectAll:)) {
        return NO;
    } else if (action == @selector(select:)) {
        return NO;
    } else if (action == @selector(cut:)) {
        return NO;
    } else if (action == @selector(copy:)) {
        return NO;
    } else if (action == @selector(paste:)) {
        return NO;
    } else {
        return [super canPerformAction:action withSender:sender];
    }
}

- (id)customOverlayContainer {
    return self;
}

@end
