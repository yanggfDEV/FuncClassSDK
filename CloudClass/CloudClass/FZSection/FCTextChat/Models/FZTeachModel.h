//
//  FZTeachModel.h
//  Pods
//
//  Created by huyanming on 15/7/2.
//
//

#import "FZBaseModel.h"

@interface FZTeachModel : FZBaseModel
@property (assign, nonatomic) NSInteger userId;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *mobile;
@property (assign, nonatomic) NSInteger sex;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *province;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *sign;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *price;
@property (assign, nonatomic) NSInteger isOnline;
@property (strong, nonatomic) NSString *star;
@property (assign, nonatomic) NSInteger totalOnline;
@property (assign, nonatomic) NSInteger status;
@property (assign, nonatomic) NSInteger birthday;
@property (strong, nonatomic) NSString *language;
@property (assign, nonatomic) NSInteger createTime;
@property (assign, nonatomic) NSInteger updateTime;
@property (assign, nonatomic) NSInteger isexamine;
@property (assign, nonatomic) NSInteger orderOnline;
@property (assign, nonatomic) NSInteger tchId;
@property (strong, nonatomic) NSString *countryEnstr;
@property (strong, nonatomic) NSString *countryChstr;
@property (assign, nonatomic) NSInteger collect;
@property (strong, nonatomic) NSString *levelName;

@end
