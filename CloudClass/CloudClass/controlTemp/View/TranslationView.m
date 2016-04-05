//
//  TranslationView.m
//  EnglishTalk
//
//  Created by DING FENG on 9/18/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//
#import <AVFoundation/AVBase.h>
#import <Foundation/Foundation.h>
#import "TranslationView.h"

@import AVFoundation;

@implementation TranslationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        
        
    }
    return self;
}

-(id)init
{
    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"TranslationView" owner:nil options:nil];
    self = [nibContents lastObject];
    //[self.addWordButton   setImage:[UIImage  imageNamed:@"word_trans_加入生词本b.png"] forState:UIControlStateSelected];
    self.addWordButton.font = [UIFont systemFontOfSize:13.f];
    [self addWordButtonTitleStateWithWordExist:NO];
    self.resultTextView.editable = NO;
    
    self.frame = CGRectMake(0, 0, [FZUtils  GetScreeWidth], 135);

    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (IBAction)wordAddButton:(UIButton *)sender {
    sender.selected = YES;
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSMutableArray *d = [userDefaults  objectForKey:@"wordList"];
//    NSLog(@"%@",d);
//    
//    
//    NSMutableArray *dd = [[NSMutableArray   alloc]  init];
//    if (d) {
//        dd = [[NSMutableArray   alloc]  initWithArray:d];
//    }
//    [dd  addObject:[NSString  stringWithFormat:@"%@",self.wordLabel.text]];
//    NSMutableSet *set = [[NSMutableSet  alloc]  initWithArray:dd];
//    NSArray *array = [set allObjects];
//    [userDefaults setObject:array forKey:@"wordList"];
//    [userDefaults synchronize];
    
    NSString * word=[NSString  stringWithFormat:@"%@",self.wordLabel.text];
    [self addWords:word];
}

- (IBAction)prononceButtonTap:(UIButton *)sender {
    
    [UIView animateWithDuration:0.02 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        sender.transform = CGAffineTransformMakeScale(1/1.1, 1/1.1);
    } completion:^(BOOL finished)
     {
         sender.transform = CGAffineTransformMakeScale(1., 1.);
         [self  playPronunciation];
         
     }];
}
-(void)playPronunciation{
    
    NSString *word = self.wordLabel.text;

    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *d = [userDefaults  objectForKey:@"wordList"];
    NSLog(@"%@",d);
    
    if ([d  containsObject:word]) {
        self.addWordButton.selected =YES;
    }

    if (word.length>0) {
        NSString  *youdaoString = [NSString  stringWithFormat:@"http://dict.youdao.com/dictvoice?audio=%@",word];
        NSURL *videoUrl = [NSURL URLWithString:youdaoString];
        AVAsset *asset = [AVURLAsset URLAssetWithURL:videoUrl options:nil];
        AVPlayerItem *anItem = [AVPlayerItem playerItemWithAsset:asset];
        anAudioStreamer = [AVPlayer playerWithPlayerItem:anItem];
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *setCategoryError = nil;
        if (![session setCategory:AVAudioSessionCategoryPlayback
                      withOptions:AVAudioSessionCategoryOptionMixWithOthers
                            error:&setCategoryError]) {
        }
        [anAudioStreamer play];
    }
    

}

- (void)addWords:(NSString *)word
{
    
    if([FZLoginUser isUserType:FZLoginUserTypeGuest]){
        [FZCommonTool loginWithSuccessBlock:^{
        } navigationController:self.controller.navigationController title:@"亲,登录后才能加入生词本哦！" cancleText:@"暂不加入" okText:@"立即登录"];
        return;
    }
    
//    [ProgressHUD show:@"请稍等"];
    
    
    //[self.controller startProgressHUD];
    NSString *urlString = [[FZAPIGenerate sharedInstance] API:@"words_add"];
    
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:word,@"word",self.us_phonetic,@"usphonetic",self.explain,@"meaning", nil];
    NSString *jsonString;
    NSString * ss;
    if ([NSJSONSerialization isValidJSONObject:info])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
        jsonString =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"json string:%@",jsonString);
        /*
         json string:{
           "word" : "walkie"
         }*/
        ss = [NSString stringWithFormat:@"[%@]",jsonString];
    }
    
    NSDictionary *parameters = [@{} mutableCopy];
    [parameters setValue:ss forKey:@"word"];
    
    WEAKSELF
    [[FZNetWorkManager sharedInstance] POST:urlString needCache:NO parameters:parameters responseClass:nil success:^(NSInteger statusCode,NSString* message,id dataObject) {
        if(statusCode == 1) {
            [weakSelf.controller showHUDErrorMessage:@"已加入生词本"];
            [weakSelf addWordButtonTitleStateWithWordExist:YES];
        } else {
            [weakSelf addWordButtonTitleStateWithWordExist:NO];
            [weakSelf.controller showHUDErrorMessage:message];
        }
    } failure:^( id responseObject, NSError * error){
        
    }];
}

- (void)addWordButtonTitleStateWithWordExist:(BOOL)isExist
{
    if (isExist) {
        [self.addWordButton setTitle:@"已加入生词本" forState:UIControlStateNormal];
        [self.addWordButton setBackgroundColor:[FZStyleSheet defaultStyleSheet].colorOfGreenButtonDisabled];
        self.addWordButton.userInteractionEnabled = NO;
    } else {
        [self.addWordButton setTitle:@"加入生词本" forState:UIControlStateNormal];
        [self.addWordButton setBackgroundColor:[FZStyleSheet defaultStyleSheet].colorOfGreenButtonNormal];
        self.addWordButton.userInteractionEnabled = YES;
    }
}

//- (void)judgeWordIsAlreadyExist:(NSString *)word
//{
//    WEAKSELF
//    [[FZNetWorkManager sharedInstance] POST:urlString needCache:NO parameters:parameters responseClass:nil success:^(NSInteger statusCode,NSString* message,id dataObject) {
//        if(statusCode == 1) {
//            [weakSelf.controller showHUDErrorMessage:@"已加入生词本"];
//        } else {
//            [weakSelf.controller showHUDErrorMessage:message];
//        }
//    } failure:^( id responseObject, NSError * error){
//        
//    }];
//}



@end
