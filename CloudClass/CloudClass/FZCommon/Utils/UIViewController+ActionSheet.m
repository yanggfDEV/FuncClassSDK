//
//  UIViewController+ActionSheet.m
//  EnglishTalk
//
//  Created by apple on 15/5/28.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import "UIViewController+ActionSheet.h"
#import "FZCommonHeader.h"
#import "FZUIAlertController.h"

CancelCompletion g_cancelCompletion = nil;
ConfirmCompletion g_confirmCompletion = nil;
NSArray *completionsArray;

@implementation UIViewController (ActionSheet)

- (void)showActionSheetTitle:(NSString *)title
           cancelButtonTitle:(NSString *)cancelButtonTitle
      destructiveButtonTitle:(NSString *)destructiveButtonTitle
            cancelCompletion:(CancelCompletion)cancelCompletion
           confirmCompletion:(ConfirmCompletion)confirmCompletion
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")) {
        
        FZUIAlertController *ac = [FZUIAlertController alertControllerWithTitle:title
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action) {
                                                                 cancelCompletion();
                                                             }];
        
        UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:destructiveButtonTitle
                                                               style:UIAlertActionStyleDestructive
                                                             handler:^(UIAlertAction *action) {
                                                                 confirmCompletion();
                                                             }];
        [ac addAction:cancelAction];
        [ac addAction:logoutAction];
        [self presentViewController:ac animated:YES completion:nil];
    }
    else {
        
        UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                        initWithTitle:title
                                        delegate:self
                                        cancelButtonTitle:cancelButtonTitle
                                        destructiveButtonTitle:destructiveButtonTitle
                                        otherButtonTitles:nil, nil];
        [myActionSheet showInView:self.view];
        
        g_cancelCompletion = cancelCompletion;
        g_confirmCompletion = confirmCompletion;
    }
}

- (void)showActionSheetTitle:(NSString *)title
       clickCompletionTitles:(NSArray*)clickCompletionTitles
            clickCompletions:(NSArray*)clickCompletions;
{
    completionsArray = [clickCompletions copy];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")) {
        
        FZUIAlertController *ac = [FZUIAlertController alertControllerWithTitle:title
                                                                        message:nil
                                                                 preferredStyle:UIAlertControllerStyleActionSheet];
        for(int i = 0; i < completionsArray.count; i++)
        {
            ClickCompletion compleiton = [completionsArray objectAtIndex:i];
            if(i == 0){
                UIAlertAction *action = [UIAlertAction actionWithTitle:[clickCompletionTitles objectAtIndex:i]
                                                                 style:UIAlertActionStyleCancel
                                                               handler:^(UIAlertAction *action) {
                                                                   compleiton();
                                                               }];
                [ac addAction:action];
            }else{
                UIAlertAction *action = [UIAlertAction actionWithTitle:[clickCompletionTitles objectAtIndex:i]
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *action) {
                                                                   compleiton();
                                                               }];
                [ac addAction:action]; 
            }
        }
        
        [self presentViewController:ac animated:YES completion:nil];
    }
    else {
        
        UIActionSheet *myActionSheet = nil;
        if(clickCompletionTitles.count == 2){
            myActionSheet = [[UIActionSheet alloc]
                             initWithTitle:title
                             delegate:self
                             cancelButtonTitle:[clickCompletionTitles objectAtIndex:0]
                             destructiveButtonTitle:nil
                             otherButtonTitles:[clickCompletionTitles objectAtIndex:1], nil];
        }else if(clickCompletionTitles.count == 3){
            myActionSheet = [[UIActionSheet alloc]
                             initWithTitle:title
                             delegate:self
                             cancelButtonTitle:[clickCompletionTitles objectAtIndex:0]
                             destructiveButtonTitle:nil
                             otherButtonTitles:[clickCompletionTitles objectAtIndex:1],[clickCompletionTitles objectAtIndex:2], nil];
        }else if(clickCompletionTitles.count == 4){
            myActionSheet = [[UIActionSheet alloc]
                             initWithTitle:title
                             delegate:self
                             cancelButtonTitle:[clickCompletionTitles objectAtIndex:0]
                             destructiveButtonTitle:nil
                             otherButtonTitles:[clickCompletionTitles objectAtIndex:1],[clickCompletionTitles objectAtIndex:2],[clickCompletionTitles objectAtIndex:3], nil];
        }else if(clickCompletionTitles.count == 5){
            myActionSheet = [[UIActionSheet alloc]
                             initWithTitle:title
                             delegate:self
                             cancelButtonTitle:[clickCompletionTitles objectAtIndex:0]
                             destructiveButtonTitle:nil
                             otherButtonTitles:[clickCompletionTitles objectAtIndex:1],[clickCompletionTitles objectAtIndex:2],[clickCompletionTitles objectAtIndex:3],[clickCompletionTitles objectAtIndex:4], nil];
        }
        
        [myActionSheet showInView:self.view];
    }
}

#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(completionsArray){
        NSInteger count = completionsArray.count - 1;
        ClickCompletion completion = nil;
        if(buttonIndex == count){
           completion = [completionsArray objectAtIndex:0];
        }else{
            completion = [completionsArray objectAtIndex:buttonIndex + 1];
        }
        completion();
        return;
    }
    if (buttonIndex == 0)
    {
        if (g_confirmCompletion) {
           g_confirmCompletion();
        }
    }
    else
    {
        if (g_cancelCompletion) {
            g_cancelCompletion();
        }
    }
}

@end
