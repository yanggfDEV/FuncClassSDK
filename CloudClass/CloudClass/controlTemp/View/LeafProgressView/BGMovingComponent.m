//
//  BGMovingComponent.m
//  jm
//
//  Created by lee jory on 09-10-29.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BGMovingComponent.h"
#define RAND_FROM_TO(min, max) (min + arc4random_uniform(max - min + 1))


@implementation BGMovingComponent
@synthesize path;
-(CAAnimation*)animation {
    
    CAKeyframeAnimation* animation;
    animation = [CAKeyframeAnimation animation];
	animation.path = path;
	CGPathRelease(path);
	animation.duration = 3.5;
//	animation.repeatCount = 1;
 	animation.calculationMode = @"paced";
	return animation;
}

//-(CAAnimation*)fadeInOutAnimation{
//	CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"opacity"]; // 透明
//	animation.duration = 7;
//	animation.repeatCount =10000;
//	animation.toValue = [NSNumber numberWithFloat:.1];
//	animation.autoreverses = YES;
//	return animation;
//}

-(void)startMoving{
	 
	
    [self.layer addAnimation:[self animation] forKey:@"position"];
//	[self.layer addAnimation:[self fadeInOutAnimation] forKey:@"opacity"];
	
	self.layer.needsDisplayOnBoundsChange = YES;
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	self.layer.position = CGPointMake(400, 400);        // 目标位置
	self.layer.opacity = 1; // 透明度
}

- (void) dealloc
{
//NSLog(@"deallocdeallocdealloc  %@",path);
    
    
    
    
    
    
    
    
	//CGPathRelease(path);
}


-(void)initPath{
	path = CGPathCreateMutable();
	int udCount = 5;
	int width = self.frame.size.width / udCount ;
	int xOffset = 150;
	int yOffset = 0;
	int waveHeight = 22;


    
    int randOffset =RAND_FROM_TO(-6, 6);
    
    
    
    CGPoint p1 = CGPointMake(width * 7 + xOffset, self.frame.origin.y + yOffset+randOffset);
    CGPoint p2 = CGPointMake(width * 5 + xOffset, self.frame.origin.y + yOffset+randOffset);
    CGPoint p3 = CGPointMake(width * 4 + xOffset, self.frame.origin.y + yOffset);
    CGPoint p4 = CGPointMake(width * 3 + xOffset, self.frame.origin.y + yOffset+randOffset);
    CGPoint p5 = CGPointMake(width * 2 + xOffset, self.frame.origin.y + yOffset);
    CGPoint p6 = CGPointMake(width * 1 + xOffset, self.frame.origin.y + yOffset+randOffset);
    CGPoint p7 = CGPointMake(width * 0 + xOffset, self.frame.origin.y + yOffset+randOffset);
    CGPoint p8 = CGPointMake(width * -1 + xOffset, self.frame.origin.y + yOffset);
	
	 
	CGPathMoveToPoint(path, NULL, p1.x,p1.y);

	CGPathAddQuadCurveToPoint(path, NULL, p1.x+width/4, p1.y - waveHeight, p2.x, p2.y);
	CGPathAddQuadCurveToPoint(path, NULL, p2.x+width/4, p2.y + waveHeight, p3.x, p3.y);
	CGPathAddQuadCurveToPoint(path, NULL, p3.x+width/4, p3.y - waveHeight, p4.x, p4.y);
	CGPathAddQuadCurveToPoint(path, NULL, p4.x+width/4, p4.y + waveHeight, p5.x, p5.y);
	CGPathAddQuadCurveToPoint(path, NULL, p5.x+width/4, p5.y - waveHeight, p6.x, p6.y);
	CGPathAddQuadCurveToPoint(path, NULL, p6.x+width/4, p6.y + waveHeight, p7.x, p7.y);
	CGPathAddQuadCurveToPoint(path, NULL, p7.x+width/4, p7.y - waveHeight, p8.x, p8.y);


}

- (id)initWithFrame:(CGRect)aRect{
	self = [super initWithFrame:aRect];
	if(self != nil){
		[self initPath];
        
        UIImage *leafImg = [UIImage imageNamed:@"形状-1-拷贝"];
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, leafImg.size.width, leafImg.size.height)];
        imgView.image = leafImg;
		imgView.opaque = NO;
 		[self addSubview:imgView];
		[self startMoving];
//		[imgView release];
		
	}
	return self;
}

@end
