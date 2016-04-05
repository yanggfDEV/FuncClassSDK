//
//  RecordButton.h
//  SimpleAVPlayer
//
//  Created by DING FENG on 5/29/14.
//  Copyright (c) 2014 dinfeng. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger, RecordStadus) {
    Ready = 0,
    Recording = 1,
};


@interface RecordButton : UIButton
@property (nonatomic)   RecordStadus stadus;
@end
