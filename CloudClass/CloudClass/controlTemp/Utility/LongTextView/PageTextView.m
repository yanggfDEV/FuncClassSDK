//
//  PageTextView.m
//  PageTextView
//
//  Created by DING FENG on 7/29/14.
//  Copyright (c) 2014 dingfeng. All rights reserved.
//

#import "PageTextView.h"
#import "UITextView+Extras.h"

#import<CoreText/CoreText.h>
@implementation PageTextView

{

    UITextView  *_targetTextView;
    
    NSRange  _targetRange;
    UIView *_selectionView;

}
@synthesize text=_text;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if  ( self) {
        [self baseInit];
    }
    return self;
}
-(void)baseInit {
    
    CGRect scrollFrame = self.bounds;
    self.scrollView = [[UIScrollView alloc] initWithFrame:scrollFrame];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.bounces=YES;
    self.scrollView.delegate =self;
    [self addSubview:self.scrollView];
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20)];
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:164./255 green:185./255 blue:207./255 alpha:0.5];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:247./255 green:237./255 blue:115./255 alpha:0.5];

}
-(void)setText:(NSString *)text
{
    _text =text;
    
    
    _attributeString = [[NSAttributedString alloc] initWithString:text attributes:@{ NSFontAttributeName : [UIFont fontWithName:@"Avenir-Book" size:12], NSForegroundColorAttributeName :[UIColor colorWithRed:32./255 green:32./255 blue:32./255 alpha:1]}];
    [self  adjustTextFrame];
}

- (CGFloat)textViewHeightForAttributedText:(NSAttributedString *)text andWidth:(CGFloat)width
{
    UITextView *textView = [[UITextView alloc] init];
    [textView setAttributedText:text];
    CGSize size = [textView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}

-(void)adjustTextFrame
{
    
    
    float   heightsum = [self  textViewHeightForAttributedText:_attributeString andWidth:self.frame.size.width];
    float  pageNum =heightsum/(self.frame.size.height-10);
    
    
    
    int   pageNumInt =(int)pageNum+1;
//    NSLog(@" pageNum %f  pageNumInt %d",pageNum,pageNumInt);
//    NSLog(@" _attributeString.length %d",_attributeString.length);
    int pageLenght =_attributeString.length/pageNum;
    NSLog(@" pageLenght %d",pageLenght);
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i =1;i<=pageNumInt;i++)
    {
        int  location =pageLenght*(i-1);
        
        if (pageLenght+location>_attributeString.length)
        {
            pageLenght =_attributeString.length-location;
            NSAttributedString *string = [_attributeString attributedSubstringFromRange:NSMakeRange(location, pageLenght)];
            [array  addObject:string];

        }else{
            NSAttributedString *string = [_attributeString attributedSubstringFromRange:NSMakeRange(location, pageLenght)];
            [array  addObject:string];

        }
    }
//    NSLog(@"%@",array);
    self.scrollView = [[UIScrollView  alloc] initWithFrame:self.bounds];
    [self  addSubview:self.scrollView];
    NSMutableArray *adjustArray = [[NSMutableArray alloc] init];
    
    if (pageNumInt<=1)
    {
        [adjustArray addObject:_attributeString];
    }else{
    
        float  height = [self textViewHeightForAttributedText:[array  objectAtIndex:0] andWidth:self.frame.size.width];
        int    location=0;
        int    totalLength =_attributeString.length;
        int    onePageLenght;
        int    lastLocation = 0;
        while (location<totalLength-1)
        {
            for (onePageLenght=0;onePageLenght<totalLength-location;onePageLenght++)
            {
                NSAttributedString *string = [_attributeString attributedSubstringFromRange:NSMakeRange(location, onePageLenght)];
                float temp =[self textViewHeightForAttributedText:string andWidth:self.frame.size.width];
                if (temp>=height)
                {
                    
                    NSAttributedString *adjuststring = [_attributeString attributedSubstringFromRange:NSMakeRange(location, onePageLenght-1)];
                    [adjustArray addObject:adjuststring];
                    
//                    NSLog(@"adjuststring  \n%@\n",adjuststring);
                    break;
                }
                
            }
//            NSLog(@"%d  %d",location,totalLength);
            lastLocation =location;
            location = location+onePageLenght-1;
        }
//        NSLog(@" lastLocation %d  %d",lastLocation,totalLength);
        if (lastLocation<totalLength)
        {
            NSAttributedString *adjuststring = [_attributeString attributedSubstringFromRange:NSMakeRange(lastLocation, totalLength-lastLocation)];
            [adjustArray addObject:adjuststring];
        }
//        NSLog(@"adjustArray %@",adjustArray);
    
    }
    
    
    pageNumInt = adjustArray.count;
    self.scrollView.contentSize = CGSizeMake(320*pageNumInt, self.frame.size.height);
    for (NSAttributedString *as in adjustArray)
    {
        int index = [adjustArray indexOfObject:as];
        float  PX =index*320;
        float  PY =0;
        
        UITextView *textV = [[UITextView alloc] initWithFrame:CGRectMake(PX, PY, 320, self.frame.size.height)];
        textV.clipsToBounds=NO;
        textV.attributedText =as;
        textV.editable=NO;
        textV.selectable = NO;
        [self.scrollView addSubview:textV];
        
        if (index == (adjustArray.count -1))
        {
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(_handleTap:)];
            [textV addGestureRecognizer:tap];
            _targetTextView =textV;
            NSString *string1 = [as   string];
            NSLog(@" string1 %@",string1);

            NSString *string2 = @"上传by";
            NSRange range = [string1 rangeOfString:string2];
            int location = (int )(range.location);
            NSLog(@" 9090  %d   %lu   %@",location,(unsigned long)string1.length,[as   string]);
            if (location<[as   string].length) {
                NSString *string11 = [as   string];
                
                NSString *string22;
                if (location>1) {
                string22 = [string11 substringFromIndex:location-1];
                }else{
                string22 = @"";
                }
                NSLog(@"string2:%@",string22);
                NSString *string111 = [as   string];
                NSString *string222 = string22;
                NSRange range111 = [string111 rangeOfString:string222];
                
                NSMutableAttributedString *attString = [[NSMutableAttributedString  alloc]  initWithAttributedString:as];
                [attString addAttribute:(NSString *)NSForegroundColorAttributeName
                                  value:[UIColor colorWithRed:141./255 green:195./255 blue:56./255 alpha:1]                                  range:range111];
                textV.attributedText =attString;
                _targetRange =range111;
            }
        }
        
        
    }
    self.scrollView.pagingEnabled = YES;
    self.scrollView.clipsToBounds =NO;
    self.clipsToBounds=NO;
    self.pageControl.numberOfPages=pageNumInt;
    self.scrollView.delegate=self;
    self.scrollView.showsHorizontalScrollIndicator=NO;
    
    if (pageNumInt>1)
    {
        [self addSubview:self.pageControl];
    }
}


#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}



-(void)_handleTap:(UITapGestureRecognizer*)tap{
    
    if(tap.state == UIGestureRecognizerStateRecognized){
        CGPoint tappedPoint = [tap locationInView:_targetTextView];
        [_targetTextView  pointInside:tappedPoint inRange:_targetRange];
        
        NSLog(@"%d",[_targetTextView  pointInside:tappedPoint inRange:_targetRange]);
        NSLog(@"%@",NSStringFromCGRect([_targetTextView  boundingRectForRange:_targetRange]));
        NSLog(@"%@",NSStringFromRange(_targetRange));
        NSLog(@"%lu",(unsigned long)[_targetTextView closestCharacterIndexToPoint:tappedPoint]);

        long   targetIndex =[_targetTextView closestCharacterIndexToPoint:tappedPoint];
        if (targetIndex>_targetRange.location)
        {
            
            
            NSMutableAttributedString *attString = [[NSMutableAttributedString  alloc]  initWithAttributedString:_targetTextView.attributedText];
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                [attString addAttribute:(NSString *)NSForegroundColorAttributeName
                                  value:[UIColor colorWithRed:141./255 green:195./255 blue:56./255 alpha:1]
                                  range:_targetRange];
                _targetTextView.attributedText =attString;
            } completion:^(BOOL finished)
             {
                 
                 [attString addAttribute:(NSString *)NSForegroundColorAttributeName
                                   value:[UIColor colorWithRed:141./255 green:195./255 blue:56./255 alpha:1]
                                   range:_targetRange];
                 
                 _targetTextView.attributedText =attString;
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"Notice_editorNameTaped" object:nil userInfo:nil];
             }];
        }

    }
}


@end
