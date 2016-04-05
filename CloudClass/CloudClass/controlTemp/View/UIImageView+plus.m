//
//  UIImageView+plus.m
//  EnglishTalk
//
//  Created by DING FENG on 10/17/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import "UIImageView+plus.h"

@implementation UIImageView (plus)



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    self.alpha = 0.3;
    
    
    [super  touchesBegan:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    //The touch may be cancelled, due to scrolling etc. Restore the alpha if that is the case.
    self.alpha = 1;
    [super  touchesCancelled:touches withEvent:event];

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //Restore the alpha to its original state.
    self.alpha = 1;
    [super  touchesEnded:touches withEvent:event];

}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    self.alpha = 1;
    [super  touchesMoved:touches withEvent:event];

    
}

@end
