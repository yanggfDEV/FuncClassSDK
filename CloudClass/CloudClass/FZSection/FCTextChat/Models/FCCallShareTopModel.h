//
//  FCCallShareTopModel.h
//  Pods
//
//  Created by Jyh on 15/8/3.
//
//

#import "FZBaseModel.h"


@interface FCCallShareModel : FZBaseModel

@property (copy, nonatomic) NSString *share_title;
@property (copy, nonatomic) NSString *share_content;
@property (copy, nonatomic) NSString *share_pic;
@property (copy, nonatomic) NSString *share_url;

@end


@interface FCCallShareTopModel : FZBaseModel

@property (nonatomic) NSInteger code;

@property (copy, nonatomic) NSString *msg;

@property (strong, nonatomic) FCCallShareModel *callShareModel;

@end

