//
//  FCCallShareTopModel.m
//  Pods
//
//  Created by Jyh on 15/8/3.
//
//

#import "FCCallShareTopModel.h"

@implementation FCCallShareModel

@end


@implementation FCCallShareTopModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    
    NSMutableDictionary *mutableDict = [[super JSONKeyPathsByPropertyKey] mutableCopy];
    
    NSDictionary *dict = @{@"callShareModel":@"data"};
    
    [mutableDict addEntriesFromDictionary:dict];
    
    return mutableDict;
}

+ (NSValueTransformer *)callShareModelJSONTransformer{
    
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[FCCallShareModel class]];
}

@end
