//
//  FZSearchQuery.h
//  CloudClass
//
//  Created by guangfu yang on 16/1/27.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FZSearchQuery : NSObject

@property (strong, nonatomic) NSString* keyWord;
@property (assign, nonatomic) NSInteger start;
@property (assign, nonatomic) NSInteger rows;



@end
