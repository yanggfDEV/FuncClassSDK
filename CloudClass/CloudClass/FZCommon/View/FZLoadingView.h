//
//  NIELoadingView.h
//  nie
//
//  Created by Liuyong on 14-9-22.
//  Copyright (c) 2014年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "NIEDirectionButton.h"

@class FZLoadingView;

typedef void(^LVAnimationCompletedBlock)(BOOL finished);
typedef void(^FZLoadingViewActionBlock)(id sender);

typedef NS_ENUM(NSInteger, FZLoadingViewStatus) {
    FZLoadingViewStatusShow,
    FZLoadingViewStatusFailed,
    FZLoadingViewStatusEmpty,
    FZLoadingViewStatusHidden
};

//@protocol FZLoadingViewDelegate <NSObject>
//
//@optional
//- (void)loadingViewDidTap:(FZLoadingView *)loadingView;
//- (void)loadingView:(FZLoadingView *)loadingView clickButton:(UIButton *)button;
//
//@end

@interface FZLoadingView : UIView

@property (copy, nonatomic) FZLoadingViewActionBlock tapViewBlock;
@property (copy, nonatomic) FZLoadingViewActionBlock clickButtonBlock;

@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subTitleLabel;

//@property (assign, nonatomic) id<FZLoadingViewDelegate> delegate;
@property (assign, nonatomic) CGFloat verticalSpace; //default is 5.f;
@property (assign, nonatomic) BOOL buttonHidden;//default is YES;
@property (assign, nonatomic) BOOL emptyTapEnabled;//default is NO;
@property (assign, nonatomic) BOOL adjustGIFSizeForWidth;//default is YES;

@property (assign, nonatomic) CGFloat buttonTopSpace; //default is 10.f;
@property (assign, nonatomic) CGSize buttonSize;//default is (80, 30)
@property (assign, nonatomic, readonly) FZLoadingViewStatus status;


- (id)initWithFrame:(CGRect)frame containerView:(UIView *)containerView;
//- (void)adjustFrame;
- (void)setTapGestureEnabled:(BOOL)isEnabled;

- (void)show;
- (void)showAnimated:(LVAnimationCompletedBlock)completedBlock;
- (void)showAnimatedWithoutFinish:(LVAnimationCompletedBlock)completedBlock;

- (void)showAnimated:(BOOL)animated completionHandler:(LVAnimationCompletedBlock)completedBlock;
- (void)showAnimated:(BOOL)animated title:(NSString *)title completionHandler:(LVAnimationCompletedBlock)completedBlock;
- (void)showAnimated:(BOOL)animated title:(NSString *)title gifPath:(NSString *)gifPath completionHandler:(LVAnimationCompletedBlock)completedBlock;
- (void)showAnimated:(BOOL)animated title:(NSString *)title subTitle:(NSString *)subTitle completionHandler:(LVAnimationCompletedBlock)completedBlock;
- (void)showAnimated:(BOOL)animated title:(NSString *)title subTitle:(NSString *)subTitle gifPath:(NSString *)gifPath completionHandler:(LVAnimationCompletedBlock)completedBlock;

- (void)failed;
- (void)failedWithTitle:(NSString *)title;
- (void)failedWithTitle:(NSString *)title subTitle:(NSString *)subTitle;
- (void)failedWithTitle:(NSString *)title subTitle:(NSString *)subTitle image:(UIImage *)image;

- (void)empty;
- (void)emptyWithButtonHidden:(BOOL)buttonHidden;
- (void)emptyWithTitle:(NSString *)title subTitle:(NSString *)subTitle ;
- (void)emptyWithTitle:(NSString *)title subTitle:(NSString *)subTitle image:(UIImage *)image;
- (void)emptyWithTitle:(NSString *)title subTitle:(NSString *)subTitle image:(UIImage *)image buttonHidden:(BOOL)buttonHidden;

- (void)hide;
- (void)hideAnimated:(LVAnimationCompletedBlock)completedBlock;
- (void)hideAnimated:(BOOL)animated completionHander:(LVAnimationCompletedBlock)completedBlock;

//前面的hide都是没有动画的，下面的hide才是有渐隐动画的
- (void)animatedHide;
@end