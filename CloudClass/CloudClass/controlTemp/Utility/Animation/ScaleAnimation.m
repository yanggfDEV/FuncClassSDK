//
//  ScaleAnimation.m
//  VCTransitions
//
//  Created by Tyler Tillage on 9/2/13.
//  Copyright (c) 2013 CapTech. All rights reserved.
//

#import "ScaleAnimation.h"
#import "FZArrangeClassViewController.h"


@interface ScaleAnimation() {
    CGFloat _startScale, _completionSpeed;
    id<UIViewControllerContextTransitioning> _context;
    UIView *_transitioningView;
    UIPinchGestureRecognizer *_pinchRecognizer;
}

-(void)updateWithPercent:(CGFloat)percent;
-(void)end:(BOOL)cancelled;

@end

@implementation ScaleAnimation
@synthesize viewForInteraction = _viewForInteraction;
-(instancetype)initWithNavigationController:(UINavigationController *)controller {
    self = [super init];
    if (self) {
        self.navigationController = controller;
        _completionSpeed = 0.2;
        _pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    }
    return self;
}

-(void)setViewForInteraction:(UIView *)viewForInteraction
{
    if (_viewForInteraction && [_viewForInteraction.gestureRecognizers containsObject:_pinchRecognizer]) [_viewForInteraction removeGestureRecognizer:_pinchRecognizer];
    _viewForInteraction = viewForInteraction;
    [_viewForInteraction addGestureRecognizer:_pinchRecognizer];
}

#pragma mark - Animated Transitioning

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    //Get references to the view hierarchy
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    
    
    CGPoint oringinCenter =toViewController.view.center;
    CGRect touchedCellRect;

    if ([fromViewController  isKindOfClass:[FZArrangeClassViewController  class]])
    {
        touchedCellRect =  ((FZArrangeClassViewController *)fromViewController).touchedZoneFrame;
    }
    else
    if ([toViewController  isKindOfClass:[FZArrangeClassViewController  class]])
    {
        touchedCellRect =  ((FZArrangeClassViewController *)toViewController).touchedZoneFrame;
    }
    CGPoint  touchedCellCenter = CGPointMake(touchedCellRect.origin.x+touchedCellRect.size.width/2., touchedCellRect.origin.y+touchedCellRect.size.height/2.);
    if (self.type == AnimationTypePresent)
    {
        toViewController.view.transform = CGAffineTransformMakeScale(0, 0);
        NSLog(@"touchedCellCenter  \n%@",NSStringFromCGPoint(touchedCellCenter));
        if (touchedCellCenter.y<0||touchedCellCenter.x<0)
        {
            touchedCellCenter  = CGPointMake(160, 160);
        }
        toViewController.view.center =touchedCellCenter;
        [containerView insertSubview:toViewController.view aboveSubview:fromViewController.view];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toViewController.view.center =oringinCenter;
            toViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);

        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    } else if (self.type == AnimationTypeDismiss) {
        [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.center = touchedCellCenter;
            fromViewController.view.transform = CGAffineTransformMakeScale(0.0, 0.0);

        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.4;
}

-(void)animationEnded:(BOOL)transitionCompleted {
    self.interactive = NO;
}

#pragma mark - Interactive Transitioning

-(void)startInteractiveTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    //Maintain reference to context
    _context = transitionContext;
    
    //Get references to view hierarchy
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    //Insert 'to' view into hierarchy
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    //Save reference for view to be scaled
    _transitioningView = fromViewController.view;
}

-(void)updateWithPercent:(CGFloat)percent {
    CGFloat scale = fabsf(percent-1.0);
    _transitioningView.transform = CGAffineTransformMakeScale(scale, scale);
    [_context updateInteractiveTransition:percent];
}

-(void)end:(BOOL)cancelled {
    if (cancelled) {
        [UIView animateWithDuration:_completionSpeed animations:^{
            _transitioningView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
            [_context cancelInteractiveTransition];
            [_context completeTransition:NO];
        }];
    } else {
        [UIView animateWithDuration:_completionSpeed animations:^{
            _transitioningView.transform = CGAffineTransformMakeScale(0.0, 0.0);
        } completion:^(BOOL finished) {
            [_context finishInteractiveTransition];
            [_context completeTransition:YES];
        }];
    }
}

-(void)handlePinch:(UIPinchGestureRecognizer *)pinch {
    CGFloat scale = pinch.scale;
	switch (pinch.state) {
		case UIGestureRecognizerStateBegan:
            _startScale = scale;
            self.interactive = YES;
            [self.navigationController popViewControllerAnimated:YES];
            break;
		case UIGestureRecognizerStateChanged: {
            CGFloat percent = (1.0 - scale/_startScale);
            [self updateWithPercent:(percent < 0.0) ? 0.0 : percent];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            CGFloat percent = (1.0 - scale/_startScale);
            BOOL cancelled = ([pinch velocity] < 5.0 && percent <= 0.3);
            [self end:cancelled];
            break;
        }
        case UIGestureRecognizerStateCancelled: {
            CGFloat percent = (1.0 - scale/_startScale);
            BOOL cancelled = ([pinch velocity] < 5.0 && percent <= 0.3);
            [self end:cancelled];
            break;
        }
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateFailed:
            break;
    }
}


@end
