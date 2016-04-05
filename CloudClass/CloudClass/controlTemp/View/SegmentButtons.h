//
//  SegmentButtons.h
//  EnglishTalk
//
//  Created by DING FENG on 11/10/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ButtonBlock)();



@interface SegmentButtons : UIView


@property (nonatomic, strong) UIButton  *btn1;
@property (nonatomic, strong) UIButton  *btn2;
@property (nonatomic, strong) UIButton  *btn3;

@property (nonatomic, strong) ButtonBlock btn1Block;
@property (nonatomic, strong) ButtonBlock btn2Block;
@property (nonatomic, strong) ButtonBlock btn3Block;

@end
