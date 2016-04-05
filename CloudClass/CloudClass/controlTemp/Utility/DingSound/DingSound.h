//
//  DingSound.h
//  EnglishTalk
//
//  Created by DING FENG on 9/1/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DingSound : NSObject
+ (DingSound *)sharedInstance;
- (void)keyDown:(int )MIDInotenumber;
- (void)keyUp:(int )MIDInotenumber;
- (void)keyDownUp:(int ) MIDInotenumber;

@end
