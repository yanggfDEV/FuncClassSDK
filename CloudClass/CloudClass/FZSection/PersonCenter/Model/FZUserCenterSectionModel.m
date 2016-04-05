//
//  FZUserCenterSectionModel.m
//  CloudClass
//
//  Created by guangfu yang on 16/1/28.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZUserCenterSectionModel.h"
#import "FZUserCenterModel.h"

@implementation FZUserCenterSectionModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"identifier"  : @"section_identifier",
             @"type"        : @"section_type",
             @"cellModels"  : @"configs"
             };
}

+ (NSValueTransformer *)cellModelsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[FZUserCenterModel class]];
}


@end
