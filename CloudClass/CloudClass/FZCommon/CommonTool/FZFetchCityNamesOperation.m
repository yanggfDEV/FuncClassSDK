//
//  FZFetchCityNamesOperation.m
//  EnglishTalk
//
//  Created by CyonLeuPro on 15/6/6.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import "FZFetchCityNamesOperation.h"
#import "FZSwitchLocationModel.h"
#import "FZLocationModel.h"
#import "FZSwitchLocationService.h"

#import "FZCommonConstants.h"

#import <FMDB.h>

@implementation FZFetchCityNamesOperation

- (void)main {
    FZSwitchLocationService *switchLocationService = [[FZSwitchLocationService alloc] init];
    [switchLocationService queryLocationDataWithSuccessBlock:^(id responseObject) {
        FZSwitchLocationModel *locationModel = responseObject;
        
        if (locationModel && locationModel.dataArray) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserDefaultsHadSaveCityNames];
            [FZFetchCityNamesOperation updateInfoToDatabaseForModel:locationModel];
        }
        
    } failBlock:^(id responseObject,NSError *error) {
        
    }];
}

+ (FMDatabaseQueue *)database {
    static FMDatabaseQueue *Instance;
    static dispatch_once_t DispatchOnce;
    dispatch_once(&DispatchOnce, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString *databaseDir = [docDir stringByAppendingPathComponent:kDBCityInfoDatabaseName];
        if (![fileManager fileExistsAtPath:databaseDir]) {
            [fileManager createDirectoryAtPath:databaseDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *DatabaseName = [NSString stringWithFormat:@"%@.db", kDBCityInfoDatabaseName];
        NSString *fullPath = [databaseDir stringByAppendingPathComponent:DatabaseName];
        
        Instance = [FMDatabaseQueue databaseQueueWithPath:fullPath];
    });
    return Instance;
}


+ (void)updateInfoToDatabaseForModel:(FZSwitchLocationModel *)model {
    if (!model) {
        return;
    }
    [self createSaveInfoTable:kDBCityTableName];
    
    FMDatabaseQueue *database = [FZFetchCityNamesOperation database];
    __block BOOL success;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSArray *array = model.dataArray;
        for (FZLocationModel *item in array) {
            [database inDatabase:^(FMDatabase *db) {
                
                success = [db executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@(id, areaName, initial, ishot) VALUES(\"%@\", \"%@\", \"%@\", \"%@\")", kDBCityTableName, item.locationId, item.areaName, item.initial, item.ishot]];
            }];
        }
        
    });
}

+ (NSArray *)fetchDataFromDatabaseForID:(NSString *)identifier inTable:(NSString *)tableName {
    
    if (!identifier || identifier.length == 0) {
        return nil;
    }
    
    [self createSaveInfoTable:tableName];
    
    FMDatabaseQueue *database = [FZFetchCityNamesOperation database];
    NSMutableArray *resultVals = [NSMutableArray array];
    [database inDatabase:^(FMDatabase *db) {
        FMResultSet *results = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE id='%@'", tableName, identifier]];
        if (results) {
            while ([results next]) {
                FZLocationModel *item = [[FZLocationModel alloc] init];
                
                item.locationId = [results stringForColumn:@"id"];
                item.areaName = [results stringForColumn:@"areaName"];
                item.initial = [results stringForColumn:@"initial"];
                item.ishot = [results stringForColumn:@"ishot"];
                
                [resultVals addObject:item];
            }
        }
    }];
    
    return resultVals;
}

+ (void)createSaveInfoTable:(NSString *)tableName {
    __block BOOL success = YES;
    [[FZFetchCityNamesOperation database] inDatabase:^(FMDatabase *db) {
        success = [db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE if not exists %@ \
                                     ( \
                                     id TEXT PRIMARY KEY, \
                                     areaName TEXT, \
                                     initial TEXT,\
                                     ishot TEXT);", tableName]];
        
    }];
}

@end
