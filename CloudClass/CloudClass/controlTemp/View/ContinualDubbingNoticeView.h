//
//  ContinualDubbingNoticeView.h
//  EnglishTalk
//
//  Created by DING FENG on 3/9/15.
//  Copyright (c) 2015 ishowtalk. All rights reserved.
//


typedef void(^NoticeTapedBlock)(void);
#import <UIKit/UIKit.h>




@interface ContinualDubbingNoticeView : UIView
@property (nonatomic,strong) NSDictionary  *noticeInfoDict;
@property (nonatomic,strong) NoticeTapedBlock  noticeTapedBlock;
-(void)show;



@end
