//
//  FZDisableMenuTextField.h
//  EnglishTalk
//
//  Created by Victor Ji on 15/9/19.
//  Copyright © 2015年 Feizhu Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZDisableMenuTextField : UITextField

@property (assign, nonatomic) BOOL enableSelect;
@property (assign, nonatomic) BOOL enableSelectAll;
@property (assign, nonatomic) BOOL enableCut;
@property (assign, nonatomic) BOOL enableCopy;
@property (assign, nonatomic) BOOL enablePaste;

@end
