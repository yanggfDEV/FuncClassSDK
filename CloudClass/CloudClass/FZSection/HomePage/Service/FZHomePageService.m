//
//  FZHomePageService.m
//  CloudClass
//
//  Created by guangfu yang on 16/3/8.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZHomePageService.h"
#import "FZAlipayService.h"
#import "FZAlipayModel.h"
#import "FZPayModel.h"
#import "FZHomePageModel.h"
#import "FZCourseInfoModel.h"
#import "FZTypeCourseInfoModel.h"
#import "FZCheckRemainNumModel.h"
#import <AlipaySDK/DataSigner.h>
#import <AlipaySDK/AlipaySDK.h>

@implementation FZHomePageService

- (void)getPubCourseList:(FZSearchQuery *)searchQuery
             course_type:(NSString *)course_type
                 success:(void (^)(NSInteger, NSString *, id))success
                 failure:(void (^)(id, NSError *))failure {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    if (searchQuery.start) {
        [parameDic setValue:[NSString stringWithFormat:@"%zi",searchQuery.start] forKey:@"start"];
    }
    if (searchQuery.rows) {
        [parameDic setValue:[NSString stringWithFormat:@"%zi",searchQuery.rows] forKey:@"rows"];
    }
    [parameDic setValue:course_type forKey:@"course_type"];
    NSString *urlString = [[FZAPIGenerate sharedInstance] API:@"pub_course_list"];
    [[FZNetWorkManager sharedInstance] GET:urlString needCache:NO parameters:parameDic responseClass:[FZHomePageModel class] success:success failure:failure];
}

- (void)getPubCourseInfo:(NSString *)course_id success:(void (^)(NSInteger, NSString *, id))success failure:(void (^)(id, NSError *))failure {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setValue:course_id forKey:@"course_id"];
    NSString *urlString = [[FZAPIGenerate sharedInstance] API:@"pub_course_info"];
    [[FZNetWorkManager sharedInstance] GET:urlString needCache:NO parameters:parameDic responseClass:[FZCourseInfoModel class] success:success failure:failure];
}

- (void)getTypeCourseInfo:(NSString *)course_id tch_id:(NSString *)tch_id success:(void (^)(NSInteger, NSString *, id))success failure:(void (^)(id, NSError *))failure {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setValue:course_id forKey:@"course_id"];
    [parameDic setValue:tch_id forKey:@"tch_id"];
    NSString *urlString = [[FZAPIGenerate sharedInstance] API:@"pub_course_sub_list"];
    [[FZNetWorkManager sharedInstance] GET:urlString needCache:NO parameters:parameDic responseClass:[FZTypeCourseInfoModel class] success:success failure:failure];
}


- (void)checkremainnumWithCourseID:(NSString *)course_id success:(void (^)(NSInteger, NSString *, id))success failure:(void (^)(id, NSError *))failure {
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setValue:course_id forKey:@"course_id"];
    NSString *urlString = [[FZAPIGenerate sharedInstance] API:@"checkremainnum"];
    [[FZNetWorkManager sharedInstance] GET:urlString needCache:NO parameters:parameDic responseClass:[FZCheckRemainNumModel class] success:success failure:failure];
}

/**
 * @guangfu yang 16-3-8 18:00
 * 课程支付
 *
 **/
- (void)courseWithAmount:(CGFloat)amount tid:(NSString *)tid pid:(NSString *)pid type:(NSString *)type success:(void (^)(NSInteger, NSString *, id))success failure:(void (^)(id, NSError *))failure alipayCallback:(void (^)(FZAlipayResult))callback alipayNotInstallBlock:(void (^)(void))notInstall {
     NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:@(amount) forKey:@"amount"];
    [params setValue:tid forKey:@"tid"];
    [params setValue:pid forKey:@"pk_id"];
    [params setValue:type forKey:@"type"];
    FZAlipayService *alipayService = [[FZAlipayService alloc] init];
    [alipayService getCourseOrderWithParams:params success:^(NSInteger statusCode, NSString *message, id dataObject) {
        success(statusCode, message, dataObject);
        if (statusCode == kFZRequestStatusCodeSuccess) {
            FZAlipayModel *orderModel = dataObject;
            FZPayModel *payModel = [[FZPayModel alloc] init];
            payModel.partner = orderModel.alipayPid;
            payModel.seller  = orderModel.alipayAccount;
            payModel.tradeNO = orderModel.orderId;
            payModel.productName = orderModel.title;
            payModel.productDescription = orderModel.desc;
            payModel.amount = [NSString stringWithFormat:@"%.2f", amount];
            payModel.notifyURL = orderModel.callbackUrl;
            payModel.service = @"mobile.securitypay.pay";
            payModel.paymentType = @"1";
            payModel.inputCharset = @"utf-8";
            payModel.itBPay = @"30m";
            payModel.showUrl = @"m.alipay.com";
            
            //将商品信息拼接成字符串
            NSString *orderSpec = [payModel description];
            //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
            id<DataSigner> signer = CreateRSADataSigner(orderModel.alipayPrivateKey);
            NSString *signedString = [signer signString:orderSpec];
            if (signedString != nil) {
                //将签名成功字符串格式化为订单字符串,请严格按照该格式
                NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderSpec, signedString, @"RSA"];
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"cloudClass" callback:^(NSDictionary *resultDic) {
                    NSInteger resultStatus = [[resultDic objectForKey:@"resultStatus"] integerValue];
                    callback(resultStatus);
                }];
            }
        }
    } failure:failure];
}

- (void)processOrderWithPaymentResult:(NSURL *)resultUrl
                      standbyCallback:(CompletionBlock)completionBlock {
    
}

- (void)courseWithOrderId:(NSString *)orderId success:(void (^)(NSInteger, NSString *, id))success failure:(void (^)(id, NSError *))failure alipayCallback:(void (^)(FZAlipayResult))callback alipayNotInstallBlock:(void (^)(void))notInstall {
    //    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"alipay://"]]) {
    //        notInstall();
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:LOCALSTRING(@"alert") message:LOCALSTRING(@"alipay_not_installed") delegate:nil cancelButtonTitle:LOCALSTRING(@"commit") otherButtonTitles:nil];
    //        [alert show];
    //        return;
    //    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //    [params setValue:orderId forKey:@"order_id"];
    [params setValue:orderId forKey:@"out_order_id"];
    FZAlipayService *walletService = [[FZAlipayService alloc] init];
    [walletService finishOrderWithParams:params success:^(NSInteger statusCode, NSString *message, id dataObject) {
        success(statusCode, message, dataObject);
        if (statusCode == kFZRequestStatusCodeSuccess) {
            FZAlipayModel *orderModel = dataObject;
            FZPayModel *payModel = [[FZPayModel alloc] init];
            payModel.partner = orderModel.alipayPid;
            payModel.seller  = orderModel.alipayAccount;
            payModel.tradeNO = orderModel.orderId;
            payModel.productName = orderModel.title;
            payModel.productDescription = orderModel.desc;
            payModel.amount = orderModel.amount;
            payModel.notifyURL = orderModel.callbackUrl;
            payModel.service = @"mobile.securitypay.pay";
            payModel.paymentType = @"1";
            payModel.inputCharset = @"utf-8";
            payModel.itBPay = @"30m";
            payModel.showUrl = @"m.alipay.com";
            
            //将商品信息拼接成字符串
            NSString *orderSpec = [payModel description];
            //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
            id<DataSigner> signer = CreateRSADataSigner(orderModel.alipayPrivateKey);
            NSString *signedString = [signer signString:orderSpec];
            if (signedString != nil) {
                //将签名成功字符串格式化为订单字符串,请严格按照该格式
                NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderSpec, signedString, @"RSA"];
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"kiddubbing" callback:^(NSDictionary *resultDic) {
                    NSInteger resultStatus = [[resultDic objectForKey:@"resultStatus"] integerValue];
                    callback(resultStatus);
                }];
            }
        }
    } failure:failure];
}

@end
