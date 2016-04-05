//
//  NIETabControl.h
//  NIESpider
//
//  Created by Liuyong on 15-1-4.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import <HMSegmentedControl/HMSegmentedControl.h>

@interface FZTabControl : HMSegmentedControl

@property (assign, nonatomic) NSInteger prevSelectedSegmentIndex;

- (void)customInit;

@end
