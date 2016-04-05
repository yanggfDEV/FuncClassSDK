//
//  FCStarView.h
//  FunChatStudent
//
//  Created by CyonLeuPro on 15/7/9.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

/*
*  布局星星
*  根据星星的个数来布局，返回当前点击的星星数
*/

#import <UIKit/UIKit.h>

typedef void(^FCStarSelectedBlock)(NSInteger index);

@interface FCStarView : UIView

@property (copy, nonatomic) FCStarSelectedBlock starSelectedBlock;
@property (assign, nonatomic) NSInteger starCount;
@property (assign, nonatomic) NSInteger currentStarIndex;

@property (assign, nonatomic) UIEdgeInsets insetEdge;//边距 

@end
