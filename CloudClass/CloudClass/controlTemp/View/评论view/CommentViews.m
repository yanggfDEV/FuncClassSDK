//
//  CommentViews.m
//  EnglishTalk
//
//  Created by apple on 14-12-9.
//  Copyright (c) 2014年 ishowtalk. All rights reserved.
//

#import "CommentViews.h"

#define WIDTH  self.bounds.size.width
#define HEIGHT self.bounds.size.height
//
//#define FACE_COUNT_ALL  85
//
//#define FACE_COUNT_ROW  4
//
//#define FACE_COUNT_CLU  7
//
//#define FACE_COUNT_PAGE ( FACE_COUNT_ROW * FACE_COUNT_CLU )
//
//#define FACE_ICON_SIZE  44
//
//#define VIEW_LINE_HEIGHT    24

@implementation CommentViews
{
//    UIScrollView * _scrollView;//显示图片
//    UIPageControl * _pageControl;
//    UIView * faceView;

    NSInteger count;
   
}
- (id)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame]){
        
        [self addSubviews];
        //[self addfaceviews];
        
       // [self insertSubview:faceView aboveSubview:self];
       // faceView.alpha=0;
    }
    
    return self;
}

//#pragma mark -表情按钮
//- (void)addfaceviews
//{
//    //添加表情view
//    faceView=[[UIView alloc] initWithFrame:CGRectMake(0, 20, WIDTH, 220)];
//    
//    _scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
//    _scrollView.pagingEnabled=YES;
//    _scrollView.contentSize=CGSizeMake((FACE_COUNT_ALL /FACE_COUNT_PAGE+1)*WIDTH, 200);
//    _scrollView.showsHorizontalScrollIndicator=NO;
//    _scrollView.showsVerticalScrollIndicator=NO;
//    _scrollView.delegate=self;
//    _scrollView.bounces=NO;
//    
//    
//    //添加PageControl
//    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(WIDTH/2-50, 205, 100, 20)];
//    _pageControl.currentPage = 0;
//    _pageControl.currentPageIndicatorTintColor=[UIColor blackColor];
//    _pageControl.pageIndicatorTintColor=[UIColor yellowColor];
//    _pageControl.numberOfPages = FACE_COUNT_ALL / FACE_COUNT_PAGE + 1;
//    
//    //添加表情
//    for (int i = 1; i <= FACE_COUNT_ALL; i++) {
//        
//        UIButton *faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        faceButton.tag = i;
//        
//        [faceButton addTarget:self
//                       action:@selector(faceButton:)
//             forControlEvents:UIControlEventTouchUpInside];
//        
//        //计算每一个表情按钮的坐标和在哪一屏
//        CGFloat x = (((i - 1) % FACE_COUNT_PAGE) % FACE_COUNT_CLU) * FACE_ICON_SIZE + 6 + ((i - 1) / FACE_COUNT_PAGE * WIDTH);
//        CGFloat y = (((i - 1) % FACE_COUNT_PAGE) / FACE_COUNT_CLU) * FACE_ICON_SIZE + 8;
//        faceButton.frame = CGRectMake( x, y, FACE_ICON_SIZE, FACE_ICON_SIZE);
//        
//        [faceButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%03d", i]]
//                    forState:UIControlStateNormal];
//        
//        
//        [faceButton setTitle:[NSString stringWithFormat:@"/s%03d",i] forState:UIControlStateNormal];
//        
//        
//        [_scrollView addSubview:faceButton];
//    }
//    
//    
//    //删除键
//    UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
//    [delete setTitle:@"删除" forState:UIControlStateNormal];
//    
//    [delete setImage:[UIImage imageNamed:@"del_emoji_normal"] forState:UIControlStateNormal];
//    [delete setImage:[UIImage imageNamed:@"del_emoji_select"] forState:UIControlStateSelected];
//    [delete addTarget:self action:@selector(deleteFace) forControlEvents:UIControlEventTouchUpInside];
//    delete.frame = CGRectMake(WIDTH-50, 220, 38, 10);
//    
//    [faceView addSubview:_scrollView];
//    [faceView addSubview:_pageControl];
//    [faceView addSubview:delete];
//}
//
//- (void)faceButton:(UIButton *)btn
//{
//    
//}
//
//- (void)deleteFace
//{
//    
//}

#pragma mark -主键
- (void)addSubviews
{
    
    // 添加表情view
    self.backview=[[UIView alloc] initWithFrame:CGRectMake(0, 230, WIDTH, HEIGHT-230)];
    self.backview.backgroundColor=[UIColor yellowColor];
    [self addSubview:self.backview];
    
    //语音
    self.voiceButton=[[UIButton alloc] initWithFrame:CGRectMake(5, 9, 32, 32)];
    [self.voiceButton setBackgroundImage:[UIImage imageNamed:@"语言按钮"] forState:UIControlStateNormal];
    [self.voiceButton setBackgroundImage:[UIImage imageNamed:@"语音按钮—按下"] forState:UIControlStateSelected];
    [self.voiceButton addTarget:self action:@selector(voiceClicked:) forControlEvents:UIControlEventTouchUpInside];
   
    //表情
    self.faceButton =[[UIButton alloc] initWithFrame:CGRectMake(WIDTH-32-5, 9, 32, 32)];
    self.voiceButton.layer.cornerRadius = 5;
    [self.faceButton setBackgroundImage:[UIImage imageNamed:@"表情c"] forState:UIControlStateNormal];
    [self.faceButton setBackgroundImage:[UIImage imageNamed:@"表情—按下"] forState:UIControlStateSelected];
    [self.faceButton addTarget:self action:@selector(faceClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //textView
    self.textfield=[[UITextField alloc] initWithFrame:CGRectMake(32+8, 8, WIDTH-40*2, 38)];
    self.textfield.textColor=[UIColor blackColor];
    self.textfield.font=[UIFont fontWithName:@"Arial" size:14];
    self.textfield.delegate=self;
    self.textfield.backgroundColor=[UIColor whiteColor];
    self.textfield.returnKeyType=UIReturnKeyGo;//返回键类型
    self.textfield.keyboardType=UIKeyboardTypeDefault;//键盘类型
    self.textfield.autoresizingMask=UIViewAutoresizingFlexibleHeight;//自适应高度
    self.textfield.layer.cornerRadius=5;
    self.textfield.layer.masksToBounds=YES;
    
    [self.backview addSubview:self.voiceButton];
    [self.backview addSubview:self.faceButton];
    [self.backview addSubview:self.textfield];
}

#pragma mark -语音按钮点击
- (void)voiceClicked:(UIButton *)button
{
    
}
#pragma mark -表情按钮被点击
- (void)faceClicked:(UIButton *)button
{
    static NSInteger first=0;
    
    count++;
    
    if(first %2==0 ){
        
        [self.delegate insertview];
        
        [button setBackgroundImage:[UIImage imageNamed:@"键盘输入"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"键盘输入-按下"] forState:UIControlStateNormal];
        
       // [self dismisskeyBoard];
        
    }else{
        
        [button setBackgroundImage:[UIImage imageNamed:@"表情c"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"表情-按下"] forState:UIControlStateNormal];
        
//        [self showkeyBoard];
    }
    
    first++;
    

}

- (void)dismisskeyBoard
{
    
}

- (void)showkeyBoard
{
    
}



#pragma mark -textField的代理方法
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame=self.backview.frame;
    frame.origin.y=180;
    self.backview.frame=frame;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect frame=self.backview.frame;
    frame.origin.y=200;
    self.backview.frame=frame;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    CGRect frame=self.backview.frame;
    frame.origin.y=HEIGHT-50;
    self.backview.frame=frame;
    
    return YES;
}



@end
