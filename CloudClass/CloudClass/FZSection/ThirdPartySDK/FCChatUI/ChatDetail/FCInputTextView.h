//
//  FCInputTextView.h
//  Pods
//
//  Created by FZDubbing on 10/13/15.
//
//

#import <UIKit/UIKit.h>
#import "FCIMChatGetImage.h"
#import <Masonry.h>
#import <UIColor+Hex.h>

typedef enum{
    commonStyle,
    weiKeStyle
}commonColorStyle;

@protocol  InputViewDelegate<NSObject>
//显示系统照片
- (void)showpicture;

@end

@interface FCInputTextView : UIView 
@property (strong,nonatomic)UIView *bottomChatView;
@property (strong,nonatomic)UIButton *localPictureButton;
//@property (strong,nonatomic)UITextView *chatTextView;
@property (nonatomic, strong) SZTextView *chatTextView;
@property (strong,nonatomic)UIButton *sendButton;
@property (weak,nonatomic)id <InputViewDelegate>inputViewDelegate;
@property (assign, nonatomic) commonColorStyle commonColorStyle;
- (void)createUI;
@end
