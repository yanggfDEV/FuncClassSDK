//
//  DataBaseManager.m
//  CloudClass
//
//  Created by guangfu yang on 16/2/22.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "DataBaseManager.h"
static sqlite3 *dbPoint = nil;

@implementation DataBaseManager
//打开数据库
+ (void)openDataBase {
    if (dbPoint) {
        return;
    }
    NSLog(@"%@", NSHomeDirectory());
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    path = [path stringByAppendingPathComponent: @"messages.rdb"];
    sqlite3_open(path.UTF8String, &dbPoint);
}

//创建消息表
+ (void)createMessageTable {
    [self openDataBase];
    NSString *sql = [NSString stringWithFormat: @"create table messages(msgFromMe varchar(50), isFailed varchar(50), msgId varchar(50), msgText varchar(200), msfByIdentify varchar(50), msgConfNumber varchar(50), msgByUserName varchar(50), headPicUrlName varchar(50), msgTargetIdentify varchar(50), msgByTargetUserName varchar(50), targetHeadPicUrlName varchar(50), msgStatus varchar(200), msgType varchar(50), messageStatus varchar(50), timestamp varchar(50), noReadMsg varchar(50), userId varchar(50))"];
    sqlite3_exec(dbPoint, sql.UTF8String, NULL, NULL, NULL);
}

//插入消息
+ (void)insertMessageTable:(MessageModel *)messageModel userId:(NSString *)userId{
    [self openDataBase];
    NSString *sql = [NSString stringWithFormat: @"insert into messages values('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", [NSString stringWithFormat:@"%d", messageModel.msgFromMe], [NSString stringWithFormat:@"%d",messageModel.isFailed], [NSString stringWithFormat:@"%d", messageModel.msgId], messageModel.msgText, messageModel.msgByIdentify, messageModel.msgConfNumber, messageModel.msgByUserName, messageModel.headPicUrlName, messageModel.msgTargetIdentify, messageModel.msgByTargetUserName, messageModel.targetHeadPicUrlName, messageModel.msgStatus,[NSString stringWithFormat:@"%lu",(unsigned long)messageModel.msgType],[NSString stringWithFormat:@"%lu", (unsigned long)messageModel.messageStatus], [NSString stringWithFormat:@"%ld",(long)messageModel.timestamp],@"0", userId];
    sqlite3_exec(dbPoint, sql.UTF8String, NULL, NULL, NULL);
}

//删除某个消息
+ (void)deleteMessageTable:(NSString *)messageID userId:(NSString *)userId{
    [self openDataBase];
    NSString *sql = [NSString stringWithFormat: @"delete from messages where msgId = '%@'", messageID];
    sqlite3_exec(dbPoint, sql.UTF8String, NULL, NULL, NULL);
}

+ (BOOL)selectMessageTable:(NSString *)messageID userId:(NSString *)userId {
    [self openDataBase];
    NSString *sql = [NSString stringWithFormat: @"select * from messages where msgId = '%@'", messageID];
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(dbPoint, sql.UTF8String, - 1, &stmt, NULL);
    if (result == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *addtimeStr = sqlite3_column_text(stmt, 2);
            NSString *addTime = [NSString stringWithUTF8String: (const char *)addtimeStr];
            if ([addTime isEqualToString: messageID]) {
                //存在
                sqlite3_finalize(stmt);
                return NO;
            }
        }
    }
    //不存在
    sqlite3_finalize(stmt);
    return YES;
}

+ (NSMutableArray *)selectMessageTable:(NSString *)confId {
    [self openDataBase];
    NSString *sql = [NSString stringWithFormat: @"select * from messages where msgId = '%@'", confId];
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(dbPoint, sql.UTF8String, - 1, &stmt, NULL);
    if (result == SQLITE_OK) {
        NSMutableArray *array = [NSMutableArray array];
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *msgFormMeDes = sqlite3_column_text(stmt, 0);
            NSString *msgFormMe = [NSString stringWithUTF8String: (const char *)msgFormMeDes];
            
            const unsigned char *isFailedDes = sqlite3_column_text(stmt, 1);
            NSString *isFailed = [NSString stringWithUTF8String: (const char *)isFailedDes];
            
            const unsigned char *msgIdDes = sqlite3_column_text(stmt, 2);
            NSString *msgId = [NSString stringWithUTF8String: (const char *)msgIdDes];
            
            const unsigned char *msgTextDes = sqlite3_column_text(stmt, 3);
            NSString *msgText = [NSString stringWithUTF8String: (const char *)msgTextDes];
            
            const unsigned char *msgByIdentifyDes = sqlite3_column_text(stmt, 4);
            NSString *msgByIdentify = [NSString stringWithUTF8String: (const char *)msgByIdentifyDes];
            
            const unsigned char *msgConfNumberDes = sqlite3_column_text(stmt, 5);
            NSString *msgConfNumber = [NSString stringWithUTF8String: (const char *)msgConfNumberDes];
            
            const unsigned char *msgByUserNameDes = sqlite3_column_text(stmt, 6);
            NSString *msgByUserName = [NSString stringWithUTF8String: (const char *)msgByUserNameDes];
            
            const unsigned char *headPicUrlNameDes = sqlite3_column_text(stmt, 7);
            NSString *headPicUrlName = [NSString stringWithUTF8String: (const char *)headPicUrlNameDes];
            
            const unsigned char *msgTargetIdentifyDes = sqlite3_column_text(stmt, 8);
            NSString *msgTargetIdentify = [NSString stringWithUTF8String: (const char *)msgTargetIdentifyDes];
            
            const unsigned char *msgByTargerUserNameDes = sqlite3_column_text(stmt, 9);
            NSString *msgByTargerUserName = [NSString stringWithUTF8String: (const char *)msgByTargerUserNameDes];
            
            const unsigned char *targerHeadPicUrlNameDes = sqlite3_column_text(stmt, 10);
            NSString *targerHeadPicUrlName = [NSString stringWithUTF8String: (const char *)targerHeadPicUrlNameDes];
            
            const unsigned char *msgStatusDes = sqlite3_column_text(stmt, 11);
            NSString *msgStatus = [NSString stringWithUTF8String: (const char *)msgStatusDes];
            
            const unsigned char *msgTypeDes = sqlite3_column_text(stmt, 12);
            NSString *msgType = [NSString stringWithUTF8String: (const char *)msgTypeDes];
            
            const unsigned char *messageStatusDes = sqlite3_column_text(stmt, 13);
            NSString *messageStatus = [NSString stringWithUTF8String: (const char *)messageStatusDes];
            
            const unsigned char *timestampDes = sqlite3_column_text(stmt, 14);
            NSString *timestamp = [NSString stringWithUTF8String: (const char *)timestampDes];
            
            const unsigned char *onReadMsgDes = sqlite3_column_text(stmt, 15);
            NSString *onReadMsg = [NSString stringWithUTF8String: (const char *)onReadMsgDes];
            
            MessageModel *model = [[MessageModel alloc] init];
            model.msgFromMe = [msgFormMe boolValue];
            model.isFailed = [isFailed boolValue];
            model.msgId = [msgId intValue];
            model.msgText = msgText;
            model.msgByIdentify = msgByIdentify;
            model.msgConfNumber = msgConfNumber;
            model.msgByUserName = msgByUserName;
            model.headPicUrlName = headPicUrlName;
            model.msgTargetIdentify = msgTargetIdentify;
            model.msgByTargetUserName = msgByTargerUserName;
            model.targetHeadPicUrlName = targerHeadPicUrlName;
            model.msgStatus = msgStatus;
            model.msgType = [msgType integerValue];
            model.messageStatus = [messageStatus integerValue];
            model.timestamp = [timestamp integerValue];
            model.noReadMsgCount = [onReadMsg integerValue];
            if ([confId isEqualToString:msgId]) {
                [array addObject:model];
            }
        }
        
        sqlite3_finalize(stmt);
        
        return array;
    }
    
    
    sqlite3_finalize(stmt);
    
    return [NSMutableArray array];
}

//取出消息
+ (NSMutableArray *)selectMessageAllTable {
    [self openDataBase];
    NSString *sql = [NSString stringWithFormat: @"select * from messages order by timestamp desc"];
    sqlite3_stmt *stmt = nil;
    int result = sqlite3_prepare_v2(dbPoint, sql.UTF8String, - 1, &stmt, NULL);
    if (result == SQLITE_OK) {
        NSMutableArray *array = [NSMutableArray array];
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *msgFormMeDes = sqlite3_column_text(stmt, 0);
            NSString *msgFormMe = [NSString stringWithUTF8String: (const char *)msgFormMeDes];
            
            const unsigned char *isFailedDes = sqlite3_column_text(stmt, 1);
            NSString *isFailed = [NSString stringWithUTF8String: (const char *)isFailedDes];
            
            const unsigned char *msgIdDes = sqlite3_column_text(stmt, 2);
            NSString *msgId = [NSString stringWithUTF8String: (const char *)msgIdDes];
            
            const unsigned char *msgTextDes = sqlite3_column_text(stmt, 3);
            NSString *msgText = [NSString stringWithUTF8String: (const char *)msgTextDes];
            
            const unsigned char *msgByIdentifyDes = sqlite3_column_text(stmt, 4);
            NSString *msgByIdentify = [NSString stringWithUTF8String: (const char *)msgByIdentifyDes];
            
            const unsigned char *msgConfNumberDes = sqlite3_column_text(stmt, 5);
            NSString *msgConfNumber = [NSString stringWithUTF8String: (const char *)msgConfNumberDes];
            
            const unsigned char *msgByUserNameDes = sqlite3_column_text(stmt, 6);
            NSString *msgByUserName = [NSString stringWithUTF8String: (const char *)msgByUserNameDes];
            
            const unsigned char *headPicUrlNameDes = sqlite3_column_text(stmt, 7);
            NSString *headPicUrlName = [NSString stringWithUTF8String: (const char *)headPicUrlNameDes];
            
            const unsigned char *msgTargetIdentifyDes = sqlite3_column_text(stmt, 8);
            NSString *msgTargetIdentify = [NSString stringWithUTF8String: (const char *)msgTargetIdentifyDes];
            
            const unsigned char *msgByTargerUserNameDes = sqlite3_column_text(stmt, 9);
            NSString *msgByTargerUserName = [NSString stringWithUTF8String: (const char *)msgByTargerUserNameDes];
            
            const unsigned char *targerHeadPicUrlNameDes = sqlite3_column_text(stmt, 10);
            NSString *targerHeadPicUrlName = [NSString stringWithUTF8String: (const char *)targerHeadPicUrlNameDes];
            
            const unsigned char *msgStatusDes = sqlite3_column_text(stmt, 11);
            NSString *msgStatus = [NSString stringWithUTF8String: (const char *)msgStatusDes];
            
            const unsigned char *msgTypeDes = sqlite3_column_text(stmt, 12);
            NSString *msgType = [NSString stringWithUTF8String: (const char *)msgTypeDes];
            
            const unsigned char *messageStatusDes = sqlite3_column_text(stmt, 13);
            NSString *messageStatus = [NSString stringWithUTF8String: (const char *)messageStatusDes];
            
            const unsigned char *timestampDes = sqlite3_column_text(stmt, 14);
            NSString *timestamp = [NSString stringWithUTF8String: (const char *)timestampDes];
            
            const unsigned char *onReadMsgDes = sqlite3_column_text(stmt, 15);
            NSString *onReadMsg = [NSString stringWithUTF8String: (const char *)onReadMsgDes];
            
            MessageModel *model = [[MessageModel alloc] init];
            model.msgFromMe = [msgFormMe boolValue];
            model.isFailed = [isFailed boolValue];
            model.msgId = [msgId intValue];
            model.msgText = msgText;
            model.msgByIdentify = msgByIdentify;
            model.msgConfNumber = msgConfNumber;
            model.msgByUserName = msgByUserName;
            model.headPicUrlName = headPicUrlName;
            model.msgTargetIdentify = msgTargetIdentify;
            model.msgByTargetUserName = msgByTargerUserName;
            model.targetHeadPicUrlName = targerHeadPicUrlName;
            model.msgStatus = msgStatus;
            model.msgType = [msgType integerValue];
            model.messageStatus = [messageStatus integerValue];
            model.timestamp = [timestamp integerValue];
            model.noReadMsgCount = [onReadMsg integerValue];
            [array addObject:model];
        }
        
        sqlite3_finalize(stmt);
        
        return array;
    }
    
    
    sqlite3_finalize(stmt);
    
    return [NSMutableArray array];
}

+ (NSInteger)selectMessageNoReadMsg {
    [self openDataBase];
    NSString *sql = [NSString stringWithFormat: @"select * from messages"];
    sqlite3_stmt *stmt = nil;
    NSInteger count = 0;
    int result = sqlite3_prepare_v2(dbPoint, sql.UTF8String, - 1, &stmt, NULL);
    if (result == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            const unsigned char *onReadMsgDes = sqlite3_column_text(stmt, 15);
            NSString *onReadMsg = [NSString stringWithUTF8String: (const char *)onReadMsgDes];
            if ([onReadMsg isEqualToString:@"0"]) {
                ++count;
            }
        }
    }
    return count;
}

//删除所有消息
+ (void)deleteMessageAllTable {
    [self openDataBase];
    NSString *sql = [NSString stringWithFormat: @"delete from messages"];
    sqlite3_exec(dbPoint, sql.UTF8String, NULL, NULL, NULL);
}

//标示所有已经读了
+ (void)updateMessageTable:(NSString *)confId {
    [self openDataBase];
    NSString *sql = [NSString stringWithFormat: @"update messages set noReadMsg = '%@' where msgId = '%@'", @"1", confId];
    sqlite3_exec(dbPoint, sql.UTF8String, NULL, NULL, NULL);
}

@end
