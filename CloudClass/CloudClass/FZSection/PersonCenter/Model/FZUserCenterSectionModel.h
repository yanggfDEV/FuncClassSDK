//
//  FZUserCenterSectionModel.h
//  CloudClass
//
//  Created by guangfu yang on 16/1/28.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZBaseModel.h"

@interface FZUserCenterSectionModel : FZBaseModel

@property (copy, nonatomic) NSString *identifier;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSArray *cellModels;

@end
