//
//  ContinualDubbingNoticeView.m
//  EnglishTalk
//
//  Created by DING FENG on 3/9/15.
//  Copyright (c) 2015 ishowtalk. All rights reserved.
//

#import "ContinualDubbingNoticeView.h"
#import "FZStyleSheet.h"

@implementation ContinualDubbingNoticeView

- (void)awakeFromNib {
    self.alpha=0;
    // Initialization code
    self.frame  = CGRectMake(0, 0, [FZUtils  GetScreeWidth], [FZUtils  GetScreeWidth]*35/320);
    FZStyleSheet *css = [FZStyleSheet currentStyleSheet];
    self.backgroundColor = css.colorOfMainTint;
}

-(void)show{
    self.alpha=1;
    
    double delayInSeconds = 5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.alpha=0;
    });

}

- (IBAction)cancel:(id)sender {
    self.alpha=0;
    
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"%@",[userDefaults  objectForKey:CurrentUnfinishedDubbing]);
//    [userDefaults   setObject:[userDefaults  objectForKey:CurrentUnfinishedDubbing] forKey:CurrentUnfinishedDubbing_forNextLaunch];
    [userDefaults  removeObjectForKey:CurrentUnfinishedDubbing];
    [userDefaults synchronize];
    
    
    
}

- (IBAction)continualDubbing:(id)sender {
    self.alpha=0;
    if (self.noticeTapedBlock) {
        self.noticeTapedBlock();
    }
}



@end
