//
//  FCInputTextView.m
//  Pods
//
//  Created by FZDubbing on 10/13/15.
//
//

#import "FCInputTextView.h"
#import "Strings.h"

@implementation FCInputTextView

- (void)createUI
{
    
//    self.localPictureButton = [[UIButton alloc] initWithFrame:CGRectZero];
//    [self addSubview:self.localPictureButton];
//    [self.localPictureButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).offset(0);
//        make.bottom.equalTo(self.mas_bottom).offset(0);
////        make.width.equalTo(@40);
////        make.height.equalTo(@44);
//        make.width.equalTo(@0);
//        make.height.equalTo(@0);
//    }];
//    self.localPictureButton.imageEdgeInsets = UIEdgeInsetsMake(11, 15, 11, 0);
//    [self.localPictureButton setImage:[UIImage imageNamed:@"img"] forState:UIControlStateNormal];
//    [self.localPictureButton setImage:[UIImage imageNamed:@"img_pre"] forState:UIControlStateHighlighted];
//    [self.localPictureButton setImage:[UIImage imageNamed:@"img_pre"] forState:UIControlStateSelected];
//    [self.localPictureButton addTarget:self action:@selector(picture:) forControlEvents:UIControlEventTouchUpInside];
    
    self.sendButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self addSubview:self.sendButton];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.bottom.equalTo(self.mas_bottom).offset(-7);
        make.width.equalTo(@60);
        make.height.equalTo(@30);
    }];
    
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = YES;
    
    if(self.commonColorStyle == commonStyle){
        UIColor *sendButtonColor =[UIColor colorWithHexString:@"cecece"];
        
        self.layer.borderColor = [UIColor colorWithHexString:@"cecece"].CGColor;
        self.sendButton.layer.borderColor = sendButtonColor.CGColor;
        [self.sendButton setTitleColor:sendButtonColor forState:UIControlStateNormal];
        self.chatTextView.layer.borderColor = [UIColor colorWithHexString:@"cecece"].CGColor;
        self.chatTextView.textColor = [UIColor colorWithHexString:@"333333"];
        self.backgroundColor = [UIColor whiteColor];
        self.chatTextView.backgroundColor = [UIColor clearColor];
        
//        [self.localPictureButton setImage:[UIImage imageNamed:@"msg_img"] forState:UIControlStateNormal];
//        [self.localPictureButton setImage:[UIImage imageNamed:@"msg_img_pre"] forState:UIControlStateHighlighted];
//        [self.localPictureButton setImage:[UIImage imageNamed:@"msg_img_pre"] forState:UIControlStateSelected];
    }else if (self.commonColorStyle == weiKeStyle){
         UIColor *sendButtonColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
        self.sendButton.layer.borderColor = sendButtonColor.CGColor;
        [self.sendButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
        self.chatTextView.layer.borderColor = sendButtonColor.CGColor;
        self.chatTextView.textColor = [UIColor whiteColor];
        self.chatTextView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
        self.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2].CGColor;
        self.localPictureButton.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
//        [self.localPictureButton setImage:[UIImage imageNamed:@"img"] forState:UIControlStateNormal];
//        [self.localPictureButton setImage:[UIImage imageNamed:@"img_pre"] forState:UIControlStateHighlighted];
//        [self.localPictureButton setImage:[UIImage imageNamed:@"img_pre"] forState:UIControlStateSelected];
        // 添加输入框白底背景
//        UIView *textBackGroundView = [[UIView alloc] initWithFrame:self.chatTextView.frame];
//        textBackGroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
//        [self.chatTextView.superview addSubview:textBackGroundView];
//        [self.chatTextView.superview sendSubviewToBack:textBackGroundView];
    }
    
    self.sendButton.layer.borderWidth = 1;
    self.sendButton.layer.cornerRadius = 4;
    self.sendButton.layer.masksToBounds = YES;
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:14];
//    self.sendButton.titleLabel.textColor = [UIColor colorWithHex:0x888888];

    self.chatTextView = [[SZTextView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.chatTextView];
    [self.chatTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.sendButton.mas_left).offset(-14);
        make.left.equalTo(self.mas_left).offset(10);
        make.bottom.equalTo(self.mas_bottom).offset(-7);
        make.top.equalTo(self.mas_top).offset(7);
    }];
//    self.chatTextView.delegate = self;
//    self.chatTextView.contentInset = UIEdgeInsetsMake(10, 5, 5, 5);
    self.chatTextView.placeholder = @"输入文字..";
    self.chatTextView.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.chatTextView.layer.cornerRadius = 4;
    self.chatTextView.layer.masksToBounds = YES;
    self.chatTextView.layer.borderWidth = 1;
    self.chatTextView.returnKeyType = UIReturnKeySend;
    self.chatTextView.font = [UIFont systemFontOfSize:14];
    self.chatTextView.keyboardType = UIKeyboardTypeDefault;
    [self.chatTextView resignFirstResponder];
}

- (void)picture:(id)sender
{
    [self.inputViewDelegate showpicture];
}

//#pragma mark - UITextViewDelegate
//
//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    [self mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left);
//        make.right.equalTo(self.mas_right);
//        make.bottom.equalTo(self.mas_bottom).offset(-282);
//    }];
//}
//
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
// replacementText:(NSString *)text {
//    
//    NSString *content = textView.text;
//    if([text isEqualToString:@"\n"]){
//        [textView resignFirstResponder];
//        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left);
//            make.right.equalTo(self.mas_right);
//            make.bottom.equalTo(self.mas_bottom);
//            make.height.equalTo(@44);
//        }];
//        return YES;
//    }
//    
//    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left);
//        make.right.equalTo(self.mas_right);
//        make.bottom.equalTo(self.mas_bottom).offset(-282);
//        make.height.equalTo(@(textView.contentSize.height+14));
//    }];
//    
//    [self.chatTextView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@(textView.contentSize.height));
//    }];
//    
//    if (textView.contentSize.height > 100) {
//        
//        [self.chatTextView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@(100));
//        }];
//        
//        textView.text = [textView.text substringToIndex:[textView.text length]-1];
//        return NO;
//    }else{
//        
//        NSMutableString *mutableText = [NSMutableString stringWithString:textView.text];
//        [mutableText appendString:text];
//        textView.text = mutableText;
//        if(textView.contentSize.height > 100){
//            textView.text = content;
//            [self.chatTextView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.equalTo(@(100));
//            }];
//            return NO;
//        }
//        textView.text = content;
//    }
//    return YES;
//}

//    [self.inputViewDelegate presentViewController:imagePicker animated:YES completion:nil];
//}

//#pragma mark - UITextViewDelegate
//
//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    [self mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left);
//        make.right.equalTo(self.mas_right);
//        make.bottom.equalTo(self.mas_bottom).offset(-280);
//        make.height.equalTo(@44);
//    }];
//}
//
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
// replacementText:(NSString *)text {
//    
//    NSString *content = textView.text;
//    if([text isEqualToString:@"\n"]){
//        [textView resignFirstResponder];
//        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left);
//            make.right.equalTo(self.mas_right);
//            make.bottom.equalTo(self.mas_bottom);
//            make.height.equalTo(@44);
//        }];
//        return YES;
//    }
//    
//    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left);
//        make.right.equalTo(self.mas_right);
//        make.bottom.equalTo(self.mas_bottom).offset(-280);
//        make.height.equalTo(@(textView.contentSize.height+14));
//    }];
//    
//    [self.chatTextView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.equalTo(@(textView.contentSize.height));
//    }];
//    
//    if (textView.contentSize.height > 100) {
//        
//        [self.chatTextView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@(100));
//        }];
//        
//        textView.text = [textView.text substringToIndex:[textView.text length]-1];
//        return NO;
//    }else{
//        
//        NSMutableString *mutableText = [NSMutableString stringWithString:textView.text];
//        [mutableText appendString:text];
//        textView.text = mutableText;
//        if(textView.contentSize.height > 100){
//            textView.text = content;
//            [self.chatTextView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.equalTo(@(100));
//            }];
//            return NO;
//        }
//        textView.text = content;
//    }
//    
//    
//    return YES;
//}
//#pragma mark - UIImagePickerControllerDelegate
//
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//{
//    //    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
//    
//    //当选择的类型是图片
//    //    if ([type isEqualToString:@"public.image"]){
//    
//    UIImage *image;
//    if (picker.allowsEditing) {
//        image = [info objectForKey:UIImagePickerControllerEditedImage]; // 获取编辑后的照片
//        UIImage *rightImage = [FCIMChatGetImage rotateImage:image];
//        
//        [self uploadPictureWithData:rightImage];
//    }
//    //    }
//    
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    [self.bottomChatView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.mas_bottom);
//    }];
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (void)uploadPictureWithData:(UIImage *)avatarData
//{
//    NSData *imageData;
//    
//    imageData = UIImageJPEGRepresentation(avatarData, 1);
//    
//    //    WEAKSELF
//    //    [self showLoading];
//    //    [self.getQiniuTokenService queryQiniuToken:[FCUserInfo authToken] successBlock:^(id responseObject) {
//    //        [weakSelf hideLoading];
//    //        if ([weakSelf isValidateResponseData:responseObject]) {
//    //            NSDictionary *dataDic = responseObject[@"data"];
//    //            NSString     *token   = dataDic[@"picture_token"];
//    //
//    //            if (token.length > 0) {
//    //                QNUploadManager *uploadManager = [[QNUploadManager alloc] init];
//    //
//    //                [uploadManager putData:imageData key:[self getImageKey] token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//    //                    if (!resp) {
//    //                        DDLogError(@"上传图片到七牛error：%@",info.error.localizedDescription);
//    //                        [weakSelf showError];
//    //                    } else {
//    //                        NSString *key = resp[@"key"];
//    //
//    //                        if (isAvatar) {
//    //                            // 请求上传头像接口
//    //                            [weakSelf uploadAvatarWithKey:key];
//    //
//    //                        } else {
//    //                            // 请求上传照片接口
//    //                            [weakSelf uploadPicsWithKey:key];
//    //                        }
//    //                    }
//    //                } option:nil];
//    //                return;
//    //            }
//    //        } else {
//    //            if (![weakSelf tokenIsValid:responseObject]) {
//    //                [weakSelf showError];
//    //                return;
//    //            }
//    //        }
//    //
//    //    } failBlock:^(id responseObject, NSError *error) {
//    //        [weakSelf hideLoading];
//    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//    //            if (![weakSelf networkIsReachable]) {
//    //                [weakSelf showText:STR_NO_NETWORK];
//    //            } else {
//    //                [weakSelf showErrorWithText:STR_SERVICE_ERROR];
//    //            }
//    //        });
//    //    }];
//}


@end
