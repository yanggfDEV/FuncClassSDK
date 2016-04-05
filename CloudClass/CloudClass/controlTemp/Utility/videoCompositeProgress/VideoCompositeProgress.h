//
//  VideoCompositeProgress.h
//  EnglishTalk
//
//  Created by DING FENG on 7/21/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCompositeProgress : UIView
{

}

@property  (nonatomic,strong)  UILabel *titleLabel;

@property (nonatomic,strong) UISlider *uislide1;
@property (nonatomic,strong) UISlider *uislide2;
@property (nonatomic,strong) UISlider *uislide3;



+ (VideoCompositeProgress *)sharedInstance;
- (void)hudShow;
- (void)dismiss;


@end
