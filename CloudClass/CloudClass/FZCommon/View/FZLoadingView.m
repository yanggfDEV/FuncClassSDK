//
//  NIELoadingView.m
//  nie
//
//  Created by Liuyong on 14-9-22.
//  Copyright (c) 2014年 netease. All rights reserved.
//

#import <Masonry/Masonry.h>
#import <Shimmer/FBShimmeringView.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <FWGIFImageView.h>
//#import <ReactiveCocoa/RACEXTScope.h>

#import "FZLoadingView.h"
//#import "UIColor+BiSEnhanced.h"
//#import "NIEStyleSheet.h"
#import "FZStyleSheet.h"
//#import "UIButton+NIEButtonStyle.h"


static NSString * const ANIMATE_SHOW_COMPLETE = @"animate_show_complete";
static CGFloat deltaY = 15;

@interface FZLoadingView()

@property (weak, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIView *contentView;
//@property (strong, nonatomic) FBShimmeringView *shimmeringView;
@property (strong, nonatomic) FWGIFImageView *gifImageView;

@property (assign, nonatomic) CGSize imageSize;
@property (strong, nonatomic) UITapGestureRecognizer *tapGesture;

@property (assign, nonatomic) BOOL animating;
@property (assign, nonatomic) BOOL shouldHide;
@property (assign, nonatomic) BOOL shouldAnimate;
@property (copy, nonatomic) LVAnimationCompletedBlock completedBlock;

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subTitle;
@property (strong, nonatomic) UIImage *image;
@property (nonatomic) SEL animationDelaySEL;

@property (assign, nonatomic, readwrite) FZLoadingViewStatus status;
@property (strong, nonatomic) FZStyleSheet *css;

@end

@implementation FZLoadingView

#pragma mark - init & life 

- (id)initWithFrame:(CGRect)frame containerView:(UIView *)containerView {
    if (self = [super initWithFrame:frame]) {
        self.css = [FZStyleSheet currentStyleSheet];
        [self setupSelfWithContainerView:containerView];
        [self setupTapGesture];
        [self setupContentViewWithWidth:CGRectGetWidth(frame)];
        
//        [self setupShimmeringView];
        [self setupGIFImageView];
        [self setupImageView];
        [self setupTitleLabelWithWidth:CGRectGetWidth(frame)];
        [self setupSubTitleLabelWithWidth:CGRectGetWidth(frame)];
        [self setupButton];
        
        [self addSubviewsToContentView];
        
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self);
            make.center.equalTo(self);
            make.bottom.equalTo(self.button);
        }];
        
        [self updateConstraintLayoutForImageView:self.imageView];
        [self setupDefaultValues];
    }
    return self;
}

//- (void)setupSelfWithDelegate:(id<FZLoadingViewDelegate>)delegate containerView:(UIView *)containerView {
////    self.delegate = delegate;
//    self.backgroundColor = self.css.colorOfBackground;
//    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    self.containerView = containerView;
//    
//    [self.containerView addSubview:self];
//}

- (void)setupSelfWithContainerView:(UIView *)containerView {
    //    self.delegate = delegate;
    self.backgroundColor = self.css.colorOfBackground;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.containerView = containerView;
    
    [self.containerView addSubview:self];
}

- (void)setupTapGesture {
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
    self.tapGesture.enabled = NO;
    [self addGestureRecognizer:self.tapGesture];
}

- (void)setupContentViewWithWidth:(CGFloat)width {
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 140)];
    [self addSubview:self.contentView];
    self.contentView.center = self.center;
    self.contentView.backgroundColor = self.css.colorOfBackground;
}

- (CGRect)shimmeringViewFrame {
    return CGRectMake(0, 0, P2PSZ(135), P2PSZ(135));
}

- (void)setupShimmeringView {
//    FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:[self shimmeringViewFrame]];
//    shimmeringView.shimmering = YES;
//    shimmeringView.shimmeringPauseDuration = 0.5;
//    shimmeringView.shimmeringAnimationOpacity = 0.25;
//    shimmeringView.shimmeringSpeed = 70;
//    shimmeringView.shimmeringOpacity = 1;
//    shimmeringView.tag = 1;
//    shimmeringView.center = CGPointMake(CGRectGetMidX(self.frame) - self.frame.origin.x, CGRectGetMidY(self.frame) + deltaY - self.frame.origin.y);
//    shimmeringView.userInteractionEnabled = YES;
//    shimmeringView.backgroundColor = [UIColor clearColor];
//    self.shimmeringView = shimmeringView;
//    
//    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder-clear"]];
//    self.shimmeringView.contentView = logoImageView;
//    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.shimmeringView);
//    }];
}

- (void)setupGIFImageView {
    CGSize imageSize = CGSizeMake(P2PSZ(180), P2PSZ(180));
    FWGIFImageView *gifImageView = [[FWGIFImageView alloc] initWithFrame:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    gifImageView.tag = 1;
    gifImageView.backgroundColor = [UIColor clearColor];
    
    self.gifImageView = gifImageView;
}

- (void)setupImageView {
    CGSize size = [self getLoadingEmptyImageSize];
    UIImageView *faceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    faceImageView.tag = 2;
    faceImageView.backgroundColor = [UIColor clearColor];
    faceImageView.center = CGPointMake(CGRectGetMidX(self.frame) - self.frame.origin.x, CGRectGetMidY(self.frame) + deltaY - self.frame.origin.y);
    faceImageView.userInteractionEnabled = YES;
    
    self.imageView = faceImageView;
}

- (void)setupTitleLabelWithWidth:(CGFloat)width {
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 15)];
    label.center = CGPointMake(CGRectGetMidX(self.frame) - self.frame.origin.x, CGRectGetMidY(self.frame) + deltaY + 40 - self.frame.origin.y);
    label.font = self.css.fontOfH3;
    label.textColor = self.css.colorOfLessDarkText;
    label.textAlignment = NSTextAlignmentCenter;
    label.tag = 3;
    label.numberOfLines = 0;
    self.titleLabel = label;
}

- (void)setupSubTitleLabelWithWidth:(CGFloat)width {
    UILabel *subTitlelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 15)];
    subTitlelabel.center = CGPointMake(CGRectGetMidX(self.frame) - self.frame.origin.x, CGRectGetMidY(self.frame) + deltaY + 40 - self.frame.origin.y);
    subTitlelabel.font = self.css.fontOfH3;
    subTitlelabel.textColor = self.css.colorOfLessDarkText;
    subTitlelabel.textAlignment = NSTextAlignmentCenter;
    subTitlelabel.tag = 4;
    subTitlelabel.numberOfLines = 0;
    self.subTitleLabel = subTitlelabel;
}

- (void)setupButton {
//    self.button = [NIEDirectionButton buttonWithType:UIButtonTypeCustom];
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.button.layer.borderColor = self.css.colorOfGreenButtonNormal.CGColor;
    self.button.layer.borderWidth = 1.f;
    self.button.layer.cornerRadius = self.css.borderedButtonBorderCornerRadius;
    [self.button addTarget:self action:@selector(onButtton:) forControlEvents:UIControlEventTouchUpInside];
    self.button.frame = CGRectMake(0, 20, 115, 35);
    [self.button setTitle:@"重新加载" forState:UIControlStateNormal];
    [self.button setTitleColor:self.css.colorOfGreenButtonNormal forState:UIControlStateNormal];
    [self.button setTitleColor:self.css.colorOfGreenButtonHightlighted forState:UIControlStateHighlighted];
    self.button.titleLabel.font = self.css.fontOfH2;
}

- (void)addSubviewsToContentView {
   CGRect rect = self.contentView.frame;
    CGFloat contentHeight = CGRectGetHeight(self.imageView.bounds) + CGRectGetHeight(self.titleLabel.bounds) + CGRectGetHeight(self.subTitleLabel.bounds) + CGRectGetHeight(self.button.bounds);
    rect.size.height = contentHeight;
    self.contentView.frame = rect;
    
//    [self.contentView addSubview:self.shimmeringView];
    [self.contentView addSubview:self.gifImageView];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.button];
}

- (CGSize)getLoadingEmptyImageSize {
    UIImage *image = [UIImage imageNamed:@"loadingEmpty"];
    return image.size;
}

- (void)setupImageSize {
    //添加自动布局
    CGSize size = [self getLoadingEmptyImageSize];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGSize imageSize = CGSizeMake(size.width * (screenSize.width / 320.f), size.height * (screenSize.width / 320.f));
    
    self.imageSize = imageSize;
}

- (void)setupDefaultValues {
    self.buttonHidden = YES;
    self.buttonSize = CGSizeMake(100, 30);
    
    self.verticalSpace = 5.f;
    self.buttonTopSpace = 5;
    self.adjustGIFSizeForWidth = YES;
    self.status = FZLoadingViewStatusHidden;
    self.hidden = YES;
    
    [self setupImageSize];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    self.contentView.backgroundColor = backgroundColor;
}

- (void)onTapGesture:(UITapGestureRecognizer *)tapGesture {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(loadingViewDidTap:)]) {
//        [self.delegate loadingViewDidTap:self];
//    }
    if (self.tapViewBlock) {
        self.tapViewBlock(nil);
    }
}

- (void)onButtton:(id)sender {
//    if (self.status == FZLoadingViewStatusEmpty) {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(loadingView:clickButton:)]) {
//            [self.delegate loadingView:self clickButton:sender];
//        }
//    } else {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(loadingViewDidTap:)]) {
//            [self.delegate loadingViewDidTap:self];
//        }
//    }
    
    if (self.clickButtonBlock) {
        self.clickButtonBlock(sender);
    }
    
}

#pragma mark - Property Set

- (void)setButtonHidden:(BOOL)buttonHidden {
    _buttonHidden = buttonHidden;
    [self.button setHidden:buttonHidden];
    
    CGFloat buttonHeight = buttonHidden ? 0 : self.buttonSize.height;
    
    [self.button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(buttonHeight));
    }];
    
}

- (void)setButtonSize:(CGSize)buttonSize {
    _buttonSize = buttonSize;
    
    CGFloat buttonHeight = self.buttonHidden ? 0 : buttonSize.height;

    [self.button mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.greaterThanOrEqualTo(@(buttonSize.width));
        make.height.equalTo(@(buttonHeight));
    }];
}

- (void)setTapGestureEnabled:(BOOL)isEnabled {
    [self.tapGesture setEnabled:isEnabled];
}

- (void)updateConstraintLayoutForImageView:(UIView *)imageView {
    if ([imageView isKindOfClass:[UIImageView class]]) {
        [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.size.equalTo([NSValue valueWithCGSize:self.imageSize]);
            make.centerX.equalTo(self.contentView);
        }];
    } else {
        [imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.size.equalTo([NSValue valueWithCGSize:[self shimmeringViewFrame].size]);
            make.centerX.equalTo(self.contentView);
        }];
    }
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(self.verticalSpace);
        make.leading.equalTo(self.contentView);
        make.trailing.equalTo(self.contentView);
    }];
    
    [self.subTitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(self.verticalSpace);
        make.leading.equalTo(self.contentView);
        make.trailing.equalTo(self.contentView);
    }];
    
    CGFloat buttonHeight = self.buttonHidden ? 0 : self.buttonSize.height;
    [self.button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subTitleLabel.mas_bottom).offset(self.buttonTopSpace);
        make.height.equalTo(@(buttonHeight));
        make.width.greaterThanOrEqualTo(@(self.buttonSize.width));
//        make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(P2PSZ(280), buttonHeight)]);
        make.centerX.equalTo(self.contentView);
    }];
}

#pragma mark - show Public method

- (void)show {
    [self showAnimated:NO completionHandler:nil];
}

- (void)showAnimatedWithoutFinish:(LVAnimationCompletedBlock)completedBlock {
    [self showAnimated:NO completionHandler:completedBlock];
}

- (void)showAnimated:(LVAnimationCompletedBlock)completedBlock {
    [self showAnimated:YES completionHandler:completedBlock];
}

- (void)showAnimated:(BOOL)animated completionHandler:(LVAnimationCompletedBlock)completedBlock {
    [self showAnimated:animated title:nil completionHandler:completedBlock];
}

- (void)showAnimated:(BOOL)animated title:(NSString *)title completionHandler:(LVAnimationCompletedBlock)completedBlock{
    NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"loading@3x" ofType:@"gif"];
    [self showAnimated:animated title:title gifPath:gifPath completionHandler:completedBlock];
}

- (void)showAnimated:(BOOL)animated title:(NSString *)title gifPath:(NSString *)gifPath completionHandler:(LVAnimationCompletedBlock)completedBlock {
    [self showAnimated:animated title:title subTitle:nil gifPath:gifPath completionHandler:completedBlock];
}

- (void)showAnimated:(BOOL)animated title:(NSString *)title subTitle:(NSString *)subTitle completionHandler:(LVAnimationCompletedBlock)completedBlock {
    NSString *gifPath = [[NSBundle mainBundle] pathForResource:@"loading@3x" ofType:@"gif"];
    [self showAnimated:animated title:title subTitle:subTitle gifPath:gifPath completionHandler:completedBlock];
}

- (void)showAnimated:(BOOL)animated title:(NSString *)title subTitle:(NSString *)subTitle gifPath:(NSString *)gifPath completionHandler:(LVAnimationCompletedBlock)completedBlock {

    animated = NO;
    self.status = FZLoadingViewStatusHidden;
    [self.gifImageView setGIFPath:gifPath];
    
    if (!self.adjustGIFSizeForWidth) {
        UIImage *loadingImage = [[UIImage alloc] initWithContentsOfFile:gifPath];
        self.imageSize = loadingImage.size;
    } else {
        self.imageSize = CGSizeMake(P2PSZ(180), P2PSZ(180));
    }
    
    [self updateConstraintLayoutForImageView:self.gifImageView];
    
//    self.shimmeringView.hidden = NO;
    self.gifImageView.hidden = NO;
    self.imageView.hidden = YES;
    
    self.titleLabel.text = title;
    self.subTitleLabel.text = subTitle;
    
    self.button.hidden = YES;
    self.buttonHidden = YES;
    [self.gifImageView startAnimating];
    
    self.hidden = NO;
    
    if(!self.superview) {
        [self.containerView addSubview:self];
    }
    [self.containerView bringSubviewToFront:self];
    if (animated) {
        self.contentView.alpha = 0;
        self.animating = YES;
        
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.alpha = 1;
        } completion:^(BOOL finished) {
            self.animating = NO;
            
            if (finished) {
                if (self.shouldHide) {
                    if (self.animationDelaySEL == @selector(hide)) {
                        [self hide];
                    } else if (self.animationDelaySEL == @selector(hideAnimated:completionHander:)) {
                        [self hideAnimated:self.shouldAnimate completionHander:self.completedBlock];
                    }
                    else if (self.animationDelaySEL == @selector(emptyWithTitle:subTitle:image:)) {
                        [self emptyWithTitle:self.title subTitle:self.subTitle image:self.image];
                    }
                    else if (self.animationDelaySEL == @selector(failedWithTitle:subTitle:image:)) {
                        [self failedWithTitle:self.title subTitle:self.subTitle image:self.image];
                    }
                    self.shouldHide = NO;
                }
                if (completedBlock) {
                    completedBlock(finished);
                }
                
            }
            
        }];
    } else {
        self.animating = NO;
        if (completedBlock) {
            completedBlock(YES);
        }
    }
}

#pragma mark - Failed

- (void)failed {
    //增加无网络判断
    if ([AFNetworkReachabilityManager sharedManager].reachable) {
        [self failedWithTitle:@"网络不给力，啥都刷不出来呢～" subTitle:nil];
    } else {
        [self failedWithTitle:@"您的网络连接已关闭，请手动开启！" subTitle:nil image:[UIImage imageNamed:@"common_nowifi"]];
    }
}

- (void)failedWithTitle:(NSString *)title {
    [self failedWithTitle:title subTitle:nil];
}

- (void)failedWithTitle:(NSString *)title subTitle:(NSString *)subTitle {
   [self failedWithTitle:title subTitle:subTitle image:[UIImage imageNamed:@"common_nowifi"]];
}

- (void)failedWithTitle:(NSString *)title subTitle:(NSString *)subTitle image:(UIImage *)image {
    self.title = title;
    self.subTitle = subTitle;
    self.image = image;
    
    self.buttonTopSpace = 1;
    self.status = FZLoadingViewStatusFailed;
    self.buttonHidden = NO;
    self.button.layer.borderWidth = 1;
//    self.button.layoutDirection = NIEDirectionButtonLayoutHorizontalImageLeft;
    [self.button setBackgroundImage:nil forState:UIControlStateNormal];
    [self.button setBackgroundImage:nil forState:UIControlStateHighlighted];
    [self.button setTitleColor:self.css.colorOfGreenButtonNormal forState:UIControlStateNormal];
    [self.button setTitleColor:self.css.colorOfGreenButtonHightlighted forState:UIControlStateHighlighted];
    
    [self.button setTitle:@"重新加载" forState:UIControlStateNormal];
//    [self.button setImage:[UIImage imageNamed:@"btn_republish_blue"] forState:UIControlStateNormal];
//    [self.button setImage:[UIImage imageNamed:@"btn_republish_blue_pressed"] forState:UIControlStateHighlighted];
    
    [self.button addTarget:self action:@selector(onmyButton:) forControlEvents:UIControlEventTouchUpInside];
    
    if(self.animating){
        self.shouldHide = YES;
        self.animationDelaySEL = @selector(failedWithTitle:subTitle:image:);
    }
    else{
        self.shouldHide = NO;
        self.hidden = NO;
        [self.gifImageView stopAnimating];
        self.imageSize = image.size;
        [self updateConstraintLayoutForImageView:self.imageView];
        
        self.imageView.image = image;
//        self.shimmeringView.hidden = YES;
        self.gifImageView.hidden = YES;
        self.imageView.hidden = NO;
        self.titleLabel.text = title;
        self.subTitleLabel.text = subTitle;
        
        if(!self.superview) {
            [self.containerView addSubview:self];
        }
        [self.containerView bringSubviewToFront:self];
        [self.contentView.layer removeAllAnimations];
        self.contentView.alpha = 1;
        self.tapGesture.enabled = YES;
    }
}


-(void)onmyButton:(id)sender{
        if (self.status == FZLoadingViewStatusFailed) {
            if (self.clickButtonBlock) {
                self.clickButtonBlock(sender);
            }
        }
}

#pragma mark - Empty

- (void)empty {
    [self emptyWithTitle:@"还没有内容呢," subTitle:@"要不去其它页瞧瞧？"];
}

- (void)emptyWithButtonHidden:(BOOL)buttonHidden {
    [self emptyWithTitle:@"还没有内容呢," subTitle:@"要不去其它页瞧瞧？" image:[UIImage imageNamed:@"common_dataempty"] buttonHidden:buttonHidden];
}

- (void)emptyWithTitle:(NSString *)title subTitle:(NSString *)subTitle {
    [self emptyWithTitle:title subTitle:subTitle image:[UIImage imageNamed:@"common_dataempty"]];
}
- (void)emptyWithTitle:(NSString *)title subTitle:(NSString *)subTitle image:(UIImage *)image{
    self.buttonHidden = YES;
    [self emptyWithTitle:title subTitle:subTitle image:image buttonHidden:YES];
}

- (void)emptyWithTitle:(NSString *)title subTitle:(NSString *)subTitle image:(UIImage *)image buttonHidden:(BOOL)buttonHidden {
    
    self.title = title;
    self.subTitle = subTitle;
    self.image = image;
    self.status = FZLoadingViewStatusEmpty;
    
    self.buttonHidden = buttonHidden;
    
    if(self.animating){
        self.shouldHide = YES;
        self.animationDelaySEL = @selector(emptyWithTitle:subTitle:image:);
    }
    else {
        self.shouldHide = NO;
        self.hidden = NO;
        [self.gifImageView stopAnimating];
        self.imageSize = image.size;
        [self updateConstraintLayoutForImageView:self.imageView];
        
        self.imageView.image = image;
//        self.shimmeringView.hidden = YES;
        self.gifImageView.hidden = YES;
        self.imageView.hidden = NO;
        
        self.titleLabel.text = title;
        self.subTitleLabel.text = subTitle;
        
        if(!self.superview) {
            [self.containerView addSubview:self];
        }
        [self.containerView bringSubviewToFront:self];
        [self.contentView.layer removeAllAnimations];
        self.contentView.alpha = 1;
//        self.tapGesture.enabled = self.emptyTapEnabled;
        self.tapGesture.enabled = YES;
    }
}

#pragma mark - Hide

- (void)hide {
    self.status = FZLoadingViewStatusHidden;
    if(self.animating){
        self.shouldHide = YES;
        self.shouldAnimate = NO;
        self.animationDelaySEL = @selector(hide);
    }
    else{
        self.shouldHide = NO;
        [self.gifImageView stopAnimating];
        [self animate:NO whenHide:nil];
    }
}

- (void)animatedHide {
    self.status = FZLoadingViewStatusHidden;
    self.shouldHide = NO;
    [self animate:YES whenHide:nil];
}

- (void)animate:(BOOL)animinate whenHide:(void (^)(void))complete {
    if (animinate) {
//        @weakify(self);
        WEAKSELF
        [UIView animateWithDuration:0.01 animations:^{
//            self.imageView.hidden = YES;
            weakSelf.imageView.hidden = YES;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
//                @strongify(self);
                STRONGSELF
//                self.alpha = 0;
                strongSelf.alpha = 0;
            } completion:^(BOOL finished) {
//                @strongify(self);
                STRONGSELF
//                [self removeFromSuperview];
//                self.hidden = YES;
//                self.imageView.hidden = NO;
//                self.alpha = 1;
//                if (complete) {
//                    complete();
//                }
                [strongSelf removeFromSuperview];
                strongSelf.hidden = YES;
                strongSelf.imageView.hidden = NO;
                strongSelf.alpha = 1;
                if (complete) {
                    complete();
                }
            }];
        }];
    } else {
        [self removeFromSuperview];
        self.hidden = YES;
        if (complete) {
            complete();
        }
    }
}

- (void)hideAnimated:(LVAnimationCompletedBlock)completedBlock {
    [self hideAnimated:YES completionHander:completedBlock];
}

- (void)hideAnimated:(BOOL)animated completionHander:(LVAnimationCompletedBlock)completedBlock {
    animated = NO;
    self.status = FZLoadingViewStatusHidden;
    if(self.animating){
        self.completedBlock = completedBlock;

        self.shouldHide = YES;
        self.shouldAnimate = animated;
        self.animationDelaySEL = @selector(hideAnimated:completionHander:);
    }
    else{
        self.shouldHide = NO;
        self.shouldAnimate = NO;
        [self.gifImageView stopAnimating];
        if (animated) {
            [UIView animateWithDuration:0.2 animations:^{
                self.contentView.alpha = 0;
            } completion:^(BOOL finished) {
                if (finished) {
                    [self removeFromSuperview];
                    self.hidden = YES;
                    if (completedBlock) {
                        completedBlock(finished);
                    }
 
                }
            }];
        } else {
            [self animate:NO whenHide:^{
                if (completedBlock) {
                    completedBlock(YES);
                }
            }];
        }
    }
}

@end

