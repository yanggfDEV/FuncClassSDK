//
//  FCRealmHandler.h
//  FunChatStudent
//
//  Created by 刘滔 on 15/10/9.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//
//  https://realm.io/cn/docs/objc/latest

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface FCRealmHandler : NSObject

// 判断是否需要升级realm的数据模型
+ (void)checkRealmModelWithName:(NSString *)realmName className:(Class)className realmVersion:(NSInteger)version;

+ (void)setDefaultRealmForName:(NSString *)name;

// 增/改
+ (void)addOrUpdateModel:(id)model realmName:(NSString *)realmName;

// 删
+ (void)deleteModel:(id)model realmName:(NSString *)realmName;

// 查
+ (RLMResults *)searchWhere:(NSString *)where searchClass:(Class)ClassName realmName:(NSString *)realmName;

// 查 [sortName为空时不进行排序]
+ (RLMResults *)searchWhere:(NSString *)where searchClass:(Class)ClassName sortName:(NSString *)sortName ascending:(BOOL)bAscending realmName:(NSString *)realmName;

@end
