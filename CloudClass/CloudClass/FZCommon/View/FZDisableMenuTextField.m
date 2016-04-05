//
//  FZDisableMenuTextField.m
//  EnglishTalk
//
//  Created by Victor Ji on 15/9/19.
//  Copyright © 2015年 Feizhu Tech. All rights reserved.
//

#import "FZDisableMenuTextField.h"

@implementation FZDisableMenuTextField

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setDefaultEnables];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDefaultEnables];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaultEnables];
    }
    return self;
}

- (void)setDefaultEnables {
    self.enableSelect = YES;
    self.enableSelectAll = YES;
    self.enableCut = YES;
    self.enableCopy = YES;
    self.enablePaste = YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(selectAll:)) {
        return self.enableSelectAll;
    } else if (action == @selector(select:)) {
        return self.enableSelect;
    } else if (action == @selector(cut:)) {
        return self.enableCut;
    } else if (action == @selector(copy:)) {
        return self.enableCopy;
    } else if (action == @selector(paste:)) {
        return self.enablePaste;
    } else {
        return [super canPerformAction:action withSender:sender];
    }
}

@end
