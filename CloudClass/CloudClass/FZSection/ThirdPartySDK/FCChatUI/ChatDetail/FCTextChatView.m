//
//  FCTextChatView.m
//  FunChatStudent
//
//  Created by 李灿 on 15/10/10.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import "FCTextChatView.h"
#import <UIColor+Hex.h>
#import <Masonry.h>

@implementation FCTextChatView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addAllViews];
    }
    return self;
}
- (void)addAllViews
{
    //self.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    self.backgroundColor = [UIColor clearColor];

    self.chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 64 - 44) style:UITableViewStylePlain];
    self.chatTableView.showsVerticalScrollIndicator = NO;
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatTableView.backgroundColor = [UIColor colorWithHexString:@"efefef"];
    [self addSubview:_chatTableView];
}

@end
