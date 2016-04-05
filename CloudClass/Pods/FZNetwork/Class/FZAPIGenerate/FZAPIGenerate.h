//
//  FZAPIGenerate.h
//  Pods
//
//  Created by yanming.huym on 15/5/19.
//
//

#import <Foundation/Foundation.h>

@interface FZAPIGenerate : NSObject

@property(nonatomic)BOOL isTestMode;

/**
 *  设置默认的协议类型，买家这边是通过访问接口来设置默认协议的
 */
@property (nonatomic, strong) NSString *defaultProtocol;


+(FZAPIGenerate*)sharedInstance;
-(NSString*)API:(NSString*)apiName;


@end
