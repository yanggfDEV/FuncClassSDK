//
//  FCStarView.m
//  FunChatStudent
//
//  Created by CyonLeuPro on 15/7/9.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import "FCStarView.h"
#import <FZBaseButton.h>

@interface FCStarView ()

@property (strong, nonatomic) NSMutableArray *starButtons;
@property (nonatomic, assign) BOOL firstShowBool;

@end

@implementation FCStarView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.currentStarIndex = 0;
//        self.insetEdge = UIEdgeInsetsMake(5, 5, 5, 5);
        self.firstShowBool = NO;
        self.starButtons = [@[] mutableCopy];
    }
    
    return self;
}

- (void)setStarCount:(NSInteger)starCount {
    _starCount = starCount;
    
    [self layoutIfNeeded];
}

- (void)setCurrentStarIndex:(NSInteger)currentStarIndex {
    _currentStarIndex = currentStarIndex;
    
    for (FZBaseButton *subButton in self.starButtons){
        NSNumber *subIndexNumber = subButton.data;
        if ([subIndexNumber intValue] > currentStarIndex) {
            [subButton setSelected:NO];
        } else {
            [subButton setSelected:YES];
        }
    }
}


- (FZBaseButton *)createStarButton {
    FZBaseButton *button = [FZBaseButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"star_big_unselect"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"star_big"] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:@"star_big"] forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(onStarButton:) forControlEvents:UIControlEventTouchUpInside];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    return button;
}


- (void)onStarButton:(FZBaseButton *)button {
    NSNumber *indexNumber = button.data;
//    for (FZBaseButton *subButton in self.starButtons){
//        NSNumber *subIndexNumber = subButton.data;
//        if ([subIndexNumber intValue] > [indexNumber intValue]) {
//            [subButton setSelected:NO];
//        } else {
//            [subButton setSelected:YES];
//        }
//    }
//
     
    self.currentStarIndex = [indexNumber integerValue];
    if (self.starSelectedBlock) {
        self.starSelectedBlock(self.currentStarIndex);
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self removeSubViews];
    
    if (self.starCount > 0) {
        
        CGFloat buttonSpace = 5;
        CGFloat originY = self.insetEdge.top;
        CGFloat buttonHeight = CGRectGetHeight(self.bounds) - self.insetEdge.top - self.insetEdge.bottom;
        CGFloat buttonWidth = (CGRectGetWidth(self.bounds) - self.insetEdge.left - self.insetEdge.right - buttonSpace * (self.starCount - 1)) / self.starCount;
        for (int i = 0; i < self.starCount; ++ i) {
            FZBaseButton *button = [self createStarButton];
            button.data = @(i);
            CGFloat originX = self.insetEdge.left + i * (buttonWidth + buttonSpace);
            
            button.frame = CGRectMake(originX, originY, buttonWidth, buttonHeight);
            [self addSubview:button];
            [self.starButtons addObject:button];
            
            if (i <= self.currentStarIndex) {
                [button setSelected:YES];
            } else {
                [button setSelected:NO];
            }
        }
    }
    
}


- (void)removeSubViews {
    for (UIView *subView in self.starButtons){
        [subView removeFromSuperview];
    }
    
    [self.starButtons removeAllObjects];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self layoutSubviews];
}

//- (void)didMoveToWindow {
//    [super didMoveToWindow];
//    
//    self.currentStarIndex = self.currentStarIndex;
//}

@end
