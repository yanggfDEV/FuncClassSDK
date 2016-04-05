//
//  TranslationView.h
//  EnglishTalk
//
//  Created by DING FENG on 9/18/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AFNetworking.h>
#import "FZCommonViewController.h"


@interface TranslationView : UIView

{


    AVPlayer *anAudioStreamer;
}
@property (weak, nonatomic) IBOutlet UIButton *addWordButton;
@property (weak, nonatomic) IBOutlet UIButton *prononceButton;
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UITextView *resultTextView;
@property (weak, nonatomic) IBOutlet UILabel *phoneticSymbol;

@property (nonatomic,strong)NSString * explain;
@property (nonatomic,strong) NSString * phonetic;
@property (nonatomic,strong)NSString * us_phonetic;
-(void)playPronunciation;

@property (nonatomic, weak)FZCommonViewController *controller;

@end
