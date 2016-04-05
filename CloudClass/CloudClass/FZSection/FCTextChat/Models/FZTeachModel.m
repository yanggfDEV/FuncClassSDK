//
//  FZTeachModel.m
//  Pods
//
//  Created by huyanming on 15/7/2.
//
//

#import "FZTeachModel.h"

@implementation FZTeachModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {

    return @{
             @"userId": @"tch_id",
             @"email": @"email",
             @"nickName": @"nickname",
             @"sex": @"sex",
             @"mobile": @"mobile",
             @"country": @"country",
             @"province": @"province",
             @"city": @"city",
             @"sign": @"sign",
             @"avatar": @"avatar",
             @"price": @"price",
             @"isOnline": @"is_online",
             @"star": @"star",
             @"totalOnline": @"total_online",
             @"status": @"status",
             @"birthday": @"birthday",
             @"language": @"language",
             @"createTime": @"create_time",
             @"updateTime": @"update_time",
             @"isexamine": @"is_examine",
             @"orderOnline": @"order_online",
             @"countryEnstr": @"country_en",
             @"countryChstr": @"country_cn",
             @"collect":@"is_collect",
             @"levelName":@"level_name",
             };

}

@end



