//
//  FZJusTalkConfig.h
//  FunChatStudent
//
//  Created by 刘滔 on 15/9/14.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#ifndef FunChatStudent_FZJusTalkConfig_h
#define FunChatStudent_FZJusTalkConfig_h

#import "FCVideoTalkProtocol.h"

/* 【注:】暂时仅使用正式Key和Justalk开发环境Server */

// Justalk App Key
#define STUDENT_JUSTALK_APP_KEY "6b4033a8102dd92abcd65097"
#define TEACHER_JUSTALK_APP_KEY "0c0875008578876a34234096"
#define QUPEIYING_JUSTALK_APP_KEY "26760b50d73e7e6ab4544094"
#define SHAOER_QuPeiYing_JUSTALK_APP_KEY "8e1babd0f82e0e6acb744093"

#define TEST_STUDENT_JUSTALK_APP_KEY "32bdafb8da0c9350443d5096"
#define TEST_TEACHER_JUSTALK_APP_KEY "933792308d1b4e10a5f44095"

// Justalk Server
#define kJusTalkCloudProductionServer  "sudp:ae.justalkcloud.com:9851"
#define kJusTalkCloudDevelopmentServer  "sudp:dev.ae.justalkcloud.com:9851"
#define kDefalutJusTalkCloudPassWord     "cszh!@#"

/****************** self-define notification ********************/

// dict key
#define kTalkJCallIdKey @"kTalkJCallIdKey"  // 通知中jcallid对应的key值
#define kResultKey  @"kResultKey"

// justalk发起通话后，使用此通知返回通话的jcallid
#define kStartVideoTalkUserInfoNotification  @"kStartVideoTalkUserInfoNotification"

#endif
