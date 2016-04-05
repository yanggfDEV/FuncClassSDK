//
//  MessageNumberCalcuator.m
//  EnglishTalk
//
//  Created by DING FENG on 2/4/15.
//  Copyright (c) 2015 ishowtalk. All rights reserved.
//

#import "MessageNumberCalcuator.h"
#import "DBManager.h"

@interface MessageNumberCalcuator()
{
    int  unreadMessage_1;
    int  unreadChatMessage_2;
}
@property (nonatomic, strong) DBManager *dbManager;

@end



@implementation MessageNumberCalcuator
- (id)init
{
    self = [super init];
    if (self) {
        self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"Message.sql"];
    }
    return self;
}

+ (MessageNumberCalcuator *)sharedInstance
{
    static MessageNumberCalcuator *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[MessageNumberCalcuator alloc] init];
    });
    return _sharedInstance;
}



-(void)messageNumberCalcuateWithResultBlock:(MessageNumberCalcuatorResultBlock)block{


    unreadMessage_1 = 0;
    unreadChatMessage_2 = 0;
    self.messageNumberCalcuatorResultBlock =block;
    [self get_unreadMessageNum_1];
    [self get_unreadChatMessageNum_2];
}





-(void) get_unreadMessageNum_1{
    
    NSString *urlString = [[FZAPIGenerate sharedInstance] API:@"messages_index"];

    [[FZNetWorkManager sharedInstance] GET:urlString parameters:nil responseDtoClassType:nil success:^(id responseObject) {

        if ([responseObject  isKindOfClass:[NSDictionary class]])
        {
            NSString   *comments =[[responseObject  objectForKey:@"data"]      objectForKey:@"comments"];
            NSString   *supports =[[responseObject  objectForKey:@"data"]      objectForKey:@"supports"];
            NSString   *systems =[[responseObject  objectForKey:@"data"]      objectForKey:@"systems"];
            unreadMessage_1 =[comments  intValue]+[supports  intValue]+[systems  intValue];
            
            if (self.messageNumberCalcuatorResultBlock) {
                self.messageNumberCalcuatorResultBlock(unreadMessage_1+unreadChatMessage_2);
            }

            
        }
    } failure:^(id responseObject, NSError *error) {

    }];
}

-(void)get_unreadChatMessageNum_2{
    int  myid;
    myid =[[FZLoginUser userID]  intValue];
    NSString *query = [NSString  stringWithFormat:@"select * from messageTable where toId='%d' and attach2='NO'",myid];
    NSArray  *arrayTemp = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    if (arrayTemp.count>0) {
        unreadChatMessage_2 =(int)(arrayTemp.count);
        NSLog(@"1111get_unreadChatMessageNum_2%d",unreadChatMessage_2);
        if (self.messageNumberCalcuatorResultBlock) {
            self.messageNumberCalcuatorResultBlock(unreadMessage_1+unreadChatMessage_2);
        }

    }
    
}



@end
