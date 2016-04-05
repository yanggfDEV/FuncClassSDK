//
//  AudioRecordButton.h
//  EnglishTalk
//
//  Created by DING FENG on 12/12/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//



typedef void(^CurrentTouchLocationChangeBlock)(bool touchInsideBtn);

#import <UIKit/UIKit.h>

@interface AudioRecordButton : UIButton
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

@property  (nonatomic ,strong) CurrentTouchLocationChangeBlock  currentTouchLocationChangeBlock;
@end
