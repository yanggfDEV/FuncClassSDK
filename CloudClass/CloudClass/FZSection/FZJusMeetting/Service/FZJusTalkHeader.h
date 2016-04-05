//
//  FZJsuTalkHeader.h
//  FunChatStudent
//
//  Created by 刘滔 on 15/9/11.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#ifndef FunChatStudent_FZJsuTalkHeader_h
#define FunChatStudent_FZJsuTalkHeader_h

// JusTalk
#define ZPLATFORM ZPLATFORM_IOS
#define OPENSSL_CONF_FILE_IOS_I386
#define OPENSSL_CONF_FILE_IOS_X86_64
#define OPENSSL_CONF_FILE_IOS_ARMV7
#define OPENSSL_CONF_FILE_IOS_ARMV7S
#define OPENSSL_CONF_FILE_IOS_ARM64

#define STRONGSELF typeof(self) __strong strongSelf = weakSelf;
#define _NullString(x) (!x || x.length == 0)

#import "zmf.h"
#import "zpios_osenv.h"
#import "mtc_api.h"
#import "mtc_ue.h"
#import "mtc_ue_db.h"
#import "mtc_conf.h"
#import "mtc_user.h"
#import "mtc_prov_db.h"
#import "mtc_prof_db.h"
#import "mtc_ver.h"

#include "rsa.h"
#include "evp.h"
#include "objects.h"
#include "x509.h"
#include "err.h"
#include "pem.h"
#include "ssl.h"

#import "Strings.h"
#import "FCJusTalkConfigHandler.h"
//#import "FZVideoTalkSDKLocalization.h"
#import "FCCommonCreate.h"
#import "FCCameraConfigManager.h"

//typedef ZINT JStatusCode;
typedef ZUINT JId;
typedef ZUINT JCallId;

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define JStatusCodeFormat "%d"
#define JStatusCodeFromNumber(number) [number intValue]
#define JStatusCodeToNumber(statusCode) [NSNumber numberWithInt:statusCode]

#define JIdFormat "%u"
#define JIdFromNumber(number) [number unsignedIntValue]
#define JIdToNumber(jid) [NSNumber numberWithUnsignedInt:jid]

#define JCallIdFormat "%u"
#define JCallIdFromNumber(number) [number unsignedIntValue]
#define JCallIdToNumber(callId) [NSNumber numberWithUnsignedInt:callId]

#endif
