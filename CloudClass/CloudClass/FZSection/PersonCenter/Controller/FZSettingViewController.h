//
//  FZSettingViewController.h
//  CloudClass
//
//  Created by guangfu yang on 16/3/14.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZCommonViewController.h"

typedef void (^QuitBlock) (void);
@interface FZSettingViewController : FZCommonViewController

@property (nonatomic, copy) QuitBlock quitBlock;

@end
