//
//  MessageNumberCalcuator.h
//  EnglishTalk
//
//  Created by DING FENG on 2/4/15.
//  Copyright (c) 2015 ishowtalk. All rights reserved.
//



typedef void(^MessageNumberCalcuatorResultBlock)(int  sum);
#import <Foundation/Foundation.h>
#import <AFNetworking.h>


@interface MessageNumberCalcuator : NSObject
+ (MessageNumberCalcuator *)sharedInstance;
-(void)messageNumberCalcuateWithResultBlock:(MessageNumberCalcuatorResultBlock)block;
@property (nonatomic,strong) MessageNumberCalcuatorResultBlock  messageNumberCalcuatorResultBlock;
@end
