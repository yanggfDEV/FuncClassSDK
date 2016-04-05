//
//  CourseDescriptionView.m
//  EnglishTalk
//
//  Created by DING FENG on 6/11/14.
//  Copyright (c) 2014 ishowtalk. All rights reserved.
//

#import "CourseDescriptionView.h"
#import "UITextView+Extras.h"

@interface CourseDescriptionView()<UIScrollViewDelegate>
{
    NSDictionary  *_dataSource;
    UIScrollView  *_descriptionScrollView;
    
    UITextView  *_textView_description;
    UITextView  *_textView_copy;
    
    UILabel  *_label_1;
    UILabel  *_label_2;
    UILabel  *_label_3;
    UIButton  *_button_1;
    UIButton  *_button_2;
    UIButton  *_button_3;
    
    NSArray  *_editors;
    
    
    float labelHeight;
    
    
    float  _textView_description_y_offset;
}
@end
@implementation CourseDescriptionView
@synthesize statisticsNum=_statisticsNum,fiveStarBar=_fiveStarBar;
@synthesize dataSource=_dataSource;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.frame =CGRectMake(0, 0, frame.size.width, 150+44);
        self.backgroundColor = [UIColor colorWithRed:255./255 green:255./255 blue:255./255 alpha:0.3];
        self.layer.cornerRadius = 0.;  // 将图层的边框设置为圆脚
        self.layer.masksToBounds = YES; // 隐藏边界
        self.layer.borderWidth = 0;  // 给图层添加一个有色边框
        self.layer.borderColor = [UIColor colorWithRed:240./255 green:240./255 blue:240./255 alpha:1].CGColor;
        
        _statisticsNum =[[UILabel  alloc]   initWithFrame:CGRectMake(12, -13, 44, 44)];
        _statisticsNum.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:18.0];
        _fiveStarBar = [[FiveStarBar  alloc] initWithFrame:CGRectMake(10+40, 0, 80/1.2, 80/5./1.2)];
        _statisticsNum.text = @"难度";
        _statisticsNum.textColor=[UIColor  grayColor];
        
        _descriptionScrollView   = [[UIScrollView  alloc]  initWithFrame:(self.bounds)];
        _descriptionScrollView.backgroundColor =[UIColor  clearColor];
        _descriptionScrollView.contentSize = CGSizeMake(_descriptionScrollView.frame.size.width*2, _descriptionScrollView.frame.size.height);
        _descriptionScrollView.pagingEnabled =YES;
        _descriptionScrollView.delegate = self;
        _descriptionScrollView.showsHorizontalScrollIndicator =NO;
        
        [self addSubview:_descriptionScrollView];
//        [self addSubview:_statisticsNum];
//        [self addSubview:_fiveStarBar];
        
        self.backgroundColor = [UIColor   clearColor];
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20)];
        self.pageControl.pageIndicatorTintColor = [UIColor colorWithRed:164./255 green:185./255 blue:207./255 alpha:0.5];
        self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:247./255 green:237./255 blue:115./255 alpha:0.5];
        self.pageControl.numberOfPages=2;
        [self addSubview:self.pageControl];
        
         labelHeight = 20;

        //1
        _textView_description_y_offset = 30;
        _textView_description = [[UITextView  alloc]  initWithFrame:CGRectMake(14, _textView_description_y_offset, _descriptionScrollView.frame.size.width-30, _descriptionScrollView.frame.size.height-labelHeight*4-_textView_description_y_offset)];
        _textView_description.editable = NO;
        _textView_description.font =  [UIFont   systemFontOfSize:14];
        
        //2
        _textView_copy = [[UITextView  alloc]  initWithFrame:CGRectMake(_descriptionScrollView.frame.size.width+14, _textView_description_y_offset, _descriptionScrollView.frame.size.width-20, _descriptionScrollView.frame.size.height)];
        /*
         (_descriptionScrollView.frame.size.width+14, 30, _descriptionScrollView.frame.size.width-20, _descriptionScrollView.frame.size.height)
         */
        _textView_copy.editable = NO;
        _textView_copy.font =  [UIFont   systemFontOfSize:14];


        float  p_y = _textView_description_y_offset+_textView_description.contentSize.height+labelHeight*4;//修改
        
        _label_1 = [[UILabel  alloc]  initWithFrame:CGRectMake(20, p_y-labelHeight*4, 60, labelHeight)];
        _label_2 = [[UILabel  alloc]  initWithFrame:CGRectMake(20, p_y-labelHeight*3, 60, labelHeight)];
        _label_3 = [[UILabel  alloc]  initWithFrame:CGRectMake(20, p_y-labelHeight*2, 60, labelHeight)];
        
        _button_1 = [[UIButton  alloc]  initWithFrame:CGRectMake(30+_label_1.frame.size.width, p_y-labelHeight*4, 160, labelHeight)];
        _button_2 = [[UIButton  alloc]  initWithFrame:CGRectMake(30+_label_2.frame.size.width, p_y-labelHeight*3, 160, labelHeight)];
        _button_3 = [[UIButton  alloc]  initWithFrame:CGRectMake(30+_label_3.frame.size.width, p_y-labelHeight*2, 160, labelHeight)];

        
        
        [_descriptionScrollView  addSubview:_label_1];
        [_descriptionScrollView  addSubview:_label_2];
        [_descriptionScrollView  addSubview:_label_3];
        [_descriptionScrollView  addSubview:_textView_description];
        [_descriptionScrollView  addSubview:_textView_copy];
        [_descriptionScrollView  addSubview:_button_1];
        [_descriptionScrollView  addSubview:_button_2];
        [_descriptionScrollView  addSubview:_button_3];

        
        _label_1.backgroundColor =[UIColor   clearColor];
        _label_2.backgroundColor =[UIColor   clearColor];
        _label_3.backgroundColor =[UIColor   clearColor];
        _button_1.backgroundColor =[UIColor   clearColor];
        _button_2.backgroundColor =[UIColor   clearColor];
        _button_3.backgroundColor =[UIColor   clearColor];
        _textView_description.backgroundColor  = [UIColor  clearColor];
        _textView_copy.backgroundColor  = [UIColor  clearColor];


        _label_1.textColor = [UIColor   grayColor];
        _label_2.textColor = [UIColor   grayColor];
        _label_3.textColor = [UIColor   grayColor];
        _label_1.font = [UIFont  systemFontOfSize:14];
        _label_2.font = [UIFont  systemFontOfSize:14];
        _label_3.font = [UIFont  systemFontOfSize:14];
        
        _button_1.titleLabel.font =[UIFont  systemFontOfSize:14];
        _button_2.titleLabel.font =[UIFont  systemFontOfSize:14];
        _button_3.titleLabel.font =[UIFont  systemFontOfSize:14];


        [_button_1  setTitleColor:[UIColor colorWithRed:82./255 green:168./255 blue:92./255 alpha:1] forState:UIControlStateNormal];
        [_button_2  setTitleColor:[UIColor colorWithRed:82./255 green:168./255 blue:92./255 alpha:1] forState:UIControlStateNormal];
        [_button_3  setTitleColor:[UIColor colorWithRed:82./255 green:168./255 blue:92./255 alpha:1] forState:UIControlStateNormal];
        
        _button_3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _button_3.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        
        _button_1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _button_1.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);

        _button_2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _button_2.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }
    return self;
}


-(void)setDataSource:(NSDictionary *)dataSource{
    _dataSource  =dataSource;
    [self  changeUI];
}


-(void)changeUI{
    NSLog(@"changeUI%@",_dataSource);
    if ([_dataSource.allKeys  containsObject:@"editors"]&&[_dataSource.allKeys  containsObject:@"copy"]&&[_dataSource.allKeys  containsObject:@"description"]) {
        
        _textView_description.text = [NSString  stringWithFormat:@"简介：%@",[_dataSource  objectForKey:@"description"]];
        _textView_copy.text = [_dataSource  objectForKey:@"copy"];

        NSArray  *editors =[_dataSource  objectForKey:@"editors"];
        _editors =editors;
        
        if (_editors.count<1) {
            return;
        }
        _button_1.tag = 0;
        _button_2.tag = 1;
        _button_3.tag = 2;
        
        _label_1.text = [NSString  stringWithFormat:@"%@:",[[_editors   objectAtIndex:0]   objectForKey:@"title"]];
        [_button_1  setTitle:[[_editors   objectAtIndex:0]   objectForKey:@"nickname"] forState:UIControlStateNormal];
        [_button_1  addTarget:self action:@selector(buttonTaped:) forControlEvents:UIControlEventTouchUpInside];

        if (_editors.count<2)  {
            return;
        }
        _label_2.text = [NSString  stringWithFormat:@"%@:",[[_editors   objectAtIndex:1]   objectForKey:@"title"]];
        [_button_2  setTitle:[[_editors   objectAtIndex:1]   objectForKey:@"nickname"] forState:UIControlStateNormal];
        [_button_2  addTarget:self action:@selector(buttonTaped:) forControlEvents:UIControlEventTouchUpInside];


        if (_editors.count<3) {
            return;
        }
        _label_3.text = [NSString  stringWithFormat:@"%@:",[[_editors   objectAtIndex:2]   objectForKey:@"title"]];
        [_button_3  setTitle:[[_editors   objectAtIndex:2]   objectForKey:@"nickname"] forState:UIControlStateNormal];
        [_button_3  addTarget:self action:@selector(buttonTaped:) forControlEvents:UIControlEventTouchUpInside];

    }
    
    
    
    UIFont *font = [UIFont systemFontOfSize:14];
    
    NSString  *stringToCalculateHeight = [NSString  stringWithFormat:@"%@",_textView_description.text];
    CGSize size = [stringToCalculateHeight boundingRectWithSize:CGSizeMake(_textView_description.frame.size.width, 1000.0f)
                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                     attributes:@{NSFontAttributeName: font}
                                                        context:nil].size;
    float  p_y = _textView_description_y_offset+size.height+labelHeight*4+33;//修改
    
    
    
    NSLog(@"p_yp_y %f  ",p_y);
    
    if(p_y>200){
        p_y = 200;
    }
    _label_1.frame =CGRectMake(20, p_y-labelHeight*4, 60, labelHeight);
    _label_2.frame =CGRectMake(20, p_y-labelHeight*3, 60, labelHeight);
    _label_3 .frame =CGRectMake(20, p_y-labelHeight*2, 60, labelHeight);
    _button_1.frame =CGRectMake(30+_label_1.frame.size.width, p_y-labelHeight*4, 160, labelHeight);
    _button_2.frame =CGRectMake(30+_label_2.frame.size.width, p_y-labelHeight*3, 160, labelHeight);
    _button_3.frame =CGRectMake(30+_label_3.frame.size.width, p_y-labelHeight*2, 160, labelHeight);
    
    
}


-(void)buttonTaped:(UIButton  *)sender{

    long  index =sender.tag;
    NSString  *userid =[NSString  stringWithFormat:@"%@",[[_editors   objectAtIndex:index]   objectForKey:@"uid"]];
    NSString  *userName =[NSString  stringWithFormat:@"%@",[[_editors   objectAtIndex:index]   objectForKey:@"nickname"]];
//    NSDictionary  *userInfo = @{@"uID":userid,@"uName":userName};
    NSMutableDictionary *userInfo = [@{} mutableCopy];
    [userInfo setValue:userid forKey:@"uid"];
    [userInfo setValue:userName forKey:@"nickname"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Notice_editorNameTaped" object:nil userInfo:userInfo];

}



#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth =_descriptionScrollView.frame.size.width;
    int page = floor((_descriptionScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


/*
 
 
 "album_id" = 0;
 audio = "http://cdn.qupeiyin.cn/2015-05-04/1430710213108.mp3";
 "category_id" = 2;
 check = 1;
 copy = "\U672c\U89c6\U9891\U4ec5\U4f9b\U5b66\U4e60\U4f7f\U7528\Uff01\U5982\U9700\U89c2\U770b\U5b8c\U6574\U7248\Uff0c\U8bf7\U652f\U6301\U6b63\U7248\Uff01
 \n\U89c6\U9891\U6765\U6e90\Uff1a\U201cWoW- Mists of Pandaria - Siege of Orgrimmar Trailer\U201d
 \n\U7248\U6743\U5f52\U5c5e\Uff1aWorld of Warcraft";
 copyright = 1;
 "create_time" = "2015-04-30 09:44";
 description = "\U5927\U6218\U5728\U5373\Uff01\U517d\U4eba\U5927\U519b\U5c31\U8981\U6765\U4e86\Uff01
 \n";
 "dif_level" = 3;
 editor = "\U767b\U9ad8\U671b\U89c1\U6606\U6c60";
 "editor_uid" = 264477;
 editors =         (
 {
 nickname = "\U767b\U9ad8\U671b\U89c1\U6606\U6c60";
 title = "\U4e0a\U4f20";
 uid = 264477;
 },
 {
 nickname = "\U9e7f\U9e7f";
 title = "\U542c\U8bd1";
 uid = 358055;
 },
 {
 nickname = "\U6469\U5361\U661f\U51b0\U4e50\U771f\U662f\U592a\U597d\U4e86";
 title = "\U5ba1\U6821";
 uid = 788085;
 }
 );
 id = 8883;
 "if_subtitle" = 0;
 isalbum = 0;
 ishow = 0;
 pic = "http://7u2nh5.com2.z0.glb.qiniucdn.com/2015-05-05/554844e3df63f.jpg";
 shows = 24;
 sort = "-1816";
 status = 1;
 "subtitle_en" = "http://cdn.qupeiyin.cn/2015-05-05/1430794822.srt";
 "subtitle_num" = 8;
 "subtitle_zh" = 0;
 tag = "WoW- Mists of Pandaria - Siege of Orgrimmar Trailer,World of Warcraft,\U9b54\U517d\U4e16\U754c,\U52a8\U6f2b,\U6e38\U620f,";
 title = "\U5927\U6218\U5728\U5373";
 top = 0;
 "update_time" = 1430799590;
 video = "http://cdn.qupeiyin.cn/2015-04-10/1428666026465.mp4";
 "video_srt" = "http://cdn.qupeiyin.cn/2015-05-05/1430794827775.mp4";
 views = 207;

 
 */



@end
