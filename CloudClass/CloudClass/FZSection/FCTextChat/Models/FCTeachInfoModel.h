//
//  FCTeachInfoModel.h
//  Pods
//
//  Created by huyanming on 15/7/7.
//
//

#import "FZTeachModel.h"
//#import "FZResultTeachCommentsModel.h"
@interface FCTeachInfoModel : FZTeachModel
@property (assign, nonatomic) NSInteger isExamine;
@property (assign, nonatomic) NSInteger isComplete;
@property (assign, nonatomic) NSInteger tchsId;
@property (assign, nonatomic) NSInteger tchUCID;
@property (assign, nonatomic) NSInteger isNotice;
@property (strong, nonatomic) NSString *videoURl;
@property (strong, nonatomic) NSString *videoPic;
@property (strong, nonatomic) NSString *audio;
@property (strong, nonatomic) NSString *education;
@property (strong, nonatomic) NSString *teachExperience;
@property (strong, nonatomic) NSString *interest;
@property (strong, nonatomic) NSArray *picArray;
@property (strong, nonatomic) NSString *profile;
@property (assign, nonatomic) NSInteger comments;
@property (strong, nonatomic) NSArray *languageArray;
//@property (strong, nonatomic) FZResultTeachCommentsModel *resultModel;

@property (strong, nonatomic) NSString *isCollect;

@end
