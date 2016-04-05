//
//  CourseDescriptionView.h
//  EnglishTalk
//
//  Created by DING FENG on 6/11/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FiveStarBar.h"
#import "PageTextView.h"


@interface CourseDescriptionView : UIView

@property  (nonatomic,strong)   UILabel  *statisticsNum;
@property  (nonatomic,strong)   FiveStarBar  *fiveStarBar;
@property (nonatomic,strong)   NSDictionary  *dataSource;
@property (nonatomic,strong)  UIPageControl* pageControl;



@end
