//
//  searchCells.m
//  EnglishTalk
//
//  Created by apple on 15/4/15.
//  Copyright (c) 2015年 ishowtalk. All rights reserved.
//

#import "searchCells.h"

@implementation searchCells
{
    UIImageView * _image1;
    UIImageView * _image2;
}
- (void)awakeFromNib {
   
    _viewsLabel1=[[UILabel alloc] initWithFrame:CGRectMake(80, 89, 75, 15)];
    _viewsLabel2=[[UILabel alloc] initWithFrame:CGRectMake(240, 89, 75, 15)];
    _viewsLabel1.font=[UIFont systemFontOfSize:10];
    _viewsLabel2.font=_viewsLabel1.font;
    _viewsLabel1.textColor=[UIColor colorWithHexString:@"969696"];
    _viewsLabel2.textColor=_viewsLabel1.textColor;
    
    [self.contentView addSubview:_viewsLabel1];
    [self.contentView addSubview:_viewsLabel2];
    
    
    _titleLabel1.alpha=0;
    _titleLabel2.alpha=0;
    _coverImageView1.alpha=0;
    _coverImageView2.alpha=0;
    _viewsLabel1.alpha=0;
    _viewsLabel2.alpha=0;
   
    _micPhoneIcon1.alpha=0;
    _micPhoneIcon2.alpha=0;
    
    _sectionTagImg1.alpha=0;
    _sectionTagImg2.alpha=0;
    
    CGRect rr=self.micPhoneIcon1.frame;
    rr.size.width=6;
    self.micPhoneIcon1.frame=rr;
    
    rr=self.micPhoneIcon2.frame;
    rr.size.width=6;
    self.micPhoneIcon2.frame=rr;
    
    _viewsLabel1.frame=CGRectMake(122, 89, 30, 15);
    _viewsLabel2.frame=CGRectMake(290, 89, 30, 15);
    _viewsLabel1.textAlignment=NSTextAlignmentLeft;
    _viewsLabel2.textAlignment=NSTextAlignmentLeft;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadData
{
    for(NSInteger i=0;i<self.array.count;i++){
        
        NSDictionary * dict=self.array[i];
        
        switch (i) {
            case 0:
            {
                _infoDict1=dict;
                _titleLabel1.alpha=1;
                _coverImageView1.alpha=1;
                _viewsLabel1.alpha=1;
                _micPhoneIcon1.alpha=1;
                
                
                _titleLabel1.text=[dict objectForKey:@"title"];
                if([[dict objectForKey:@"course_title"]length]>0){
                    _titleLabel1.text=[dict objectForKey:@"course_title"];
                }else if ([[dict objectForKey:@"album_title"]length]>0){
                    _titleLabel1.text=[dict objectForKey:@"album_title"];
                    
                }
                _viewsLabel1.text=[dict objectForKey:@"views"];
                [_coverImageView1  sd_setImageWithURL:[NSURL  URLWithString:[dict  objectForKey:@"pic"]] placeholderImage:[UIImage   imageNamed:@"mainPageDefaultImg"]];
                
                if([[dict objectForKey:@"album_title"] length]>0){
                    _sectionTagImg1.alpha=1;
                }else{
                    _sectionTagImg1.alpha=0;
                }
                
                _titleLabel1.text=[dict objectForKey:@"nickname"];
                    
             //   NSString * time=[dict objectForKey:@"create_time"];
               
                
                _image1.image=[UIImage imageNamed:@"UnChecked"];
                
                NSString *hotString =[NSString  stringWithFormat:@"   %@",[_infoDict1   objectForKey:@"views"]];
                NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:hotString];
                [attrString2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:151./255 green:148./255 blue:143./255 alpha:1] range:NSMakeRange(0, hotString.length)];
                [attrString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, hotString.length)];
                _titleLabel1.attributedText=attrString2;
                
                _titleLabel1.backgroundColor = [UIColor clearColor];
                CALayer *textLayer2 = ((CALayer *)[_titleLabel1.layer.sublayers objectAtIndex:0]);
                textLayer2.shadowColor = [UIColor clearColor].CGColor;
                textLayer2.shadowOffset = CGSizeMake(0.0f, 1.0f);
                textLayer2.shadowOpacity = 1.0f;
                textLayer2.shadowRadius = 4.0f;
                
                
                NSString *titleString =[_infoDict1   objectForKey:@"album_title"];
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:titleString];
                [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:151./255 green:148./255 blue:143./255 alpha:1] range:NSMakeRange(0, titleString.length)];
                [attrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:10] range:NSMakeRange(0, titleString.length)];
               _titleLabel1.attributedText =attrString;
                _titleLabel1.textAlignment = NSTextAlignmentLeft;
                _titleLabel1.textColor =[UIColor colorWithRed:151./255 green:148./255 blue:143./255 alpha:1];
                CALayer *textLayer = ((CALayer *)[_titleLabel1.layer.sublayers objectAtIndex:0]);
                textLayer.shadowColor = [UIColor clearColor].CGColor;
                textLayer.shadowOffset = CGSizeMake(0.0f, 1.0f);
                textLayer.shadowOpacity = 1.0f;
                textLayer.shadowRadius = 2.0f;

                
            }
                break;
            case 1:
            {
                _infoDict2=dict;
                
                _titleLabel2.alpha=1;
                _coverImageView2.alpha=1;
                _viewsLabel2.alpha=1;
                _micPhoneIcon2.alpha=1;
                
                _sectionTagImg2.alpha=0;
                _image2.alpha=1;
                [_coverImageView2     sd_setImageWithURL:[NSURL  URLWithString:[_infoDict2   objectForKey:@"pic"]] placeholderImage:[UIImage   imageNamed:@"mainPageDefaultImg"]];
                _image2.image=[UIImage imageNamed:@"UnChecked"];
                
                NSString *titleString =[_infoDict2   objectForKey:@"title"];
                
                if (titleString==NULL)
                {
                    titleString =[_infoDict2   objectForKey:@"course_title"];
                }
              
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:titleString];
                [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:151./255 green:148./255 blue:143./255 alpha:1] range:NSMakeRange(0, titleString.length)];
                [attrString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:10] range:NSMakeRange(0, titleString.length)];
                _titleLabel2.attributedText =attrString;
                _titleLabel2.textAlignment = NSTextAlignmentLeft;
                _titleLabel2.textColor =[UIColor colorWithRed:151./255 green:148./255 blue:143./255 alpha:1];
                CALayer *textLayer = ((CALayer *)[_titleLabel2.layer.sublayers objectAtIndex:0]);
                textLayer.shadowColor = [UIColor clearColor].CGColor;
                textLayer.shadowOffset = CGSizeMake(0.0f, 1.0f);
                textLayer.shadowOpacity = 1.0f;
                textLayer.shadowRadius = 2.0f;
                
                
                if ( [[_infoDict2   objectForKey:@"views"]   integerValue]>=0)
                {
                    NSString *hotString =[NSString  stringWithFormat:@"   %@",[_infoDict2   objectForKey:@"views"]];
                    NSMutableAttributedString *attrString2 = [[NSMutableAttributedString alloc] initWithString:hotString];
                    [attrString2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:151./255 green:148./255 blue:143./255 alpha:1] range:NSMakeRange(0, hotString.length)];
                    [attrString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(0, hotString.length)];
                    
                    _viewsLabel2.attributedText =attrString2;
                    _viewsLabel2.backgroundColor = [UIColor clearColor];
                    CALayer *textLayer2 = ((CALayer *)[_viewsLabel2.layer.sublayers objectAtIndex:0]);
                    textLayer2.shadowColor = [UIColor clearColor].CGColor;
                    textLayer2.shadowOffset = CGSizeMake(0.0f, 1.0f);
                    textLayer2.shadowOpacity = 1.0f;
                    textLayer2.shadowRadius = 4.0f;
                }
                
                if ([_infoDict2.allKeys  containsObject:@"supports"])
                {
                    
                    
                    [_viewsLabel2  setTextColor:[UIColor colorWithRed:151./255 green:148./255 blue:143./255 alpha:1]];
                    [_viewsLabel2  setFont:[UIFont  systemFontOfSize:7]];
                    
                   // _viewsLabel2.text =[self returnStr:[_infoDict2   objectForKey:@"create_time"]];
                }
                
            }

            default:
                break;
        }
    }

}

- (NSString * )gettime:(NSString * )tt
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    
    NSDate *date=[dateFormatter dateFromString:tt];
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:date];
    long int  timeint =   abs(interval);
    NSString  *timeShow;
    if (timeint<=60)
    {
        timeShow = [NSString  stringWithFormat:@"%ld秒前",timeint];
    }
    else if (timeint<=60*60&&timeint>60)
    {
        timeShow = [NSString  stringWithFormat:@"%ld分钟前",timeint/60];
    }else if(timeint<=60*60*24&&timeint>60*60)
    {
        timeShow = [NSString  stringWithFormat:@"%ld小时前",timeint/3600];
    }else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        NSString *currentDateStr = [dateFormatter stringFromDate:date];
        timeShow = currentDateStr;
    }
    
    return timeShow;
    
}




    
    
@end
