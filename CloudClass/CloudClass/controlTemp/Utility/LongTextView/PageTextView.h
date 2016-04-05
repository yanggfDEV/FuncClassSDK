//
//  PageTextView.h
//  PageTextView
//
//  Created by DING FENG on 7/29/14.
//  Copyright (c) 2014 dingfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageTextView : UIView<UIScrollViewDelegate>

{
    NSAttributedString  *_attributeString;
}





@property (nonatomic,strong)  NSString  *text;
@property (nonatomic,strong)  UIScrollView  *scrollView;
@property (nonatomic,strong)  UIPageControl* pageControl;




@end
