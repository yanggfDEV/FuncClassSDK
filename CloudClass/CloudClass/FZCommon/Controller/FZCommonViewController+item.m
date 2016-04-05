//
//  FZCommonViewController+item.m
//  FunChatStudent
//
//  Created by 刘滔 on 15/9/6.
//  Copyright (c) 2015年 Feizhu Tech. All rights reserved.
//

#import "FZCommonViewController+item.h"
#import <objc/runtime.h>
#import "FZCommonWebViewController.h"

static const void *kJumpUrlKey = &kJumpUrlKey;

@implementation FZCommonViewController (item)

#pragma mark - item定制化配置

- (void)addLeftButtonWithType:(kLeftButtonType)type exitVCType:(kExitVCMode)exitVCMode {
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat iconWidth, iconHeight;
    NSString *iconDefaultName, *iconHighlighName;
    leftButton.tag = exitVCMode;
    
    switch (type) {
        case kLeftButtonTypeOfCloseImage: {
            iconWidth = iconHeight = 22;
            iconDefaultName = @"common_close.png";
            iconHighlighName = @"";
        }
            break;
        case kLeftButtonTypeOfBackImage: {
            
            iconWidth = 10;
            iconHeight = 17;
            iconDefaultName = @"nave_back.png";
            iconHighlighName = @"";
        }
            
        default:
            break;
    }
    CGRect naviRect = self.navigationController.navigationBar.frame;
    CGRect rect = CGRectMake(10, (naviRect.size.height - iconHeight) / 2, iconWidth, iconHeight);
    leftButton.frame = rect;
    
    if (iconDefaultName && iconDefaultName.length > 0) {
        [leftButton setImage:[UIImage imageNamed:iconDefaultName] forState:UIControlStateNormal];
        
        if (iconHighlighName && iconHighlighName.length > 0) {
            [leftButton setImage:[UIImage imageNamed:iconHighlighName] forState:UIControlStateHighlighted];
        }
    }
    
    [leftButton addTarget:self action:@selector(onPressedLeftButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)addRightDescriptionItemWithText:(NSString *)text jumpUrl:(NSString *)url {
    if (!text || !url) {
        return;
    }
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:text style:UIBarButtonItemStylePlain target:self action:@selector(willJumpToDescriptionWebView:)];
    [rightItem setTintColor:[UIColor colorWithHexString:@"439cf4"]];
    [self setJumpToWebviewUrl:url];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark - event

- (void)willJumpToDescriptionWebView:(UIBarButtonItem *)item {
    FZCommonWebViewController *webViewController = [[FZCommonWebViewController alloc] init];
    webViewController.urlString = [self jumpToWebviewUrl];//
    webViewController.titleStr = item.title;
    [self.navigationController pushViewController:webViewController animated:YES];
}

- (void)onPressedLeftButton:(id)sender {
    if ([sender isKindOfClass:[UIButton class]]) {
        switch (((UIButton *)sender).tag) {
            case kExitVCModeOfPop: {
//                [self.baseViewControllerTaskDelegate didTask];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
                break;
            case kExitVCModeOfDismiss: {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark - private function

- (void)setJumpToWebviewUrl:(NSString *)url {
    objc_setAssociatedObject(self, kJumpUrlKey, url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)jumpToWebviewUrl {
    return objc_getAssociatedObject(self, kJumpUrlKey);
}

@end
