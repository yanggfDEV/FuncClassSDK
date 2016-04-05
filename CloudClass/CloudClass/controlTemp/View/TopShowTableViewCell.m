//
//  TopShowTableViewCell.m
//  EnglishTalk
//
//  Created by DING FENG on 10/28/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import "TopShowTableViewCell.h"
#import "UIImage+plus.h"
@interface TopShowTableViewCell()
{
    UIImageView *_coverImageView;
    UIImageView *_iconViews;
    UIImageView *_iconComments;
    UIView  *_bottomBarView;
}

@end

@implementation TopShowTableViewCell
@synthesize  titleLabel=_titleLabel;
@synthesize hotLabel=_hotLabel;
@synthesize descriptionLabel=_descriptionLabel;
@synthesize authorLabel=_authorLabel;
@synthesize avatar =_avatar;
@synthesize namelabel=_namelabel;
@synthesize ranklabel=_ranklabel;
@synthesize commentNum=_commentNum;
@synthesize collegeName=_collegeName;
@synthesize timeMark = _timeMark;

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)clearContents
{
    self.attachData = nil;
    [self.avatar  setImage:nil];
    self.coverImageView.image =nil;
    self.titleLabel.text=@"";
    self.hotLabel.text=@"";
    self.descriptionLabel.text=@"";
    self.cellType =nil;
    self.collegeName.text =@"";
    self.timeMark.text =@"";
    _ranklabel.layer.backgroundColor = [UIColor colorWithRed:143./255 green:143./255 blue:143./255 alpha:1].CGColor;
}
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [UIView animateWithDuration:0.03 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//        self.transform = CGAffineTransformMakeScale(0.96, 0.96);
//    } completion:^(BOOL finished)
//     {
//         [UIView animateWithDuration:0.02 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
//             self.transform = CGAffineTransformMakeScale(1., 1.);
//         } completion:^(BOOL finished)
//          {}];
//     }];
//    [super touchesBegan:touches withEvent:event];
//}

//-(void)layoutSubviews
//{
//    [super  layoutSubviews];
////    _coverImageView.frame=self.bounds;
////    _titleLabel.frame =CGRectMake(100, 1*192/2./4-20+10, self.bounds.size.width, self.bounds.size.height/4.-5);
////    _titleLabel.textAlignment =NSTextAlignmentLeft;
////    _titleLabel.textColor =[UIColor   grayColor];
////    _hotLabel.frame = CGRectMake(160, 0, 50, 20);
////    _descriptionLabel.frame =CGRectMake(0, 0*192/2./5.+10, self.bounds.size.width, 3*self.bounds.size.height/5.);
////    _iconViews.alpha = 1;
//    NSLog(@"layoutSubviews   ");
//
//    
//}
-(void)addTheSubViews{

    
    [_coverImageView   removeFromSuperview];
    [_titleLabel removeFromSuperview];
    [_timeMark  removeFromSuperview];
    [_hotLabel removeFromSuperview];
    [_commentNum  removeFromSuperview];
    [_collegeName  removeFromSuperview];
    [_authorLabel  removeFromSuperview];
    [_iconViews  removeFromSuperview];
    [_iconComments  removeFromSuperview];
    [_descriptionLabel  removeFromSuperview];
    [_avatar  removeFromSuperview];
    [_namelabel  removeFromSuperview];
    [_bottomBarView  removeFromSuperview];
    [_ranklabel  removeFromSuperview];
    
    
        _coverImageView =  [[UIImageView alloc]   initWithFrame:CGRectMake(0, 0, 320, 192/2.)];
        _coverImageView.backgroundColor =[UIColor colorWithRed:233./255 green:233./255 blue:233./255 alpha:1];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.alpha=1;
        _coverImageView.layer.masksToBounds = YES; // 隐藏边界
        _titleLabel = [[UILabel  alloc  ]  initWithFrame:CGRectMake(100, 1*192/2./4-20+10, self.bounds.size.width, 30)];
        NSString *rawString =@"";
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:rawString];
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, attrString.length)];
        _titleLabel.attributedText =attrString;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.clipsToBounds = NO;
        //        CALayer *textLayer = ((CALayer *)[_titleLabel.layer.sublayers objectAtIndex:0]);
        //        textLayer.shadowColor = [UIColor colorWithRed:25./255 green:58./255 blue:11./255 alpha:1].CGColor;
        //        textLayer.shadowOffset = CGSizeMake(0.0f, 1.0f);
        //        textLayer.shadowOpacity = 1.0f;
        //        textLayer.shadowRadius = 3.0f;
        [_coverImageView  addSubview:_titleLabel];
        _timeMark = [[UILabel  alloc]  initWithFrame:CGRectMake(105, 1*192/2./4-20+44-10, 100, 30)];
        _timeMark.textColor =[UIColor  grayColor];
        _timeMark.text = @"2014.12.23";
        _timeMark.textAlignment = NSTextAlignmentLeft;
        _timeMark.font  = [UIFont  boldSystemFontOfSize:12];
        [_coverImageView  addSubview:_timeMark];
        
        _hotLabel= [[UILabel  alloc  ]  initWithFrame:CGRectMake(160+12, 0, 55, 20)];
        _hotLabel.attributedText =attrString;
        _hotLabel.backgroundColor = [UIColor clearColor];
        _hotLabel.textAlignment = NSTextAlignmentLeft;
        _hotLabel.clipsToBounds = NO;
        _hotLabel.textColor = [UIColor   grayColor];
        _hotLabel.userInteractionEnabled = NO;
        //        CALayer *_hotLabeltextLayer = ((CALayer *)[_hotLabel.layer.sublayers objectAtIndex:0]);
        //        _hotLabeltextLayer.shadowColor = [UIColor colorWithRed:14./255 green:40./255 blue:52./255 alpha:1].CGColor;
        //        _hotLabeltextLayer.shadowOffset = CGSizeMake(0.0f, 1.0f);
        //        _hotLabeltextLayer.shadowOpacity = 1.0f;
        //        _hotLabeltextLayer.shadowRadius = 3.0f;
        
        _commentNum= [[UILabel  alloc  ]  initWithFrame:CGRectMake(108, 0, 100,20)];
        _commentNum.attributedText =attrString;
        _commentNum.backgroundColor = [UIColor clearColor];
        _commentNum.textAlignment = NSTextAlignmentLeft;
        _commentNum.clipsToBounds = NO;
        _commentNum.textColor = [UIColor   grayColor];
        _commentNum.userInteractionEnabled =NO;
        
        //        CALayer *_commentNumtextLayer = ((CALayer *)[_commentNum.layer.sublayers objectAtIndex:0]);
        //        _commentNumtextLayer.shadowColor = [UIColor colorWithRed:14./255 green:40./255 blue:52./255 alpha:1].CGColor;
        //        _commentNumtextLayer.shadowOffset = CGSizeMake(0.0f, 1.0f);
        //        _commentNumtextLayer.shadowOpacity = 1.0f;
        //        _commentNumtextLayer.shadowRadius = 3.0f;
        
        _collegeName = [[UILabel alloc]  initWithFrame:CGRectMake(320-120, -4, 120, 28)];
        _collegeName.textAlignment = NSTextAlignmentRight;
        _collegeName.backgroundColor  = [UIColor  clearColor];
        _collegeName.textColor =[UIColor  whiteColor];
        _collegeName.font  = [UIFont  boldSystemFontOfSize:13];
        _collegeName.text  = @"";
        _collegeName.userInteractionEnabled = NO;
        
        CALayer *__collegeNameNumtextLayer = ((CALayer *)[_collegeName.layer.sublayers objectAtIndex:0]);
        __collegeNameNumtextLayer.shadowColor = [UIColor blackColor].CGColor;
        __collegeNameNumtextLayer.shadowOffset = CGSizeMake(0.0f, 1.0f);
        __collegeNameNumtextLayer.shadowOpacity = 1.0f;
        __collegeNameNumtextLayer.shadowRadius = 3.0f;
        
        _authorLabel= [[UILabel  alloc  ]  initWithFrame:CGRectMake(self.bounds.size.width-50, 3*192/2./5.+14, 60, 2*self.bounds.size.height/5.)];
        _authorLabel.attributedText =attrString;
        _authorLabel.backgroundColor = [UIColor clearColor];
        _authorLabel.textAlignment = NSTextAlignmentLeft;
        _authorLabel.clipsToBounds = NO;
        _authorLabel.textColor =[UIColor   grayColor];
        _authorLabel.backgroundColor = [UIColor   clearColor];
        
        _iconViews=[[UIImageView alloc]  initWithFrame:CGRectMake(0, -2, 13, 22)];
        _iconViews.contentMode = UIViewContentModeScaleAspectFit;
        _iconViews.image =[[UIImage  imageNamed:@"rounded-rectangle-88-copy-3.png"]  imageWithColor:[UIColor  grayColor]];
        [_hotLabel  addSubview:_iconViews];
        
        _iconComments=[[UIImageView alloc]  initWithFrame:CGRectMake(-6, -1.5, 13, 22)];
        _iconComments.contentMode = UIViewContentModeScaleAspectFit;
        _iconComments.image =[[UIImage  imageNamed:@"latestCommentIcon.png"]  imageWithColor:[UIColor  grayColor]];
        [_commentNum  addSubview:_iconComments];
        _commentNum.text = @"  23";
        
        [_coverImageView  addSubview:_hotLabel];
        [_coverImageView  addSubview:_commentNum];
        
        [_coverImageView  addSubview:_authorLabel];
        _descriptionLabel= [[UILabel  alloc  ]  initWithFrame:CGRectMake(0, 0*192/2./5.+10, self.bounds.size.width, 3*self.bounds.size.height/5.)];
        _descriptionLabel.attributedText =attrString;
        _descriptionLabel.backgroundColor = [UIColor clearColor];
        _descriptionLabel.textAlignment = NSTextAlignmentRight;
        _descriptionLabel.clipsToBounds = NO;
        _descriptionLabel.alpha = 0.8;
        
        float  offset =   (320/3. -192/2.)/2.;
        _avatar = [[UIImageView  alloc]  initWithFrame:CGRectMake(_coverImageView.frame.size.height/6+offset, _coverImageView.frame.size.height/6-8, 2*_coverImageView.frame.size.height/3, 2*_coverImageView.frame.size.height/3)];
        _avatar.backgroundColor = [UIColor  clearColor];
        _avatar.alpha = 0.9;
        _avatar.contentMode = UIViewContentModeScaleAspectFit;
        _avatar.layer.cornerRadius = _avatar.frame.size.width/2.;  // 将图层的边框设置为圆脚
        _avatar.layer.masksToBounds = YES; // 隐藏边界
        _avatar.layer.borderWidth = 1;  // 给图层添加一个有色边框
        _avatar.layer.borderColor = [UIColor whiteColor].CGColor;
        _avatar.layer.shadowOffset = CGSizeMake(0, 3);  // 设置阴影的偏移量
        _avatar.layer.shadowRadius = 1.0;  // 设置阴影的半径
        _avatar.layer.shadowColor = [UIColor blackColor].CGColor; // 设置阴影的颜色为黑色
        _avatar.layer.shadowOpacity = 0.1; // 设置阴影的不透明度
        
        _namelabel = [[UILabel  alloc]  initWithFrame:CGRectMake(0, 192/2.-26,192/2., 30)];
        [_namelabel  setText:@""];
        _namelabel.textColor = [UIColor  grayColor];
        _namelabel.alpha = 0.8;
        _namelabel.textAlignment = NSTextAlignmentCenter;
        [_namelabel setFont:[UIFont   boldSystemFontOfSize:13]];
        
        [_coverImageView  addSubview:_avatar];
        [_coverImageView  addSubview:_namelabel];
        [self  addSubview:_coverImageView];
        _bottomBarView  = [[UIView  alloc]  initWithFrame:CGRectMake(0, 192/2.-20, 320, 20)];
        _bottomBarView.backgroundColor =[UIColor  clearColor];
        [_bottomBarView  addSubview:_commentNum];
        [_bottomBarView  addSubview:_hotLabel];
        [_bottomBarView  addSubview:_collegeName];
    
    
        [self  addSubview:_bottomBarView];
        UIImageView  *whiteImagv=[[UIImageView  alloc]  initWithFrame:CGRectMake(-100, -1, self.bounds.size.width+1+100, 192/2.+1)];
        [whiteImagv  setImage:[UIImage  imageNamed:@"whiteBackGround"]];
        whiteImagv.contentMode = UIViewContentModeScaleAspectFill;
        whiteImagv.layer.borderWidth = 0.5;
        whiteImagv.layer.borderColor = [UIColor grayColor].CGColor;
        [_coverImageView   insertSubview:whiteImagv atIndex:0];
        _ranklabel =[[UILabel  alloc]  initWithFrame:CGRectMake(192/2./2+16+offset, 192/2./2, 192/2./5, 12)];
        [_ranklabel  setText:@"1"];
        _ranklabel.textColor = [UIColor  whiteColor];
        _ranklabel.alpha = 0.8;
        _ranklabel.textAlignment = NSTextAlignmentCenter;
        [_ranklabel setFont:[UIFont   boldSystemFontOfSize:9]];
        _ranklabel.layer.cornerRadius = 6;  // 将图层的边框设置为圆脚
        _ranklabel.layer.masksToBounds = YES; // 隐藏边界
        _ranklabel. layer.borderWidth = 1;  // 给图层添加一个有色边框
        _ranklabel. layer.borderColor = [UIColor whiteColor].CGColor;
        _ranklabel.  layer.shadowOffset = CGSizeMake(0, 3);  // 设置阴影的偏移量
        _ranklabel. layer.shadowRadius = 1.0;  // 设置阴影的半径
        _ranklabel. layer.shadowColor = [UIColor blackColor].CGColor; // 设置阴影的颜色为黑色
        _ranklabel. layer.shadowOpacity = 0.1; // 设置阴影的不透明度
        _ranklabel. layer.backgroundColor = [UIColor colorWithRed:143./255 green:143./255 blue:143./255 alpha:1].CGColor;
        [_coverImageView  insertSubview:_ranklabel atIndex:100];
}




@end
