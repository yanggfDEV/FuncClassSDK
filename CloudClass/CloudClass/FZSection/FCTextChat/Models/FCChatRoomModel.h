//
//  FCChatRoomModel.h
//  FunChatStudent
//
//  Created by 刘滔 on 15/9/28.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Auto_Dimiss,
    Commit_Dimiss,
    Man_Dimiss
}DimissType;

@interface FCChatRoomModel : NSObject
/**
 *  头像地址
 */
@property (copy, nonatomic) NSString *avatarUrl;
/**
 *  昵称
 */
@property (copy, nonatomic) NSString *nickname;
/**
 *  老师id
 */
@property (copy, nonatomic) NSString *tch_id;
/**
 *  老师ucid
 */
@property (copy, nonatomic) NSString *tch_ucid;

@property (copy, nonatomic) NSString *uc_id;

/**
 *  通话消费分钟
 */
@property (assign, nonatomic) NSUInteger restTime;
/**
 *  最少限制时间
 */
@property (assign, nonatomic) NSUInteger limitTime;

/**
 *  呼叫类型  1：点对点  2：匹配
 */
@property (copy, nonatomic) NSString *type;

@property (copy, nonatomic) NSString *cid;

/*通话时长*/
@property (assign, nonatomic) NSUInteger intCallingTime;

//消费次数
@property (assign, nonatomic) NSInteger tradeNum;

// 总消费金额
@property (assign, nonatomic) CGFloat consumeAmount;

// 套餐时长
@property (assign, nonatomic) NSUInteger packageTime;


@property (assign, nonatomic) DimissType dimissType;

/**
 *  单节微课id
 */
@property (assign, nonatomic) NSUInteger miniCourseID;

@end