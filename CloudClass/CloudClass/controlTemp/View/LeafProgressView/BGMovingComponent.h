//
//  BGMovingComponent.h
//  jm
//
//  Created by lee jory on 09-10-29.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/CoreAnimation.h>
#import <UIKit/UIKit.h>

@interface BGMovingComponent : UIView {
	UIImageView *imgView;
	CGMutablePathRef path;
}

-(void)initPath;

@property(assign) CGMutablePathRef path;
@end
