//
//  FZCourseIntroViewController.m
//  CloudClass
//
//  Created by guangfu yang on 16/3/14.
//  Copyright © 2016年 yangguangfu. All rights reserved.
//

#import "FZCourseIntroViewController.h"

@interface FZCourseIntroViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *courseTitle;
@property (weak, nonatomic) IBOutlet UILabel *teacherName;
@property (weak, nonatomic) IBOutlet UILabel *courseTime;
@property (weak, nonatomic) IBOutlet UILabel *courseHumanNumber;
@property (weak, nonatomic) IBOutlet UILabel *courseDetail;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewDetail;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *courseDetailTop;

@end

@implementation FZCourseIntroViewController
{
    float lastContentOffset;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    FZStyleSheet *css = [[FZStyleSheet alloc] init];
    self.courseTitle.font = css.fontOfH7;
    self.courseTitle.textColor = css.color_3;
    
    self.teacherName.font = css.fontOfH4;
    self.teacherName.textColor = css.color_4;
    
    self.courseTime.font = css.fontOfH4;
    self.courseTime.textColor = css.color_4;
    
    self.courseHumanNumber.font = css.fontOfH4;
    self.courseHumanNumber.textColor = css.color_4;
    
    self.courseDetail.numberOfLines = 100;
    self.courseDetail.font = css.fontOfH4;
    self.courseDetail.textColor = css.color_4;
}

- (void)setUpDataWithModel:(FZCourseInfoModel*)infoModel{
    
    self.courseTitle.text = infoModel.course_title;
    self.teacherName.text = infoModel.nickname;
    NSString *courseNum = [NSString stringWithFormat:@"%@", infoModel.course_sub_num];
    self.courseTime.text = [NSString stringWithFormat:@"%@—%@ ( %@课时 )",[NSString getTimeString:infoModel.start_time.integerValue],[NSString getTimeString:infoModel.end_time.integerValue], courseNum];
    self.courseHumanNumber.text = [NSString stringWithFormat:@"%@/%@",infoModel.bespeak_num,infoModel.max_num];
    if (infoModel.course_pic && ![infoModel.course_pic isEqualToString:@""]) {
        [self.imageViewDetail sd_setImageWithURL:[NSURL URLWithString:[infoModel.course_pic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]] placeholderImage:[UIImage imageNamed:@"common_img_index_poster"] completed:nil];
    }
    if (infoModel.course_desc) {
        self.courseDetail.text = infoModel.course_desc;
    } else {
        self.courseDetailTop.constant = - 20.5;
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
//    if (self.imageViewDetail.hidden) {
//        CGFloat height = CGRectGetMaxY(self.courseDetail.frame);
//        CGRect frame = self.backView.frame;
//        frame.size.height = height;
//        self.backView.frame = frame;
//        self.view.frame = frame;
//        self.backScrollView.frame = frame;
//    } else {
//        CGFloat height = CGRectGetMaxY(self.imageViewDetail.frame);
//        CGRect frame = self.backView.frame;
//        frame.size.height = height;
//        self.backView.frame = frame;
//        self.view.frame = frame;
//        self.backScrollView.frame = frame;
//    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    lastContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (lastContentOffset < scrollView.contentOffset.y) {
        if (self.upScrollBlock) {
            self.upScrollBlock();
        }
    }else{
        if (self.downScrollBlock) {
            self.downScrollBlock();
        }
    }
}


@end
