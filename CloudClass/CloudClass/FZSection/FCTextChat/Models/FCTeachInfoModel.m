//
//  FCTeachInfoModel.m
//  Pods
//
//  Created by huyanming on 15/7/7.
//
//

#import "FCTeachInfoModel.h"
#import "FZLanguage.h"
//#import "FCTeachCommentsModel.h"
@implementation FCTeachInfoModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *dict = [[super JSONKeyPathsByPropertyKey] mutableCopy];
    
    NSDictionary *addDict =  @{
                               @"isExamine": @"is_examine",
                               @"isComplete": @"is_complete",
                               @"tchsId": @"tch_id",
                               @"tchUCID": @"tch_uc_id",
                               @"videoURl": @"video",
                               @"videoPic": @"video",
                               @"audio": @"audio",
                               @"education": @"education",
                               @"teachExperience": @"teach_experience",
                               @"picArray": @"pics",
                               @"interest": @"interest",
                               @"isNotice": @"is_notice",
                               @"profile":@"profile",
                               @"languageArray":@"language",
                               @"comments":@"comments"
//                               ,
//                               @"resultModel":@"tch_comments",
                               };
    
    [dict addEntriesFromDictionary:addDict];
    
    return dict;
}


+ (NSValueTransformer *)picArrayArrayJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[NSString class]];
}

+ (NSValueTransformer *)languageArrayJSONTransformer{
    
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[FZLanguage class]];
}

//+ (NSValueTransformer *)resultModelJSONTransformer {
//    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[FZResultTeachCommentsModel class]];
//}

@end




