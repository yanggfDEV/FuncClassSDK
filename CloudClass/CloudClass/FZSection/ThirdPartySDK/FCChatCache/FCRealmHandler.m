//
//  FCRealmHandler.m
//  FunChatStudent
//
//  Created by 刘滔 on 15/10/9.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import "FCRealmHandler.h"
#import "FCChatWindowModel.h"
#import "FCChatMessageModel.h"
#import <Realm/RLMRealmConfiguration.h>

@implementation FCRealmHandler

+ (void)checkRealmModelWithName:(NSString *)realmName className:(Class)className realmVersion:(NSInteger)version {
//    [[self class] setDefaultRealmForName:realmName];
    
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    config.schemaVersion = version;
    config.migrationBlock = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        // 目前我们还未进行数据迁移，因此 oldSchemaVersion == 0
        if (oldSchemaVersion < version) {
//            NSString *classNameStr = NSStringFromClass(className);
//            [migration enumerateObjects:classNameStr
//                                  block:^(RLMObject *oldObject, RLMObject *newObject) {
//                                      NSString *windowClassName = NSStringFromClass([FCChatWindowModel class]);
//                                      if ([windowClassName isEqualToString:classNameStr]) {
//                                          newObject[@"primaryKeyProperty"] = @"userID";
//                                          FCChatWindowModel *model = (FCChatWindowModel *)newObject;
//                                          [model judgeNull];
//                                      } else {
//                                          newObject[@"primaryKeyProperty"] = @"timestamp";
//                                          FCChatMessageModel *model = (FCChatMessageModel *)newObject;
//                                          [model judgeNull];
//                                      }
//                                  }];
        }
    };
    // 使用默认的目录，但是使用用户名来替换默认的文件名
    config.path = [[[config.path stringByDeletingLastPathComponent]
                    stringByAppendingPathComponent:realmName]
                   stringByAppendingPathExtension:@"realm"];
    
    [RLMRealmConfiguration setDefaultConfiguration:config];
//    RLMRealm *realm = [RLMRealm defaultRealm];
//    NSLog(@"REALM : %@", realm);
}

+ (void)setDefaultRealmForName:(NSString *)name {
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    NSString *currentConfigName = [[config.path lastPathComponent] stringByDeletingPathExtension];
    if ([currentConfigName isEqualToString:name]) {
        return;
    }
    
    // 使用默认的目录，但是使用用户名来替换默认的文件名
    config.path = [[[config.path stringByDeletingLastPathComponent]
                    stringByAppendingPathComponent:name]
                   stringByAppendingPathExtension:@"realm"];

    // 将这个配置应用到默认的 Realm 数据库当中
    [RLMRealmConfiguration setDefaultConfiguration:config];
}

+ (void)addOrUpdateModel:(id)model realmName:(NSString *)realmName {
    [[self class] setDefaultRealmForName:realmName];
    
    // 获取默认的 Realm 实例
    RLMRealm *realm = [RLMRealm defaultRealm];
    // 每个线程只需要使用一次即可
    
    // 通过事务将数据添加到 Realm 中
    [realm beginWriteTransaction];
    [realm addOrUpdateObject:model];
    [realm commitWriteTransaction];
}

+ (void)deleteModel:(id)model realmName:(NSString *)realmName {
    [[self class] setDefaultRealmForName:realmName];
    
    // 获取默认的 Realm 实例
    RLMRealm *realm = [RLMRealm defaultRealm];
    // 每个线程只需要使用一次即可
    
    // 在事务中删除一个对象
    [realm beginWriteTransaction];
    [realm deleteObject:model];
    [realm commitWriteTransaction];
}

//+ (void)updateModel:(id)model realmName:(NSString *)realmName {
//    [[self class] setDefaultRealmForName:realmName];
//    
//    // 获取默认的 Realm 实例
//    RLMRealm *realm = [RLMRealm defaultRealm];
//    // 每个线程只需要使用一次即可
//    
//    // 通过 id = 1 更新该书籍
//    [realm beginWriteTransaction];
//    [RLMObject createOrUpdateInRealm:realm withValue:model];
//    [realm commitWriteTransaction];
//}

+ (RLMResults *)searchWhere:(NSString *)where searchClass:(Class)ClassName realmName:(NSString *)realmName {
    [[self class] setDefaultRealmForName:realmName];
    RLMResults *results = [ClassName objectsWhere:where];
    return results;
}

+ (RLMResults *)searchWhere:(NSString *)where searchClass:(Class)ClassName sortName:(NSString *)sortName ascending:(BOOL)bAscending realmName:(NSString *)realmName {
    [[self class] setDefaultRealmForName:realmName];
    RLMResults *results = nil;
    if (sortName) {
        results = [[ClassName objectsWhere:where] sortedResultsUsingProperty:sortName ascending:bAscending];
    } else {
        results = [ClassName objectsWhere:where];
    }
    return results;
}

@end
