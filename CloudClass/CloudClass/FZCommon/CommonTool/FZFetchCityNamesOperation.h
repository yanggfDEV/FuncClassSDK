//
//  FZFetchCityNamesOperation.h
//  EnglishTalk
//
//  Created by CyonLeuPro on 15/6/6.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZFetchCityNamesOperation : NSOperation

+ (NSArray *)fetchDataFromDatabaseForID:(NSString *)identifier inTable:(NSString *)tableName;

@end
