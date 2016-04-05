//
//  FZBaseRootModel.h
//  Pods
//
//  Created by CyonLeuPro on 15/6/27.
//
//

#import "FZBaseModel.h"
/**
 *  包含 status，message 字段
 */
@interface FZBaseRootModel : FZBaseModel


@property (assign, nonatomic) NSInteger status;
@property (strong, nonatomic) NSString *message;

@end
