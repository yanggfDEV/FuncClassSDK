//
//  FZTransitonAnimationImageView.m

//
//  Created by Liuyong on 15-2-10.

//

#import "FZTransitonAnimationImageView.h"

@implementation FZTransitonAnimationImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.animationDuration = 0.6f;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.animationDuration = 0.6f;
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    [super setImage:image];
    
    if (self.transitonAnimation) {
        CATransition *transition = [CATransition animation];
        transition.duration = self.animationDuration;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        [self.layer addAnimation:transition forKey:nil];
    }
}
@end
