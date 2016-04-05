//
//  DataBaseManager.h
//  CloudClass
//
//  Created by guangfu yang on 16/2/22.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "MessageModel.h"

@interface DataBaseManager : NSObject

+ (void)openDataBase;
+ (void)createMessageTable;//创建消息表
+ (void)insertMessageTable:(MessageModel *)messageModel userId:(NSString *)userId;//插入消息
+ (void)deleteMessageTable:(NSString *)messageID userId:(NSString *)userId;//删除某条消息
+ (void)deleteMessageAllTable;
+ (BOOL)selectMessageTable:(NSString *)messageID userId:(NSString *)userId;//遍历数据库，查看某条消息是否存在
+ (NSMutableArray *)selectMessageTable:(NSString *)confId;
+ (NSMutableArray *)selectMessageAllTable;//取出所有消息
+ (NSInteger)selectMessageNoReadMsg;//未读消息

+ (void)updateMessageTable:(NSString *)confId;//标示全部已经读了


@end
