//
//  FZBaseRootModel.m
//  Pods
//
//  Created by CyonLeuPro on 15/6/27.
//
//

#import "FZBaseRootModel.h"

@implementation FZBaseRootModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *dict = [[super JSONKeyPathsByPropertyKey] mutableCopy];
    
    NSDictionary *addDict = @{ @"status": @"status",
                               @"message": @"msg"
                              };
    
    [dict addEntriesFromDictionary:addDict];
    return dict;
}

@end
