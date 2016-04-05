//
//  MessageComposerBarV2.h
//  EnglishTalk
//
//  Created by DING FENG on 1/15/15.
//  Copyright (c) 2015 ishowtalk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioRecordButton.h"


typedef void(^MessageComposer_SendBlock)(NSDictionary *messageDict);

typedef void(^PhotoBtn_tapBlock)(void);
typedef void(^CameraBtn_tapBlock)(void);
typedef void(^ShowsBtn_tapBlock)(void);

typedef void(^Position_changeBlock)(int keyBoardHight);

typedef NS_ENUM(NSInteger, BarStadus) {
    BarStadus_TextComposing  = 0,    //
    BarStadus_TAudioRecording= 1,    //
    BarStadus_TEmojiSelecting= 2,    //
    BarStadus_PlusSelecting  = 3,    //

};


@interface MessageComposerBarV2 : UIView

@property (nonatomic,strong)UIButton   *voiceButton;
@property (nonatomic,strong)UIButton   *faceButton;
@property (nonatomic,strong)UIButton   *sendsButton;
@property (nonatomic,strong)UIButton   *addButton;

@property (nonatomic,strong)UIButton   *photoBtn;
@property (nonatomic,strong)UIButton   *cameraBtn;
@property (nonatomic,strong)UIButton   *showsBtn;

@property (nonatomic,strong)AudioRecordButton   *audioRecordButton;
@property (nonatomic,strong)UITextView *textFields;
@property  (nonatomic) BarStadus  stadus;
@property (nonatomic,weak)   UIView  *contentView;
@property (nonatomic,strong) UIView  *faceView;
@property (nonatomic,strong) UIView  *addImageView;


@property  (nonatomic,strong)  MessageComposer_SendBlock  messageComposer_SendBlock;
@property  (nonatomic,strong)  PhotoBtn_tapBlock  photoBtn_tapBlock;
@property  (nonatomic,strong)  CameraBtn_tapBlock  cameraBtn_tapBlock;
@property  (nonatomic,strong)  ShowsBtn_tapBlock  showsBtn_tapBlock;
@property  (nonatomic,strong)  Position_changeBlock  position_changeBlock;

-(void)resetAllSubViews;
-(void)animationsMove:(int)position;

@end
