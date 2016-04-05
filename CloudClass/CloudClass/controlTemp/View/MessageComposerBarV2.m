//
//  MessageComposerBarV2.m
//  EnglishTalk
//
//  Created by DING FENG on 1/15/15.
//  Copyright (c) 2015 ishowtalk. All rights reserved.
//


//BarStadus_TextComposing  = 0,    //
//BarStadus_TAudioRecording= 1,    //
//BarStadus_TEmojiSelecting= 2,    //
//



#define SCREEN_WIDTH  ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height-106)



#define  DefaultKeyBoardHeight      216
//#define  TextComposeFeildHeght      50


#define StadusPositionY_0           4.                   //position 0
#define StadusPositionY_1           50.                  //position 1
#define StadusPositionY_2           (216.+50.)           //position 2
#define StadusPositionY_3           (216.+50.)           //position 3

#define WIDTH  ([[UIScreen mainScreen] bounds].size.width)

#define HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define FACE_COUNT_ALL  85

#define FACE_COUNT_ROW  4

#define FACE_COUNT_CLU  7

#define FACE_COUNT_PAGE ( FACE_COUNT_ROW * FACE_COUNT_CLU )

#define FACE_ICON_SIZE  44

#define VIEW_LINE_HEIGHT    24

#define FACE_NAME_HEAD  @"["

#define FACE_NAME_TAIL  @"]"

// 表情转义字符的长度（ /s占2个长度，xxx占3个长度，共5个长度 ）
#define FACE_NAME_LEN   4


#import "MessageComposerBarV2.h"

@interface MessageComposerBarV2()<UITextViewDelegate,UIScrollViewDelegate>
{
    UIButton   *_voiceButton;
    UIButton   *_faceButton;
    UIButton   *_sendsButton;
    UIButton   *_addButton;
    AudioRecordButton   *_audioRecordButton;
    UITextView *_textFields;
    UIView  *_faceView;
    UIView  *_addImageView;
    BarStadus  _stadus;
    float  currentPositionY;
    float  _keyBoardHeight;
    NSDictionary *faceMap;
    UIPageControl * _pageControl;
    UIButton  *_photoBtn;
    UIButton  *_cameraBtn;
    UIButton  *_showsBtn;
    
    float  _offset_keyBoard;//中英文切换 与 标准键盘 高度之间的偏移
    float  _offset_textViewHeight;//textview  多行引起 的高度偏移
    
    NSString  *_textFieldsOldText;
    float  TextComposeFeildHeght;
}
@end

@implementation MessageComposerBarV2
@synthesize voiceButton=_voiceButton;
@synthesize faceButton=_faceButton;
@synthesize addButton=_addButton;
@synthesize sendsButton=_sendsButton;
@synthesize audioRecordButton=_audioRecordButton;
@synthesize textFields=_textFields;
@synthesize stadus=_stadus;
@synthesize faceView=_faceView;
@synthesize addImageView=_addImageView;


@synthesize photoBtn=_photoBtn;
@synthesize cameraBtn=_cameraBtn;
@synthesize showsBtn=_showsBtn;


- (id)init
{
    currentPositionY   = StadusPositionY_1;
    self = [super initWithFrame:CGRectMake(0,SCREEN_HEIGHT-currentPositionY,SCREEN_WIDTH, DefaultKeyBoardHeight+TextComposeFeildHeght)];
    if (self) {
        
        _stadus=0;
        TextComposeFeildHeght = 50;
    }
    return self;
}

-(void)setStadus:(BarStadus)stadus{
    _stadus =stadus;
    NSLog(@"_stadus %ld", _stadus);
    switch (_stadus) {
        case 0:
            NSLog(@"现在可以    写字");
            self.audioRecordButton.hidden=YES;
            self.textFields.hidden=NO;
            self.faceView.hidden=YES;
            self.addImageView.hidden=YES;
            [self  deselectAllButton];
            [self  textFieldsContentChanged];

            break;
        case 1:
            NSLog(@"现在可以    录音");
            _offset_keyBoard = 0;
            _offset_textViewHeight = 0;
            [self.textFields  resignFirstResponder];
            self.textFields.hidden=YES;
            self.audioRecordButton.hidden=NO;
            self.faceView.hidden=YES;
            self.addImageView.hidden=YES;
            [self animationsMove:1];
            break;
        case 2:
            NSLog(@"现在可以    表情");
            _offset_keyBoard = 0;
            self.textFields.hidden=NO;
            self.audioRecordButton.hidden=YES;
            self.faceView.hidden=NO;
            self.addImageView.hidden=YES;
            [self.textFields  resignFirstResponder];
            [self animationsMove:2];
            [self  textFieldsContentChanged];

            break;
        case 3:
            NSLog(@"现在可以    图片");
            _offset_keyBoard = 0;
            self.textFields.hidden=NO;
            self.audioRecordButton.hidden=YES;
            self.faceView.hidden=YES;
            self.addImageView.hidden=NO;
            [self.textFields  resignFirstResponder];
            [self animationsMove:2];
            [self  textFieldsContentChanged];

            break;
        default:
            break;
    }
    
    
 
}




-(void)resetAllSubViews{
    
    NSLog(@"ChatViewController_V2resetAllSubViews");
    
    self.backgroundColor=[UIColor colorWithRed:243./255 green:243./255 blue:243./255 alpha:1];
    //self.frame =CGRectMake(0,SCREEN_HEIGHT-currentPositionY,SCREEN_WIDTH, DefaultKeyBoardHeight+TextComposeFeildHeght);
    self.frame =CGRectMake(0,SCREEN_HEIGHT-(currentPositionY+_offset_textViewHeight+_offset_keyBoard),SCREEN_WIDTH, DefaultKeyBoardHeight+TextComposeFeildHeght);
    //录音按钮   逻辑还是放在 controller  里面吧
    _audioRecordButton=[[AudioRecordButton alloc] initWithFrame:CGRectMake(32+8,7, SCREEN_WIDTH-40*2-40, 36)];
    [_audioRecordButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_audioRecordButton setTitle:@"按住   说话" forState:UIControlStateNormal];
    _audioRecordButton.titleLabel.font=[UIFont systemFontOfSize:14];
    _audioRecordButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    _audioRecordButton.backgroundColor=[UIColor colorWithRed:248./255 green:248./255 blue:248./255 alpha:1];
    _audioRecordButton.layer.cornerRadius=5;
    _audioRecordButton.layer.masksToBounds=YES;
    _audioRecordButton.layer.borderWidth = 0.5;  // 给图层添加一个有色边框
    _audioRecordButton.layer.borderColor = [UIColor colorWithRed:205./255 green:205./255 blue:205./255 alpha:1].CGColor;
    [self addSubview:_audioRecordButton];
    _audioRecordButton.hidden=YES;
    
    //文字输入框
    
    [_textFields  removeFromSuperview];
    _textFields=[[UITextView alloc] initWithFrame:CGRectMake(32+8, 7, SCREEN_WIDTH-80-40, 36)];
    _textFields.delegate=self;
    _textFields.returnKeyType=UIReturnKeySend;//返回键类型
    _textFields.keyboardType=UIKeyboardTypeDefault;//键盘类型
    _textFields.layer.cornerRadius=5;
    _textFields.layer.masksToBounds=YES;
    _textFields.font = [UIFont   systemFontOfSize:18];
    _textFields.textColor = [UIColor  grayColor];
    [self  addSubview:_textFields];
    
    //语音
    [_voiceButton  removeFromSuperview];
    _voiceButton=[[UIButton alloc] initWithFrame:CGRectMake(3, 7, 36, 36)];
    _voiceButton.tag =101;
    [_voiceButton setBackgroundImage:[UIImage imageNamed:@"语言按钮"] forState:UIControlStateNormal];
    [_voiceButton setBackgroundImage:[UIImage imageNamed:@"键盘输入"] forState:UIControlStateSelected];
    [_voiceButton addTarget:self action:@selector(barStaduShouldChangFun:) forControlEvents:UIControlEventTouchUpInside];
    [self  addSubview:_voiceButton];
    
    //表情
    
    [_faceButton  removeFromSuperview];
    _faceButton =[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-32-5-2-40, 7, 36, 36)];
    _faceButton.tag =102;
    _faceButton.layer.cornerRadius = 5;
    [_faceButton setBackgroundImage:[UIImage imageNamed:@"表情c"] forState:UIControlStateNormal];
    [_faceButton setBackgroundImage:[UIImage imageNamed:@"键盘输入"] forState:UIControlStateSelected];
    [_faceButton addTarget:self action:@selector(barStaduShouldChangFun:) forControlEvents:UIControlEventTouchUpInside];
    [self  addSubview:_faceButton];
    [self addFaceView];
    
    
    //添加按钮
    
    [_addButton  removeFromSuperview];
    _addButton =[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-32-5-2, 7, 36, 36)];
    _addButton.tag =103;
    _addButton.layer.cornerRadius = 5;
    [_addButton setBackgroundImage:[UIImage imageNamed:@"groupChat_button_plus"] forState:UIControlStateNormal];
    [_addButton setBackgroundImage:[UIImage imageNamed:@"groupChat_button_plus"] forState:UIControlStateSelected];
    [_addButton addTarget:self action:@selector(barStaduShouldChangFun:) forControlEvents:UIControlEventTouchUpInside];
    [self  addSubview:_addButton];
    [self addTheAddImageView];

    
  //
    [[NSNotificationCenter defaultCenter]  removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]  removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]  removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]  removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)  name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:)  name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:)  name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardDidChangeFrameNotification:)  name:UIKeyboardDidChangeFrameNotification object:nil];
    
}

-(void)barStaduShouldChangFun:(UIButton *)sender{
    
    if (sender.selected) {
        [self  deselectAllButton];
        self.stadus = BarStadus_TextComposing;
        [self.textFields  becomeFirstResponder];
        
    }else{
        [self  deselectAllButton];
        sender.selected = YES;
        
        
        switch (sender.tag) {
            case 101:self.stadus = BarStadus_TAudioRecording;
                break;
            case 102:self.stadus = BarStadus_TEmojiSelecting;
                break;
            case 103:self.stadus = BarStadus_PlusSelecting;
                break;
            default:self.stadus = BarStadus_TextComposing;
                break;
        }
    }
}

-(void)deselectAllButton{
    
    _voiceButton.selected=NO;
    _faceButton.selected=NO;
    _addButton.selected=NO;
}


-(UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *retval = nil;
    // traverse the subviews in backwards order until one returns something
    for( UIView *subview in [ [ self subviews ] reverseObjectEnumerator ] )
        if( ( retval = [ subview hitTest:[ subview convertPoint:point fromView:self ] withEvent:event ] ) )
            break;
    
    if (retval) {
        return retval;
    }else{
        
        //只能判断 子的subviews  没有点中者
        if (point.y<0) {
            NSLog(@"外面发生的点击！");
            _offset_keyBoard = 0;
            _offset_textViewHeight = 0;
            [self  adjustEmojiAndImagePadFrame];
            [self.textFields  resignFirstResponder];
            if (currentPositionY!=StadusPositionY_1) {
                [self animationsMove:1];
            }

        }
        return nil;
    }
}



/*
 
 
 #define StadusPositionY_0           50.                  //position 0
 #define StadusPositionY_1           50.                  //position 1
 #define StadusPositionY_2           (216.+50.)           //position 2
 #define StadusPositionY_3           (216.+50.)           //position 3
 

 */
-(void)animationsMove:(int)position{
    
    switch (position) {
        case 0:
        {
            currentPositionY =StadusPositionY_0;
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//                self.frame =CGRectMake(0,SCREEN_HEIGHT-currentPositionY,SCREEN_WIDTH, DefaultKeyBoardHeight+TextComposeFeildHeght);
                
                self.frame =CGRectMake(0,SCREEN_HEIGHT-(currentPositionY+_offset_textViewHeight+_offset_keyBoard),SCREEN_WIDTH, DefaultKeyBoardHeight+TextComposeFeildHeght);
                
            } completion:^(BOOL finished)
             {
             }];
        }
            break;
        case 1:
        {
            
            
            
            currentPositionY =StadusPositionY_1;
            [self  adjustEmojiAndImagePadFrame];
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.frame =CGRectMake(0,SCREEN_HEIGHT-currentPositionY,SCREEN_WIDTH, DefaultKeyBoardHeight+TextComposeFeildHeght);
            } completion:^(BOOL finished)
             {
                 if (self.position_changeBlock) {
                     self.position_changeBlock(0);
                 }


             }];
        }
            break;
        case 2:
        {
            currentPositionY =StadusPositionY_2;
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//                self.frame =CGRectMake(0,SCREEN_HEIGHT-currentPositionY,SCREEN_WIDTH, DefaultKeyBoardHeight+TextComposeFeildHeght);
                self.frame =CGRectMake(0,SCREEN_HEIGHT-(currentPositionY+_offset_textViewHeight+_offset_keyBoard),SCREEN_WIDTH, DefaultKeyBoardHeight+TextComposeFeildHeght);

            } completion:^(BOOL finished)
             {
                 
                 if (self.position_changeBlock) {
                     self.position_changeBlock(252);
                 }

             }];
        }
            break;
        case 3:
            break;
        default:
            break;
    }
    

}




- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self animationsMove:2];
    self.stadus = BarStadus_TextComposing;
    NSLog(@"textViewShouldBeginEditing");
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    
}

- (void)textViewDidChange:(UITextView *)textView{
    
    [self textFieldsContentChanged];

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    

    if ([@"\n" isEqualToString:text])
    {
        [self sendString:textView.text];
        return NO;
    }
    return YES;
}



-(void)textFieldsContentChanged{
    /*
     2015-05-06 11:44:18.889 EnglishTalk[5156:616762] 我自己都江堰的确是不是也是方法地方的解放军废寝忘食的的方法  3.000000
     2015-05-06 11:44:18.893 EnglishTalk[5156:616762] _textFields.contentSize.height 81.000000
     2015-05-06 11:44:18.894 EnglishTalk[5156:616762] _textFields.frame.size.height 40.947998
     2015-05-06 11:44:19.468 EnglishTalk[5156:616762] 我自己都江堰的确是不是也是方法地方的解放军废寝忘食的的方法d  2.000000
     多了一个字 反而行数变少了!!!!!!
     */
    [_textFields scrollRangeToVisible:NSMakeRange([_textFields.text length], 0)];
    if (_textFields.text.length !=0) {
        NSString *truncatedString = [_textFields.text substringFromIndex:[_textFields.text length] - 1];
        NSLog(@"truncatedString %@",truncatedString);
        int a = [truncatedString characterAtIndex:0];
        if( a > 0x4e00 && a < 0x9fff)
        {
            NSLog(@"汉字");//做相应适配
        }
        else  if([truncatedString  isEqual:FACE_NAME_TAIL]){
            NSLog(@"表情");//做相应适配
        }else{
        
            NSLog(@"english");//做相应适配
            if (_keyBoardHeight==252) { //键盘是中文输入法时候
                return;
            }
        }
    }
    long  textPlusOrMinus  = _textFields.text.length -_textFieldsOldText.length;
    _textFieldsOldText =_textFields.text;
    float rows = round( (_textFields.contentSize.height - _textFields.textContainerInset.top - _textFields.textContainerInset.bottom) / _textFields.font.lineHeight );
    NSLog(@"%@   %ld %f",_textFields.text,(unsigned long)_textFields.text.length,rows);
    float  offset = _textFields.contentSize.height-38;
    if (offset>=102-38) {
        offset=102-38;
    }else{
    
    }
    if (offset<0) {
        offset = 0;
    }
    if (_offset_textViewHeight !=offset){
        long  offsetPlusOrMinus  = offset -_offset_textViewHeight;
        if (offsetPlusOrMinus*textPlusOrMinus>0) {
//            NSLog(@"_textFields.contentSize.height %f",_textFields.contentSize.height);
//            NSLog(@"_textFields.frame.size.height %f",_textFields.frame.size.height);
            _offset_textViewHeight =offset;
            TextComposeFeildHeght = 50 + _offset_textViewHeight;
            [self adjustEmojiAndImagePadFrame];
        }
    }
}



-(void)didMoveToWindow{
    NSLog(@"didMoveToWindow");
        [self  resetAllSubViews];
}

-(void)keyboardWillHide:(id)sender{
    NSLog(@"keyboardWillHide");
    if (self.position_changeBlock) {
        self.position_changeBlock(0);
    }

}


-(void)keyboardDidHide:(id)sender{
    NSLog(@"keyboardDidHide");
    
    switch (self.stadus) {
        case 0:
            [self animationsMove:1];//返回到等待输入状态
            break;
        case 1:
            [self animationsMove:1];//返回到等待输入状态
            break;
        case 2://不动
            break;
        case 3://不动
            break;
        default:
            [self animationsMove:1];
            break;
    }
//    NSLog(@" %ld ",self.stadus);
    
}


-(void)keyboardDidShow:(id)sender{
    NSLog(@"keyboardDidShow");
    _offset_keyBoard = 0;
    float   height=_keyBoardHeight;
    [self animationsMove:2];//先到编辑位置
    if (height>216) {
        float  offset = height-216;
        _offset_keyBoard =offset;
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
           // self.frame =CGRectMake(0,SCREEN_HEIGHT-(currentPositionY+offset),SCREEN_WIDTH, DefaultKeyBoardHeight+TextComposeFeildHeght);
            self.frame =CGRectMake(0,SCREEN_HEIGHT-(currentPositionY+_offset_textViewHeight+_offset_keyBoard),SCREEN_WIDTH, DefaultKeyBoardHeight+TextComposeFeildHeght);
        } completion:^(BOOL finished)
         {
             [self  textFieldsContentChanged];
         }];
        
    }
    
    
    if (self.position_changeBlock) {
        self.position_changeBlock(height);
    }

}




-(void)KeyboardDidChangeFrameNotification:(NSNotification *)notification{
    NSValue* keyboardFrame = [[notification  userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameRect = [keyboardFrame CGRectValue];
    float  Origin_Y =keyboardFrameRect.origin.y;
    float  height = keyboardFrameRect.size.height;
    NSLog(@" Origin_Y%f  height%f ",Origin_Y,height);
    _keyBoardHeight =height;
    
    
    

    //    if (Origin_Y<[UIScreen  mainScreen].bounds.size.height)//  键盘显示的时候
    //    {
    //    }
    // 216   标准的
}



#pragma mark 图片相关

-(void)adjustEmojiAndImagePadFrame{
    
    
    self.frame =CGRectMake(0,SCREEN_HEIGHT-(currentPositionY+_offset_textViewHeight+_offset_keyBoard),SCREEN_WIDTH, DefaultKeyBoardHeight+TextComposeFeildHeght);
    
    

    _textFields.frame = CGRectMake(32+8,7, SCREEN_WIDTH-80-40, 36+_offset_textViewHeight);

    _faceView.frame = CGRectMake(0, 50+_offset_textViewHeight, WIDTH, 216);
    _addImageView.frame = CGRectMake(0, 50+_offset_textViewHeight, WIDTH, 216);
    
    _voiceButton.frame = CGRectMake(3, 7+_offset_textViewHeight, 36, 36);
    _faceButton.frame = CGRectMake(SCREEN_WIDTH-32-5-2-40, 7+_offset_textViewHeight, 36, 36);
    _addButton.frame = CGRectMake(SCREEN_WIDTH-32-5-2, 7+_offset_textViewHeight, 36, 36);
    

}

-(void)addTheAddImageView{//这个地方名字有点起坏了
    [_addImageView  removeFromSuperview];
    _addImageView=[[UIView alloc] initWithFrame:CGRectMake(0, 50, WIDTH, 216)];
    _addImageView.backgroundColor=[UIColor clearColor];
    _addImageView.hidden=YES;
    
    _photoBtn = [[UIButton  alloc]  initWithFrame:CGRectMake(0+20, 20, 57, 57)];
    _cameraBtn = [[UIButton  alloc]  initWithFrame:CGRectMake(57+20+20, 20, 57, 57)];
    _showsBtn = [[UIButton  alloc]  initWithFrame:CGRectMake(114+40+20, 20, 57, 57)];
    
    [_photoBtn setImage:[UIImage  imageNamed:@"照片"] forState:UIControlStateNormal];
    [_cameraBtn setImage:[UIImage  imageNamed:@"拍摄"] forState:UIControlStateNormal];
    [_showsBtn setImage:[UIImage  imageNamed:@"我的作品btn"] forState:UIControlStateNormal];

    UILabel  *_photoBtnLabel = [[UILabel  alloc]  initWithFrame:CGRectMake(0, 57, 57, 20)];
    _photoBtnLabel.text =@"照片";
    UILabel  *_cameraBtnLabel = [[UILabel  alloc]  initWithFrame:CGRectMake(0, 57, 57, 20)];
    _cameraBtnLabel.text =@"拍摄";
    UILabel  *_showsBtnLabel = [[UILabel  alloc]  initWithFrame:CGRectMake(0, 57, 57, 20)];
    _showsBtnLabel.text =@"我的作品";
    
    _photoBtnLabel.font =[UIFont  boldSystemFontOfSize:14];
    _cameraBtnLabel.font =[UIFont  boldSystemFontOfSize:14];
    _showsBtnLabel.font =[UIFont  boldSystemFontOfSize:14];
    _photoBtnLabel.textColor =[UIColor   lightGrayColor];
    _cameraBtnLabel.textColor =[UIColor   lightGrayColor];
    _showsBtnLabel.textColor =[UIColor   lightGrayColor];
    
    _photoBtnLabel.textAlignment =NSTextAlignmentCenter;
    _cameraBtnLabel.textAlignment =NSTextAlignmentCenter;
    _showsBtnLabel.textAlignment =NSTextAlignmentCenter;




    
    [_photoBtn  addSubview:_photoBtnLabel];
    [_cameraBtn  addSubview:_cameraBtnLabel];
    [_showsBtn  addSubview:_showsBtnLabel];

    

    
    
    [_addImageView  addSubview:_photoBtn];
    [_addImageView  addSubview:_cameraBtn];
    [_addImageView  addSubview:_showsBtn];
    [_photoBtn   addTarget:self action:@selector(photoBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_cameraBtn  addTarget:self action:@selector(cameraBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_showsBtn   addTarget:self action:@selector(showsBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self  addSubview:_addImageView];
}



-(void)photoBtn:(id)sender{
    NSLog(@"photoBtn");
    
    if (self.photoBtn_tapBlock) {
        self.photoBtn_tapBlock();
    }
    
    
}
-(void)cameraBtn:(id)sender{
    
    NSLog(@"cameraBtn");
    if (self.cameraBtn_tapBlock) {
        self.cameraBtn_tapBlock();
    }

}
-(void)showsBtn:(id)sender{
    NSLog(@"showsBtn");
    
    if (self.showsBtn_tapBlock) {
        self.showsBtn_tapBlock();
    }

}





#pragma mark 表情相关


-(void)addFaceView{
    
    [_faceView  removeFromSuperview];
    _faceView=[[UIView alloc] initWithFrame:CGRectMake(0, 50, WIDTH, 216)];
    _faceView.backgroundColor=[UIColor clearColor];
    UIScrollView* _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
    _scrollView.pagingEnabled=YES;
    _scrollView.contentSize=CGSizeMake((FACE_COUNT_ALL /FACE_COUNT_PAGE+1)*WIDTH, 200);
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.delegate=self;
    _scrollView.bounces=NO;
    
    //添加PageControl
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(WIDTH/2-60, 190, 100, 16)];
    _pageControl.currentPage = 0;
    _pageControl.currentPageIndicatorTintColor=[UIColor blackColor];
    _pageControl.pageIndicatorTintColor=[UIColor yellowColor];
    _pageControl.numberOfPages = FACE_COUNT_ALL / FACE_COUNT_PAGE + 1;
    
    
    faceMap= [NSDictionary dictionaryWithContentsOfFile:
              [[NSBundle mainBundle] pathForResource:@"_expression_cn"
                                              ofType:@"plist"]];
    
    //添加表情
    for (int i = 1; i <= FACE_COUNT_ALL; i++) {
        UIButton *faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        faceButton.tag = i;
        
        [faceButton addTarget:self
                       action:@selector(faceButton:)
             forControlEvents:UIControlEventTouchUpInside];
        
        //计算每一个表情按钮的坐标和在哪一屏
        float  FACE_ICON_SIZE_offset =(float)(WIDTH   -320.)/FACE_COUNT_CLU;//   屏幕适配
        // 414  375  320  =    55
        CGFloat x = (((i - 1) % FACE_COUNT_PAGE) % FACE_COUNT_CLU) * (FACE_ICON_SIZE +FACE_ICON_SIZE_offset)+ 6+FACE_ICON_SIZE_offset + ((i - 1) / FACE_COUNT_PAGE * WIDTH);
        CGFloat y = (((i - 1) % FACE_COUNT_PAGE) / FACE_COUNT_CLU) * FACE_ICON_SIZE + 8;
        faceButton.frame = CGRectMake( x, y, FACE_ICON_SIZE, FACE_ICON_SIZE);
        
        [faceButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%03d", i]]
                    forState:UIControlStateNormal];
        [faceButton setTitle:[NSString stringWithFormat:@"%03d",i] forState:UIControlStateNormal];
        [faceButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        
        [_scrollView addSubview:faceButton];
    }
    
    //删除键
    UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [delete setBackgroundImage:[UIImage imageNamed:@"删除表情按钮"] forState:UIControlStateNormal];
    [delete addTarget:self action:@selector(deleteClicked:) forControlEvents:UIControlEventTouchUpInside];
    delete.frame = CGRectMake(WIDTH-110, 172, 44, 50);
    
    UIButton *send = [UIButton buttonWithType:UIButtonTypeCustom];
    [send setTitle:@"发送" forState:UIControlStateNormal];
    [send setBackgroundImage:[UIImage imageNamed:@"发送按钮"] forState:UIControlStateNormal];
    [send addTarget:self action:@selector(sendsClicked:) forControlEvents:UIControlEventTouchUpInside];
    [send setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    send.titleLabel.font=[UIFont systemFontOfSize:11];
    send.frame = CGRectMake(WIDTH-60, 172, 44, 50);
    
    [_faceView addSubview:_scrollView];
    [_faceView addSubview:_pageControl];
    [_faceView addSubview:delete];
    [_faceView addSubview:send];
    _faceView.hidden=YES;
    [self  addSubview:_faceView];
}


- (void)faceButton:(UIButton *)btn
{
    NSLog(@"表情被点击");
    
    NSMutableString * str=[NSMutableString stringWithString:_textFields.text];
    NSString * ss=[faceMap objectForKey:btn.titleLabel.text];
    [str appendString:ss];
    _textFields.text=str;
    
    [self  textFieldsContentChanged];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage=scrollView.contentOffset.x/WIDTH;
}


-(void)deleteClicked:(id)sender{
    
    
    
    NSString *inputString=_textFields.text;
    NSMutableString  * mustr =[NSMutableString stringWithString:inputString];
    NSInteger i=0;
    if(inputString.length){
        if([inputString hasSuffix:FACE_NAME_TAIL]){
            for (NSInteger index =inputString.length-1;index>0; index--) {
                unichar ch = [inputString characterAtIndex:index];
                if (ch == '[') {
                    break;
                }else{
                    i++;
                }
            }
            [mustr deleteCharactersInRange:NSMakeRange(inputString.length-i-1, i+1) ];
            _textFields.text=mustr;
        }else{
            NSString *string = [inputString substringToIndex:inputString.length-1];
            _textFields.text=string;
        }
    }
    [self  textFieldsContentChanged];
}
-(void)sendsClicked:(id)sender{
    
    [self sendString:_textFields.text];
}
-(void)sendString:(NSString  *)text{
    
    
    if (text.length==0) {
        return;
    }
//    NSDictionary  *messageInfo = @{@"message":text,@"type":@"text",@"url":@""};
    NSMutableDictionary *messageInfo = [@{} mutableCopy];
    [messageInfo setValue:text forKey:@"message"];
    [messageInfo setValue:@"text" forKey:@"type"];
    [messageInfo setValue:@"" forKey:@"url"];
    
    if (self.messageComposer_SendBlock) {
        self.messageComposer_SendBlock(messageInfo);
    }
    self.textFields.text =@"";
    _offset_textViewHeight = 0;
    [self  adjustEmojiAndImagePadFrame];
}



-(void)dealloc{
    [[NSNotificationCenter defaultCenter]  removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]  removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]  removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]  removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    NSLog(@"MessageComposerBarV2 dealloc");
}


@end
